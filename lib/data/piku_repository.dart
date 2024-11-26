import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';

import '../piku_callbacks.dart';
import 'local/entity/piku_user.dart';
import 'local/local_storage.dart';
import 'remote/piku_client_exception.dart';
import 'remote/requests/piku_action_data.dart';
import 'remote/requests/piku_new_message_request.dart';
import 'remote/responses/piku_event.dart';
import '../piku_client.dart';
import 'remote/service/piku_client_service.dart';

/// Handles interactions between piku client api service[clientService] and
/// [localStorage] if persistence is enabled.
///
/// Results from repository operations are passed through [callbacks] to be handled
/// appropriately
abstract class PikuRepository {
  @protected
  final PikuClientService clientService;
  @protected
  final LocalStorage localStorage;
  @protected
  PikuCallbacks callbacks;
  final List<StreamSubscription> _subscriptions = [];

  PikuRepository(this.clientService, this.localStorage, this.callbacks);

  Future<void> initialize(PikuUser? user);

  void getPersistedMessages();

  Future<void> getMessages();

  void listenForEvents();

  Future<void> sendMessage(PikuNewMessageRequest request);

  void sendAction(PikuActionType action);

  Future<void> clear();

  void dispose();
}

class PikuRepositoryImpl extends PikuRepository {
  bool _isListeningForEvents = false;
  Timer? _publishPresenceTimer;
  Timer? _presenceResetTimer;

  PikuRepositoryImpl(
      {required PikuClientService clientService,
      required LocalStorage localStorage,
      required PikuCallbacks streamCallbacks})
      : super(clientService, localStorage, streamCallbacks);

  /// Fetches persisted messages.
  ///
  /// Calls [PikuCallbacks.onMessagesRetrieved] when [PikuClientService.getAllMessages] is successful
  /// Calls [PikuCallbacks.onError] when [PikuClientService.getAllMessages] fails
  @override
  Future<void> getMessages() async {
    try {
      final messages = await clientService.getAllMessages();
      await localStorage.messagesDao.saveAllMessages(messages);
      callbacks.onMessagesRetrieved?.call(messages);
    } on PikuClientException catch (e) {
      callbacks.onError?.call(e);
    }
  }

  /// Fetches persisted messages.
  ///
  /// Calls [PikuCallbacks.onPersistedMessagesRetrieved] if persisted messages are found
  @override
  void getPersistedMessages() {
    final persistedMessages = localStorage.messagesDao.getMessages();
    if (persistedMessages.isNotEmpty) {
      callbacks.onPersistedMessagesRetrieved?.call(persistedMessages);
    }
  }

  /// Initializes piku client repository
  @override
  Future<void> initialize(PikuUser? user) async {
    try {
      if (user != null) {
        await localStorage.userDao.saveUser(user);
      }

      //refresh contact
      final contact = await clientService.getContact();
      localStorage.contactDao.saveContact(contact);

      //refresh conversation
      final conversations = await clientService.getConversations();
      final persistedConversation =
          localStorage.conversationDao.getConversation()!;
      final refreshedConversation = conversations.firstWhere(
          (element) => element.id == persistedConversation.id,
          orElse: () =>
              persistedConversation //highly unlikely orElse will be called but still added it just in case
          );
      localStorage.conversationDao.saveConversation(refreshedConversation);
    } on PikuClientException catch (e) {
      callbacks.onError?.call(e);
    }

    listenForEvents();
  }

  ///Sends message to piku inbox
  @override
  Future<void> sendMessage(PikuNewMessageRequest request) async {
    try {
      final createdMessage = await clientService.createMessage(request);
      await localStorage.messagesDao.saveMessage(createdMessage);
      callbacks.onMessageSent?.call(createdMessage, request.echoId);
      if (clientService.connection != null && !_isListeningForEvents) {
        listenForEvents();
      }
    } on PikuClientException catch (e) {
      callbacks.onError
          ?.call(PikuClientException(e.cause, e.type, data: request.echoId));
    }
  }

  /// Connects to piku websocket and starts listening for updates
  ///
  /// Received events/messages are pushed through [PikuClient.callbacks]
  @override
  void listenForEvents() {
    final token = localStorage.contactDao.getContact()?.pubsubToken;
    if (token == null) {
      return;
    }
    clientService.startWebSocketConnection(
        localStorage.contactDao.getContact()!.pubsubToken ?? "");

    final newSubscription = clientService.connection!.stream.listen((event) {
      PikuEvent pikuEvent = PikuEvent.fromJson(jsonDecode(event));
      if (pikuEvent.type == PikuEventType.welcome) {
        callbacks.onWelcome?.call();
      } else if (pikuEvent.type == PikuEventType.ping) {
        callbacks.onPing?.call();
      } else if (pikuEvent.type == PikuEventType.confirm_subscription) {
        if (!_isListeningForEvents) {
          _isListeningForEvents = true;
        }
        _publishPresenceUpdates();
        callbacks.onConfirmedSubscription?.call();
      } else if (pikuEvent.message?.event ==
          PikuEventMessageType.message_created) {
        print("here comes message: $event");
        final message = pikuEvent.message!.data!.getMessage();
        localStorage.messagesDao.saveMessage(message);
        if (message.isMine) {
          callbacks.onMessageDelivered
              ?.call(message, pikuEvent.message?.data?.echoId ?? '');
        } else {
          callbacks.onMessageReceived?.call(message);
        }
      } else if (pikuEvent.message?.event ==
          PikuEventMessageType.message_updated) {
        print("here comes the updated message: $event");

        final message = pikuEvent.message!.data!.getMessage();
        localStorage.messagesDao.saveMessage(message);

        callbacks.onMessageUpdated?.call(message);
      } else if (pikuEvent.message?.event ==
          PikuEventMessageType.conversation_typing_off) {
        callbacks.onConversationStoppedTyping?.call();
      } else if (pikuEvent.message?.event ==
          PikuEventMessageType.conversation_typing_on) {
        callbacks.onConversationStartedTyping?.call();
      } else if (pikuEvent.message?.event ==
              PikuEventMessageType.conversation_status_changed &&
          pikuEvent.message?.data?.status == "resolved" &&
          pikuEvent.message?.data?.id ==
              (localStorage.conversationDao.getConversation()?.id ?? 0)) {
        //delete conversation result
        localStorage.conversationDao.deleteConversation();
        localStorage.messagesDao.clear();
        callbacks.onConversationResolved?.call();
      } else if (pikuEvent.message?.event ==
          PikuEventMessageType.presence_update) {
        final presenceStatuses =
            (pikuEvent.message!.data!.users as Map<dynamic, dynamic>)
                .values;
        final isOnline = presenceStatuses.contains("online");
        if (isOnline) {
          callbacks.onConversationIsOnline?.call();
          _presenceResetTimer?.cancel();
          _startPresenceResetTimer();
        } else {
          callbacks.onConversationIsOffline?.call();
        }
      } else {
        print("piku unknown event: $event");
      }
    });
    _subscriptions.add(newSubscription);
  }

  /// Clears all data related to current piku client instance
  @override
  Future<void> clear() async {
    await localStorage.clear();
  }

  /// Cancels websocket stream subscriptions and disposes [localStorage]
  @override
  void dispose() {
    localStorage.dispose();
    callbacks = PikuCallbacks();
    _presenceResetTimer?.cancel();
    _publishPresenceTimer?.cancel();
    for (var subs in _subscriptions) {
      subs.cancel();
    }
  }

  ///Send actions like user started typing
  @override
  void sendAction(PikuActionType action) {
    clientService.sendAction(
        localStorage.contactDao.getContact()!.pubsubToken ?? "", action);
  }

  ///Publishes presence update to websocket channel at a 30 second interval
  void _publishPresenceUpdates() {
    sendAction(PikuActionType.update_presence);
    _publishPresenceTimer =
        Timer.periodic(const Duration(seconds: 30), (timer) {
      sendAction(PikuActionType.update_presence);
    });
  }

  ///Triggers an offline presence event after 40 seconds without receiving a presence update event
  void _startPresenceResetTimer() {
    _presenceResetTimer = Timer.periodic(const Duration(seconds: 40), (timer) {
      callbacks.onConversationIsOffline?.call();
      _presenceResetTimer?.cancel();
    });
  }
}

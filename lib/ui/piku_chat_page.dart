import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../piku_callbacks.dart';
import '../piku_client.dart';
import '../data/local/entity/piku_message.dart';
import '../data/local/entity/piku_user.dart';
import '../data/remote/piku_client_exception.dart';
import 'piku_chat_theme.dart';
import 'piku_l10n.dart';

class PikuChat extends StatefulWidget {
  /// Specifies a custom app bar for piku page widget
  final PreferredSizeWidget? appBar;

  ///Installation url for cpiku
  final String baseUrl;

  ///Identifier for target piku inbox.
  ///

  final String inboxIdentifier;

  /// Enables persistence of piku client instance's contact, conversation and messages to disk
  /// for convenience.
  ///
  /// Setting [enablePersistence] to false holds piku client instance's data in memory and is cleared as
  /// soon as piku client instance is disposed
  final bool enablePersistence;

  /// Custom user details to be attached to piku contact
  final PikuUser? user;

  /// See [ChatList.onEndReached]
  final Future<void> Function()? onEndReached;

  /// See [ChatList.onEndReachedThreshold]
  final double? onEndReachedThreshold;

  /// See [Message.onMessageLongPress]
  final void Function(BuildContext context, types.Message)? onMessageLongPress;

  /// See [Message.onMessageTap]
  final void Function(types.Message)? onMessageTap;

  /// See [Input.onSendPressed]
  final void Function(types.PartialText)? onSendPressed;

  /// See [Input.onTextChanged]
  final void Function(String)? onTextChanged;

  /// Show avatars for received messages.
  final bool showUserAvatars;

  /// Show user names for received messages.
  final bool showUserNames;

  final PikuChatTheme? theme;

  /// See [PikuL10n]
  final PikuL10n l10n;

  /// See [Chat.timeFormat]
  final DateFormat? timeFormat;

  /// See [Chat.dateFormat]
  final DateFormat? dateFormat;

  ///See [PikuCallbacks.onWelcome]
  final void Function()? onWelcome;

  ///See [PikuCallbacks.onPing]
  final void Function()? onPing;

  ///See [PikuCallbacks.onConfirmedSubscription]
  final void Function()? onConfirmedSubscription;

  ///See [PikuCallbacks.onConversationStartedTyping]
  final void Function()? onConversationStartedTyping;

  ///See [PikuCallbacks.onConversationIsOnline]
  final void Function()? onConversationIsOnline;

  ///See [PikuCallbacks.onConversationIsOffline]
  final void Function()? onConversationIsOffline;

  ///See [PikuCallbacks.onConversationStoppedTyping]
  final void Function()? onConversationStoppedTyping;

  ///See [PikuCallbacks.onMessageReceived]
  final void Function(PikuMessage)? onMessageReceived;

  ///See [PikuCallbacks.onMessageSent]
  final void Function(PikuMessage)? onMessageSent;

  ///See [PikuCallbacks.onMessageDelivered]
  final void Function(PikuMessage)? onMessageDelivered;

  ///See [PikuCallbacks.onMessageUpdated]
  final void Function(PikuMessage)? onMessageUpdated;

  ///See [PikuCallbacks.onPersistedMessagesRetrieved]
  final void Function(List<PikuMessage>)? onPersistedMessagesRetrieved;

  ///See [PikuCallbacks.onMessagesRetrieved]
  final void Function(List<PikuMessage>)? onMessagesRetrieved;

  ///See [PikuCallbacks.onError]
  final void Function(PikuClientException)? onError;

  ///Horizontal padding is reduced if set to true
  final bool isPresentedInDialog;

  const PikuChat(
      {super.key,
      required this.baseUrl,
      required this.inboxIdentifier,
      this.enablePersistence = true,
      this.user,
      this.appBar,
      this.onEndReached,
      this.onEndReachedThreshold,
      this.onMessageLongPress,
      this.onMessageTap,
      this.onSendPressed,
      this.onTextChanged,
      this.showUserAvatars = true,
      this.showUserNames = true,
      this.theme,
      this.l10n = const PikuL10n(),
      this.timeFormat,
      this.dateFormat,
      this.onWelcome,
      this.onPing,
      this.onConfirmedSubscription,
      this.onMessageReceived,
      this.onMessageSent,
      this.onMessageDelivered,
      this.onMessageUpdated,
      this.onPersistedMessagesRetrieved,
      this.onMessagesRetrieved,
      this.onConversationStartedTyping,
      this.onConversationStoppedTyping,
      this.onConversationIsOnline,
      this.onConversationIsOffline,
      this.onError,
      this.isPresentedInDialog = false});

  @override
  PikuChatState createState() => PikuChatState();
}

class PikuChatState extends State<PikuChat> {
  ///
  List<types.Message> _messages = [];

  late String status;

  final idGen = const Uuid();
  late final _user;
  PikuClient? pikuClient;

  late final pikuCallbacks;

  @override
  void initState() {
    super.initState();

    if (widget.user == null) {
      _user = types.User(id: idGen.v4());
    } else {
      _user = types.User(
        id: widget.user?.identifier ?? idGen.v4(),
        firstName: widget.user?.name,
        imageUrl: widget.user?.avatarUrl,
      );
    }

    pikuCallbacks = PikuCallbacks(
      onWelcome: () {
        widget.onWelcome?.call();
      },
      onPing: () {
        widget.onPing?.call();
      },
      onConfirmedSubscription: () {
        widget.onConfirmedSubscription?.call();
      },
      onConversationStartedTyping: () {
        widget.onConversationStoppedTyping?.call();
      },
      onConversationStoppedTyping: () {
        widget.onConversationStartedTyping?.call();
      },
      onPersistedMessagesRetrieved: (persistedMessages) {
        if (widget.enablePersistence) {
          setState(() {
            _messages = persistedMessages
                .map((message) => _pikuMessageToTextMessage(message))
                .toList();
          });
        }
        widget.onPersistedMessagesRetrieved?.call(persistedMessages);
      },
      onMessagesRetrieved: (messages) {
        if (messages.isEmpty) {
          return;
        }
        setState(() {
          final chatMessages = messages
              .map((message) => _pikuMessageToTextMessage(message))
              .toList();
          final mergedMessages =
              <types.Message>{..._messages, ...chatMessages}.toList();
          final now = DateTime.now().millisecondsSinceEpoch;
          mergedMessages.sort((a, b) {
            return (b.createdAt ?? now).compareTo(a.createdAt ?? now);
          });
          _messages = mergedMessages;
        });
        widget.onMessagesRetrieved?.call(messages);
      },
      onMessageReceived: (pikuMessage) {
        _addMessage(_pikuMessageToTextMessage(pikuMessage));
        widget.onMessageReceived?.call(pikuMessage);
      },
      onMessageDelivered: (pikuMessage, echoId) {
        _handleMessageSent(
            _pikuMessageToTextMessage(pikuMessage, echoId: echoId));
        widget.onMessageDelivered?.call(pikuMessage);
      },
      onMessageUpdated: (pikuMessage) {
        _handleMessageUpdated(_pikuMessageToTextMessage(pikuMessage,
            echoId: pikuMessage.id.toString()));
        widget.onMessageUpdated?.call(pikuMessage);
      },
      onMessageSent: (pikuMessage, echoId) {
        final textMessage = types.TextMessage(
            id: echoId,
            author: _user,
            text: pikuMessage.content ?? "",
            status: types.Status.delivered);
        _handleMessageSent(textMessage);
        widget.onMessageSent?.call(pikuMessage);
      },
      onConversationResolved: () {
        final resolvedMessage = types.TextMessage(
            id: idGen.v4(),
            text: widget.l10n.conversationResolvedMessage,
            author: types.User(
                id: idGen.v4(),
                firstName: "Bot",
                imageUrl:
                    "https://d2cbg94ubxgsnp.cloudfront.net/Pictures/480x270//9/9/3/512993_shutterstock_715962319converted_920340.png"),
            status: types.Status.delivered);
        _addMessage(resolvedMessage);
      },
      onError: (error) {
        if (error.type == PikuClientExceptionType.SEND_MESSAGE_FAILED) {
          _handleSendMessageFailed(error.data);
        }
        print("Ooops! Something went wrong. Error Cause: ${error.cause}");
        widget.onError?.call(error);
      },
    );

    PikuClient.create(
            baseUrl: widget.baseUrl,
            inboxIdentifier: widget.inboxIdentifier,
            user: widget.user,
            enablePersistence: widget.enablePersistence,
            callbacks: pikuCallbacks)
        .then((client) {
      setState(() {
        pikuClient = client;
        pikuClient!.loadMessages();
      });
    }).onError((error, stackTrace) {
      widget.onError?.call(PikuClientException(
          error.toString(), PikuClientExceptionType.CREATE_CLIENT_FAILED));
      print("piku client failed with error $error: $stackTrace");
    });
  }

  types.TextMessage _pikuMessageToTextMessage(PikuMessage message,
      {String? echoId}) {
    String? avatarUrl = message.sender?.avatarUrl ?? message.sender?.thumbnail;

    //Sets avatar url to null if its a gravatar not found url
    //This enables placeholder for avatar to show
    if (avatarUrl?.contains("?d=404") ?? false) {
      avatarUrl = null;
    }
    return types.TextMessage(
        id: echoId ?? message.id.toString(),
        author: message.isMine
            ? _user
            : types.User(
                id: message.sender?.id.toString() ?? idGen.v4(),
                firstName: message.sender?.name,
                imageUrl: avatarUrl,
              ),
        text: message.content ?? "",
        status: types.Status.seen,
        createdAt: DateTime.parse(message.createdAt).millisecondsSinceEpoch);
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendMessageFailed(String echoId) async {
    final index = _messages.indexWhere((element) => element.id == echoId);
    setState(() {
      _messages[index] = _messages[index].copyWith(status: types.Status.error);
    });
  }

  void _handleResendMessage(types.TextMessage message) async {
    pikuClient!.sendMessage(content: message.text, echoId: message.id);
    final index = _messages.indexWhere((element) => element.id == message.id);
    setState(() {
      _messages[index] = message.copyWith(status: types.Status.sending);
    });
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message.status == types.Status.error && message is types.TextMessage) {
      _handleResendMessage(message);
    }
    widget.onMessageTap?.call(message);
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (index >= 0) {
          _messages[index] = updatedMessage;
        }
      });
    });
  }

  void _handleMessageSent(
    types.Message message,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);

    if (_messages[index].status == types.Status.seen) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = message;
      });
    });
  }

  void _handleMessageUpdated(
    types.Message message,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (index < _messages.length && index >= 0) {
          _messages[index] = message;
        }
      });
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: message.text,
        status: types.Status.sending);

    _addMessage(textMessage);

    pikuClient!.sendMessage(content: textMessage.text, echoId: textMessage.id);
    widget.onSendPressed?.call(message);
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = widget.isPresentedInDialog ? 8.0 : 16.0;
    return Scaffold(
      appBar: widget.appBar,
      backgroundColor: widget.theme?.backgroundColor ??
          const PikuChatTheme().backgroundColor,
      body: Column(
        children: [
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(
                  left: horizontalPadding, right: horizontalPadding),
              child: Chat(
                messages: _messages,
                onMessageTap: _handleMessageTap,
                onPreviewDataFetched: _handlePreviewDataFetched,
                onSendPressed: _handleSendPressed,
                user: _user,
                onEndReached: widget.onEndReached,
                onEndReachedThreshold: widget.onEndReachedThreshold,
                onMessageLongPress: widget.onMessageLongPress,
                showUserAvatars: widget.showUserAvatars,
                showUserNames: widget.showUserNames,
                timeFormat: widget.timeFormat ?? DateFormat.Hm(),
                dateFormat: widget.timeFormat ?? DateFormat("EEEE MMMM d"),
                theme: widget.theme ?? const PikuChatTheme(),
                l10n: widget.l10n,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/logo_grey.png",
                  package: 'piku_flutter',
                  width: 15,
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Powered by Ostad",
                    style: TextStyle(color: Colors.black45, fontSize: 12),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    pikuClient?.dispose();
  }
}

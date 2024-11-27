import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../local/entity/piku_contact.dart';
import '../../local/entity/piku_conversation.dart';
import '../../local/entity/piku_message.dart';
import '../piku_client_exception.dart';
import '../requests/piku_action.dart';
import '../requests/piku_action_data.dart';
import '../requests/piku_new_message_request.dart';
import 'piku_client_api_interceptor.dart';

/// Service for handling piku api calls
/// See [PikuClientServiceImpl]
abstract class PikuClientService {
  final String _baseUrl;
  WebSocketChannel? connection;
  final Dio dio;

  PikuClientService(this._baseUrl, this.dio);

  Future<PikuContact> updateContact(update);

  Future<PikuContact> getContact();

  Future<List<PikuConversation>> getConversations();

  Future<PikuMessage> createMessage(PikuNewMessageRequest request);

  Future<PikuMessage> updateMessage(String messageIdentifier, update);

  Future<List<PikuMessage>> getAllMessages();

  void startWebSocketConnection(String contactPubsubToken,
      {WebSocketChannel Function(Uri)? onStartConnection});

  void sendAction(String contactPubsubToken, PikuActionType action);
}

class PikuClientServiceImpl extends PikuClientService {
  PikuClientServiceImpl(String baseUrl, {required Dio dio})
      : super(baseUrl, dio);

  ///Sends message to piku inbox
  @override
  Future<PikuMessage> createMessage(PikuNewMessageRequest request) async {
    try {
      final createResponse = await dio.post(
          "$_baseUrl/public/api/v1/inboxes/${PikuClientApiInterceptor.INTERCEPTOR_INBOX_IDENTIFIER_PLACEHOLDER}/contacts/${PikuClientApiInterceptor.INTERCEPTOR_CONTACT_IDENTIFIER_PLACEHOLDER}/conversations/${PikuClientApiInterceptor.INTERCEPTOR_CONVERSATION_IDENTIFIER_PLACEHOLDER}/messages",
          data: request.toJson());
      if ((createResponse.statusCode ?? 0).isBetween(199, 300)) {
        return PikuMessage.fromJson(createResponse.data);
      } else {
        throw PikuClientException(
            createResponse.statusMessage ?? "unknown error",
            PikuClientExceptionType.SEND_MESSAGE_FAILED);
      }
    } on DioException catch (e) {
      throw PikuClientException(
          e.message.toString(), PikuClientExceptionType.SEND_MESSAGE_FAILED);
    }
  }

  ///Gets all messages of current piku client instance's conversation
  @override
  Future<List<PikuMessage>> getAllMessages() async {
    try {
      final createResponse = await dio.get(
          "/public/api/v1/inboxes/${PikuClientApiInterceptor.INTERCEPTOR_INBOX_IDENTIFIER_PLACEHOLDER}/contacts/${PikuClientApiInterceptor.INTERCEPTOR_CONTACT_IDENTIFIER_PLACEHOLDER}/conversations/${PikuClientApiInterceptor.INTERCEPTOR_CONVERSATION_IDENTIFIER_PLACEHOLDER}/messages");
      if ((createResponse.statusCode ?? 0).isBetween(199, 300)) {
        return (createResponse.data as List<dynamic>)
            .map(((json) => PikuMessage.fromJson(json)))
            .toList();
      } else {
        throw PikuClientException(
            createResponse.statusMessage ?? "unknown error",
            PikuClientExceptionType.GET_MESSAGES_FAILED);
      }
    } on DioException catch (e) {
      throw PikuClientException(
          e.message.toString(), PikuClientExceptionType.GET_MESSAGES_FAILED);
    }
  }

  ///Gets contact of current piku client instance
  @override
  Future<PikuContact> getContact() async {
    try {
      final createResponse = await dio.get(
          "/public/api/v1/inboxes/${PikuClientApiInterceptor.INTERCEPTOR_INBOX_IDENTIFIER_PLACEHOLDER}/contacts/${PikuClientApiInterceptor.INTERCEPTOR_CONTACT_IDENTIFIER_PLACEHOLDER}");
      if ((createResponse.statusCode ?? 0).isBetween(199, 300)) {
        return PikuContact.fromJson(createResponse.data);
      } else {
        throw PikuClientException(
            createResponse.statusMessage ?? "unknown error",
            PikuClientExceptionType.GET_CONTACT_FAILED);
      }
    } on DioException catch (e) {
      throw PikuClientException(
          e.message.toString(), PikuClientExceptionType.GET_CONTACT_FAILED);
    }
  }

  ///Gets all conversation of current piku client instance
  @override
  Future<List<PikuConversation>> getConversations() async {
    try {
      final createResponse = await dio.get(
          "/public/api/v1/inboxes/${PikuClientApiInterceptor.INTERCEPTOR_INBOX_IDENTIFIER_PLACEHOLDER}/contacts/${PikuClientApiInterceptor.INTERCEPTOR_CONTACT_IDENTIFIER_PLACEHOLDER}/conversations");
      if ((createResponse.statusCode ?? 0).isBetween(199, 300)) {
        return (createResponse.data as List<dynamic>)
            .map(((json) => PikuConversation.fromJson(json)))
            .toList();
      } else {
        throw PikuClientException(
            createResponse.statusMessage ?? "unknown error",
            PikuClientExceptionType.GET_CONVERSATION_FAILED);
      }
    } on DioException catch (e) {
      throw PikuClientException(e.message.toString(),
          PikuClientExceptionType.GET_CONVERSATION_FAILED);
    }
  }

  ///Update current client instance's contact
  @override
  Future<PikuContact> updateContact(update) async {
    try {
      final updateResponse = await dio.patch(
          "/public/api/v1/inboxes/${PikuClientApiInterceptor.INTERCEPTOR_INBOX_IDENTIFIER_PLACEHOLDER}/contacts/${PikuClientApiInterceptor.INTERCEPTOR_CONTACT_IDENTIFIER_PLACEHOLDER}",
          data: update);
      if ((updateResponse.statusCode ?? 0).isBetween(199, 300)) {
        return PikuContact.fromJson(updateResponse.data);
      } else {
        throw PikuClientException(
            updateResponse.statusMessage ?? "unknown error",
            PikuClientExceptionType.UPDATE_CONTACT_FAILED);
      }
    } on DioException catch (e) {
      throw PikuClientException(
          e.message.toString(), PikuClientExceptionType.UPDATE_CONTACT_FAILED);
    }
  }

  ///Update message with id [messageIdentifier] with contents of [update]
  @override
  Future<PikuMessage> updateMessage(String messageIdentifier, update) async {
    try {
      final updateResponse = await dio.patch(
          "/public/api/v1/inboxes/${PikuClientApiInterceptor.INTERCEPTOR_INBOX_IDENTIFIER_PLACEHOLDER}/contacts/${PikuClientApiInterceptor.INTERCEPTOR_CONTACT_IDENTIFIER_PLACEHOLDER}/conversations/${PikuClientApiInterceptor.INTERCEPTOR_CONVERSATION_IDENTIFIER_PLACEHOLDER}/messages/$messageIdentifier",
          data: update);
      if ((updateResponse.statusCode ?? 0).isBetween(199, 300)) {
        return PikuMessage.fromJson(updateResponse.data);
      } else {
        throw PikuClientException(
            updateResponse.statusMessage ?? "unknown error",
            PikuClientExceptionType.UPDATE_MESSAGE_FAILED);
      }
    } on DioException catch (e) {
      throw PikuClientException(
          e.message.toString(), PikuClientExceptionType.UPDATE_MESSAGE_FAILED);
    }
  }

  @override
  void startWebSocketConnection(String contactPubsubToken,
      {WebSocketChannel Function(Uri)? onStartConnection}) {
    final socketUrl = Uri.parse("${_baseUrl.replaceFirst("http", "ws")}/cable");
    connection = onStartConnection == null
        ? WebSocketChannel.connect(socketUrl)
        : onStartConnection(socketUrl);
    connection!.sink.add(jsonEncode({
      "command": "subscribe",
      "identifier": jsonEncode(
          {"channel": "RoomChannel", "pubsub_token": contactPubsubToken})
    }));
  }

  @override
  void sendAction(String contactPubsubToken, PikuActionType actionType) {
    final PikuAction action;
    final identifier = jsonEncode(
        {"channel": "RoomChannel", "pubsub_token": contactPubsubToken});
    switch (actionType) {
      case PikuActionType.subscribe:
        action = PikuAction(identifier: identifier, command: "subscribe");
        break;
      default:
        action = PikuAction(
            identifier: identifier,
            data: PikuActionData(action: actionType),
            command: "message");
        break;
    }
    connection?.sink.add(jsonEncode(action.toJson()));
  }
}

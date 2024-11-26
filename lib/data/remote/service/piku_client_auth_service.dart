import 'dart:async';

import 'package:dio/dio.dart';
import 'package:piku_flutter/data/remote/service/piku_client_api_interceptor.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../local/entity/piku_contact.dart';
import '../../local/entity/piku_conversation.dart';
import '../../local/entity/piku_user.dart';
import '../piku_client_exception.dart';

/// Service for handling piku user authentication api calls
/// See [PikuClientAuthServiceImpl]
abstract class PikuClientAuthService {
  WebSocketChannel? connection;
  final Dio dio;

  PikuClientAuthService(this.dio);

  Future<PikuContact> createNewContact(String inboxIdentifier, PikuUser? user);

  Future<PikuConversation> createNewConversation(
      String inboxIdentifier, String contactIdentifier);
}

/// Default Implementation for [PikuClientAuthService]
class PikuClientAuthServiceImpl extends PikuClientAuthService {
  PikuClientAuthServiceImpl({required Dio dio}) : super(dio);

  ///Creates new contact for inbox with [inboxIdentifier] and passes [user] body to be linked to created contact
  @override
  Future<PikuContact> createNewContact(
      String inboxIdentifier, PikuUser? user) async {
    try {
      final createResponse = await dio.post(
          "/public/api/v1/inboxes/$inboxIdentifier/contacts",
          data: user?.toJson());
      print(createResponse.requestOptions.uri.path);
      if ((createResponse.statusCode ?? 0).isBetween(199, 300)) {
        //creating contact successful continue with request
        final contact = PikuContact.fromJson(createResponse.data);
        return contact;
      } else {
        throw PikuClientException(
            createResponse.statusMessage ?? "unknown error",
            PikuClientExceptionType.CREATE_CONTACT_FAILED);
      }
    } on DioException catch (e) {
      print(e.message);
      throw PikuClientException(
          e.message.toString(), PikuClientExceptionType.CREATE_CONTACT_FAILED);
    }
  }

  ///Creates a new conversation for inbox with [inboxIdentifier] and contact with source id [contactIdentifier]
  @override
  Future<PikuConversation> createNewConversation(
      String inboxIdentifier, String contactIdentifier) async {
    try {
      final createResponse = await dio.post(
          "/public/api/v1/inboxes/$inboxIdentifier/contacts/$contactIdentifier/conversations");
      if ((createResponse.statusCode ?? 0).isBetween(199, 300)) {
        //creating contact successful continue with request
        final newConversation = PikuConversation.fromJson(createResponse.data);
        return newConversation;
      } else {
        throw PikuClientException(
            createResponse.statusMessage ?? "unknown error",
            PikuClientExceptionType.CREATE_CONVERSATION_FAILED);
      }
    } on DioException catch (e) {
      throw PikuClientException(e.message.toString(),
          PikuClientExceptionType.CREATE_CONVERSATION_FAILED);
    }
  }
}

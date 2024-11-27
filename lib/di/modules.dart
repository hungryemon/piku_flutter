import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod/riverpod.dart';

import '../piku_parameters.dart';
import '../data/local/entity/piku_contact.dart';
import '../data/local/entity/piku_message.dart';
import '../data/piku_repository.dart';
import '../data/local/dao/piku_contact_dao.dart';
import '../data/local/dao/piku_conversation_dao.dart';
import '../data/local/dao/piku_messages_dao.dart';
import '../data/local/dao/piku_user_dao.dart';
import '../data/local/entity/piku_conversation.dart';
import '../data/local/entity/piku_user.dart';
import '../data/local/local_storage.dart';
import '../data/remote/service/piku_client_api_interceptor.dart';
import '../data/remote/service/piku_client_auth_service.dart';
import '../data/remote/service/piku_client_service.dart';
import '../repository_parameters.dart';

///Provides an instance of [Dio]
final unauthenticatedDioProvider =
    Provider.family.autoDispose<Dio, PikuParameters>((ref, params) {
  return Dio(BaseOptions(baseUrl: params.baseUrl));
});

///Provides an instance of [PikuClientApiInterceptor]
final pikuClientApiInterceptorProvider =
    Provider.family<PikuClientApiInterceptor, PikuParameters>((ref, params) {
  final localStorage = ref.read(localStorageProvider(params));
  final authService = ref.read(pikuClientAuthServiceProvider(params));
  return PikuClientApiInterceptor(
      params.inboxIdentifier,params.contactIdentifier, params.conversationId, localStorage, authService);
});

///Provides an instance of Dio with interceptors set to authenticate all requests called with this dio instance
final authenticatedDioProvider =
    Provider.family.autoDispose<Dio, PikuParameters>((ref, params) {
  final authenticatedDio = Dio(BaseOptions(baseUrl: params.baseUrl));
  final interceptor = ref.read(pikuClientApiInterceptorProvider(params));
  authenticatedDio.interceptors.add(interceptor);
  return authenticatedDio;
});

///Provides instance of piku client auth service [PikuClientAuthService].
final pikuClientAuthServiceProvider =
    Provider.family<PikuClientAuthService, PikuParameters>((ref, params) {
  final unAuthenticatedDio = ref.read(unauthenticatedDioProvider(params));
  return PikuClientAuthServiceImpl(dio: unAuthenticatedDio);
});

///Provides instance of piku client api service [PikuClientService].
final pikuClientServiceProvider =
    Provider.family<PikuClientService, PikuParameters>((ref, params) {
  final authenticatedDio = ref.read(authenticatedDioProvider(params));
  return PikuClientServiceImpl(params.baseUrl, dio: authenticatedDio);
});

///Provides hive box to store relations between piku client instance and contact object,
///which is used when persistence is enabled. Client instances are distinguished using baseurl and inboxIdentifier
final clientInstanceToContactBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>(
      PikuContactBoxNames.CLIENT_INSTANCE_TO_CONTACTS.toString());
});

///Provides hive box to store relations between piku client instance and conversation object,
///which is used when persistence is enabled. Client instances are distinguished using baseurl and inboxIdentifier
final clientInstanceToConversationBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>(
      PikuConversationBoxNames.CLIENT_INSTANCE_TO_CONVERSATIONS.toString());
});

///Provides hive box to store relations between piku client instance and messages,
///which is used when persistence is enabled. Client instances are distinguished using baseurl and inboxIdentifier
final messageToClientInstanceBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>(
      PikuMessagesBoxNames.MESSAGES_TO_CLIENT_INSTANCE_KEY.toString());
});

///Provides hive box to store relations between piku client instance and user object,
///which is used when persistence is enabled. Client instances are distinguished using baseurl and inboxIdentifier
final clientInstanceToUserBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>(PikuUserBoxNames.CLIENT_INSTANCE_TO_USER.toString());
});

///Provides hive box for [PikuContact] object, which is used when persistence is enabled
final contactBoxProvider = Provider<Box<PikuContact>>((ref) {
  return Hive.box<PikuContact>(PikuContactBoxNames.CONTACTS.toString());
});

///Provides hive box for [PikuConversation] object, which is used when persistence is enabled
final conversationBoxProvider = Provider<Box<PikuConversation>>((ref) {
  return Hive.box<PikuConversation>(
      PikuConversationBoxNames.CONVERSATIONS.toString());
});

///Provides hive box for [PikuMessage] object, which is used when persistence is enabled
final messagesBoxProvider = Provider<Box<PikuMessage>>((ref) {
  return Hive.box<PikuMessage>(PikuMessagesBoxNames.MESSAGES.toString());
});

///Provides hive box for [PikuUser] object, which is used when persistence is enabled
final userBoxProvider = Provider<Box<PikuUser>>((ref) {
  return Hive.box<PikuUser>(PikuUserBoxNames.USERS.toString());
});

///Provides an instance of piku user dao
///
/// Creates an in memory storage if persistence isn't enabled in params else hive boxes are create to store
/// piku client's contact
final pikuContactDaoProvider =
    Provider.family<PikuContactDao, PikuParameters>((ref, params) {
  if (!params.isPersistenceEnabled) {
    return NonPersistedPikuContactDao();
  }

  final contactBox = ref.read(contactBoxProvider);
  final clientInstanceToContactBox =
      ref.read(clientInstanceToContactBoxProvider);
  return PersistedPikuContactDao(
      contactBox, clientInstanceToContactBox, params.clientInstanceKey);
});

///Provides an instance of piku user dao
///
/// Creates an in memory storage if persistence isn't enabled in params else hive boxes are create to store
/// piku client's conversation
final pikuConversationDaoProvider =
    Provider.family<PikuConversationDao, PikuParameters>((ref, params) {
  if (!params.isPersistenceEnabled) {
    return NonPersistedPikuConversationDao();
  }
  final conversationBox = ref.read(conversationBoxProvider);
  final clientInstanceToConversationBox =
      ref.read(clientInstanceToConversationBoxProvider);
  return PersistedPikuConversationDao(conversationBox,
      clientInstanceToConversationBox, params.clientInstanceKey);
});

///Provides an instance of piku user dao
///
/// Creates an in memory storage if persistence isn't enabled in params else hive boxes are create to store
/// piku client's messages
final pikuMessagesDaoProvider =
    Provider.family<PikuMessagesDao, PikuParameters>((ref, params) {
  if (!params.isPersistenceEnabled) {
    return NonPersistedPikuMessagesDao();
  }
  final messagesBox = ref.read(messagesBoxProvider);
  final messageToClientInstanceBox =
      ref.read(messageToClientInstanceBoxProvider);
  return PersistedPikuMessagesDao(
      messagesBox, messageToClientInstanceBox, params.clientInstanceKey);
});

///Provides an instance of piku user dao
///
/// Creates an in memory storage if persistence isn't enabled in params else hive boxes are create to store
/// user info
final pikuUserDaoProvider =
    Provider.family<PikuUserDao, PikuParameters>((ref, params) {
  if (!params.isPersistenceEnabled) {
    return NonPersistedPikuUserDao();
  }
  final userBox = ref.read(userBoxProvider);
  final clientInstanceToUserBoxBox = ref.read(clientInstanceToUserBoxProvider);
  return PersistedPikuUserDao(
      userBox, clientInstanceToUserBoxBox, params.clientInstanceKey);
});

///Provides an instance of local storage
final localStorageProvider =
    Provider.family<LocalStorage, PikuParameters>((ref, params) {
  final contactDao = ref.read(pikuContactDaoProvider(params));
  final conversationDao = ref.read(pikuConversationDaoProvider(params));
  final userDao = ref.read(pikuUserDaoProvider(params));
  final messagesDao = ref.read(pikuMessagesDaoProvider(params));

  return LocalStorage(
      contactDao: contactDao,
      conversationDao: conversationDao,
      userDao: userDao,
      messagesDao: messagesDao);
});

///Provides an instance of piku repository
final pikuRepositoryProvider =
    Provider.family<PikuRepository, RepositoryParameters>((ref, repoParams) {
  final localStorage = ref.read(localStorageProvider(repoParams.params));
  final clientService = ref.read(pikuClientServiceProvider(repoParams.params));

  return PikuRepositoryImpl(
      clientService: clientService,
      localStorage: localStorage,
      streamCallbacks: repoParams.callbacks);
});

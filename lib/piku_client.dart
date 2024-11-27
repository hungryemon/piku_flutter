import 'package:riverpod/riverpod.dart';

import 'data/remote/piku_client_exception.dart';
import 'data/remote/requests/piku_action_data.dart';
import 'piku_callbacks.dart';
import 'piku_parameters.dart';
import 'data/piku_repository.dart';
import 'data/local/entity/piku_user.dart';
import 'data/local/local_storage.dart';
import 'data/remote/requests/piku_new_message_request.dart';
import 'di/modules.dart';
import 'repository_parameters.dart';

/// Represents a piku client instance. All piku operations (Example: sendMessages) are
/// passed through piku client. For more info visit
///
/// {@category FlutterClientSdk}
class PikuClient {
  late final PikuRepository _repository;
  final PikuParameters _parameters;
  final PikuCallbacks? callbacks;
  final PikuUser? user;

  String get baseUrl => _parameters.baseUrl;

  String get inboxIdentifier => _parameters.inboxIdentifier;

  PikuClient._(this._parameters, {this.user, this.callbacks}) {
    providerContainerMap.putIfAbsent(
        _parameters.clientInstanceKey, () => ProviderContainer());
    final container = providerContainerMap[_parameters.clientInstanceKey]!;
    _repository = container.read(pikuRepositoryProvider(RepositoryParameters(
        params: _parameters, callbacks: callbacks ?? PikuCallbacks())));
  }

  void _init() {
    try {
      _repository.initialize(user, _parameters.conversationId);
    } on PikuClientException catch (e) {
      callbacks?.onError?.call(e);
    }
  }

  ///Retrieves Piku client's messages. If persistence is enabled [PikuCallbacks.onPersistedMessagesRetrieved]
  ///will be triggered with persisted messages. On successfully fetch from remote server
  ///[PikuCallbacks.onMessagesRetrieved] will be triggered
  void loadMessages() async {
    _repository.getPersistedMessages();
    await _repository.getMessages();
  }

  /// Sends Piku message. The echoId is your temporary message id. When message sends successfully
  /// [PikuMessage] will be returned with the [echoId] on [PikuCallbacks.onMessageSent]. If
  /// message fails to send [PikuCallbacks.onError] will be triggered [echoId] as data.
  Future<void> sendMessage(
      {required String content, required String echoId}) async {
    final request = PikuNewMessageRequest(content: content, echoId: echoId);
    await _repository.sendMessage(request);
  }

  ///Send Piku action performed by user.
  ///
  /// Example: User started typing
  Future<void> sendAction(PikuActionType action) async {
    _repository.sendAction(action);
  }

  ///Disposes Piku client and cancels all stream subscriptions
  dispose() {
    final container = providerContainerMap[_parameters.clientInstanceKey]!;
    _repository.dispose();
    container.dispose();
    providerContainerMap.remove(_parameters.clientInstanceKey);
  }

  /// Clears all Piku client data
  clearClientData() {
    final container = providerContainerMap[_parameters.clientInstanceKey]!;
    final localStorage = container.read(localStorageProvider(_parameters));
    localStorage.clear(clearPikuUserStorage: false);
  }

  /// Creates an instance of [PikuClient] with the [baseUrl] of your Piku installation,
  /// [inboxIdentifier] for the targeted inbox. Specify custom user details using [user] and [callbacks] for
  /// handling Piku events. By default persistence is enabled, to disable persistence set [enablePersistence] as false
  static Future<PikuClient> create(
      {required String baseUrl,
      required String inboxIdentifier,
      required String contactIdentifier,
      required int conversationId,
      PikuUser? user,
      bool enablePersistence = true,
      PikuCallbacks? callbacks}) async {
    if (enablePersistence) {
      await LocalStorage.openDB();
    }

    final pikuParams = PikuParameters(
        clientInstanceKey: getClientInstanceKey(
            baseUrl: baseUrl,
            inboxIdentifier: inboxIdentifier,
            contactIdentifier: contactIdentifier,
            conversationId: conversationId,
            ),
        isPersistenceEnabled: enablePersistence,
        baseUrl: baseUrl,
        inboxIdentifier: inboxIdentifier,
        contactIdentifier: contactIdentifier,
        conversationId: conversationId,
        userIdentifier: user?.identifier);

    final client = PikuClient._(pikuParams, callbacks: callbacks, user: user);

    client._init();

    return client;
  }

  static const _keySeparator = "|||";

  ///Create a piku client instance key using the piku client instance baseurl, inboxIdentifier
  ///and userIdentifier. Client instance keys are used to differentiate between client instances and their data
  ///(contact ([PikuContact]),conversation ([PikuConversation]) and messages ([PikuMessage]))
  ///
  /// Create separate [PikuClient] instances with same baseUrl, inboxIdentifier, userIdentifier and persistence
  /// enabled will be regarded as same therefore use same contact and conversation.
  static String getClientInstanceKey(
      {required String baseUrl,
      required String inboxIdentifier,
      required String contactIdentifier,
      required int conversationId,
      }) {
    return "$baseUrl$_keySeparator$contactIdentifier$conversationId$_keySeparator$inboxIdentifier";
  }

  static Map<String, ProviderContainer> providerContainerMap = {};

  ///Clears all persisted Piku data on device for a particular Piku client instance.
  ///See [getClientInstanceKey] on how Piku client instance are differentiated
  static Future<void> clearData(
      {required String baseUrl,
      required String inboxIdentifier,
      required String contactIdentifier,
      required int conversationId,}) async {
    final clientInstanceKey = getClientInstanceKey(
        baseUrl: baseUrl,
        inboxIdentifier: inboxIdentifier,
        contactIdentifier: contactIdentifier,
        conversationId: conversationId,);
    providerContainerMap.putIfAbsent(
        clientInstanceKey, () => ProviderContainer());
    final container = providerContainerMap[clientInstanceKey]!;
    const params = PikuParameters(
        isPersistenceEnabled: true,
        baseUrl: "",
        inboxIdentifier: "",
        contactIdentifier: "",
        conversationId: 0,
        clientInstanceKey: "");

    final localStorage = container.read(localStorageProvider(params));
    await localStorage.clear();

    localStorage.dispose();
    container.dispose();
    providerContainerMap.remove(clientInstanceKey);
  }

  /// Clears all persisted Piku data on device.
  static Future<void> clearAllData() async {
    providerContainerMap.putIfAbsent("all", () => ProviderContainer());
    final container = providerContainerMap["all"]!;
    const params = PikuParameters(
        isPersistenceEnabled: true,
        baseUrl: "",
        inboxIdentifier: "",
        contactIdentifier: "",
        conversationId: 0,
        clientInstanceKey: "");

    final localStorage = container.read(localStorageProvider(params));
    await localStorage.clearAll();

    localStorage.dispose();
    container.dispose();
  }
}

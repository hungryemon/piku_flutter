import 'dart:collection';

import 'package:hive_flutter/hive_flutter.dart';

import '../entity/piku_message.dart';

abstract class PikuMessagesDao {
  Future<void> saveMessage(PikuMessage message);
  Future<void> saveAllMessages(List<PikuMessage> messages);
  PikuMessage? getMessage(int messageId);
  List<PikuMessage> getMessages();
  Future<void> clear();
  Future<void> deleteMessage(int messageId);
  Future<void> onDispose();

  Future<void> clearAll();
}

//Only used when persistence is enabled
enum PikuMessagesBoxNames { MESSAGES, MESSAGES_TO_CLIENT_INSTANCE_KEY }

class PersistedPikuMessagesDao extends PikuMessagesDao {
  // box containing all persisted messages
  final Box<PikuMessage> _box;

  final String _clientInstanceKey;

  //box with one to many relation
  final Box<String> _messageIdToClientInstanceKeyBox;

  PersistedPikuMessagesDao(this._box, this._messageIdToClientInstanceKeyBox,
      this._clientInstanceKey);

  @override
  Future<void> clear() async {
    //filter current client instance message ids
    Iterable clientMessageIds = _messageIdToClientInstanceKeyBox.keys.where(
        (key) =>
            _messageIdToClientInstanceKeyBox.get(key) == _clientInstanceKey);

    await _box.deleteAll(clientMessageIds);
    await _messageIdToClientInstanceKeyBox.deleteAll(clientMessageIds);
  }

  @override
  Future<void> saveMessage(PikuMessage message) async {
    await _box.put(message.id, message);
    await _messageIdToClientInstanceKeyBox.put(message.id, _clientInstanceKey);
    print("saved");
  }

  @override
  Future<void> saveAllMessages(List<PikuMessage> messages) async {
    for (PikuMessage message in messages) {
      await saveMessage(message);
    }
  }

  @override
  List<PikuMessage> getMessages() {
    final messageClientInstancekey = _clientInstanceKey;

    //filter current client instance message ids
    Set<int> clientMessageIds = _messageIdToClientInstanceKeyBox.keys
        .map((e) => e as int)
        .where((key) =>
            _messageIdToClientInstanceKeyBox.get(key) ==
            messageClientInstancekey)
        .toSet();

    //retrieve messages with ids
    List<PikuMessage> sortedMessages = _box.values
        .where((message) => clientMessageIds.contains(message.id))
        .toList(growable: false);

    //sort message using creation dates
    sortedMessages.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });

    return sortedMessages;
  }

  @override
  Future<void> onDispose() async {}

  @override
  Future<void> deleteMessage(int messageId) async {
    await _box.delete(messageId);
    await _messageIdToClientInstanceKeyBox.delete(messageId);
  }

  @override
  PikuMessage? getMessage(int messageId) {
    return _box.get(messageId, defaultValue: null);
  }

  @override
  Future<void> clearAll() async {
    await _box.clear();
    await _messageIdToClientInstanceKeyBox.clear();
  }

  static Future<void> openDB() async {
    await Hive.openBox<PikuMessage>(PikuMessagesBoxNames.MESSAGES.toString());
    await Hive.openBox<String>(
        PikuMessagesBoxNames.MESSAGES_TO_CLIENT_INSTANCE_KEY.toString());
  }
}

class NonPersistedPikuMessagesDao extends PikuMessagesDao {
  final HashMap<int, PikuMessage> _messages = HashMap();

  @override
  Future<void> clear() async {
    _messages.clear();
  }

  @override
  Future<void> deleteMessage(int messageId) async {
    _messages.remove(messageId);
  }

  @override
  PikuMessage? getMessage(int messageId) {
    return _messages[messageId];
  }

  @override
  List<PikuMessage> getMessages() {
    List<PikuMessage> sortedMessages = _messages.values.toList(growable: false);
    sortedMessages.sort((a, b) {
      return a.createdAt.compareTo(b.createdAt);
    });
    return sortedMessages;
  }

  @override
  Future<void> onDispose() async {
    _messages.clear();
  }

  @override
  Future<void> saveAllMessages(List<PikuMessage> messages) async {
    messages.forEach((element) async {
      await saveMessage(element);
    });
  }

  @override
  Future<void> saveMessage(PikuMessage message) async {
    _messages.update(message.id, (value) => message, ifAbsent: () => message);
  }

  @override
  Future<void> clearAll() async {
    _messages.clear();
  }
}

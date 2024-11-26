import 'package:hive_flutter/hive_flutter.dart';

import '../entity/piku_conversation.dart';

abstract class PikuConversationDao {
  Future<void> saveConversation(PikuConversation conversation);
  PikuConversation? getConversation();
  Future<void> deleteConversation();
  Future<void> onDispose();
  Future<void> clearAll();
}

//Only used when persistence is enabled
enum PikuConversationBoxNames {
  CONVERSATIONS,
  CLIENT_INSTANCE_TO_CONVERSATIONS
}

class PersistedPikuConversationDao extends PikuConversationDao {
  //box containing all persisted conversations
  final Box<PikuConversation> _box;

  //box with one to one relation between generated client instance id and conversation id
  final Box<String> _clientInstanceIdToConversationIdentifierBox;

  final String _clientInstanceKey;

  PersistedPikuConversationDao(
      this._box,
      this._clientInstanceIdToConversationIdentifierBox,
      this._clientInstanceKey);

  @override
  Future<void> deleteConversation() async {
    final conversationIdentifier =
        _clientInstanceIdToConversationIdentifierBox.get(_clientInstanceKey);
    await _clientInstanceIdToConversationIdentifierBox
        .delete(_clientInstanceKey);
    await _box.delete(conversationIdentifier);
  }

  @override
  Future<void> saveConversation(PikuConversation conversation) async {
    await _clientInstanceIdToConversationIdentifierBox.put(
        _clientInstanceKey, conversation.id.toString());
    await _box.put(conversation.id, conversation);
  }

  @override
  PikuConversation? getConversation() {
    if (_box.values.isEmpty) {
      return null;
    }

    final conversationidentifierString =
        _clientInstanceIdToConversationIdentifierBox.get(_clientInstanceKey);
    final conversationIdentifier =
        int.tryParse(conversationidentifierString ?? "");

    if (conversationIdentifier == null) {
      return null;
    }

    return _box.get(conversationIdentifier);
  }

  @override
  Future<void> onDispose() async {}

  static Future<void> openDB() async {
    await Hive.openBox<PikuConversation>(
        PikuConversationBoxNames.CONVERSATIONS.toString());
    await Hive.openBox<String>(
        PikuConversationBoxNames.CLIENT_INSTANCE_TO_CONVERSATIONS.toString());
  }

  @override
  Future<void> clearAll() async {
    await _box.clear();
    await _clientInstanceIdToConversationIdentifierBox.clear();
  }
}

class NonPersistedPikuConversationDao extends PikuConversationDao {
  PikuConversation? _conversation;

  @override
  Future<void> deleteConversation() async {
    _conversation = null;
  }

  @override
  PikuConversation? getConversation() {
    return _conversation;
  }

  @override
  Future<void> onDispose() async {
    _conversation = null;
  }

  @override
  Future<void> saveConversation(PikuConversation conversation) async {
    _conversation = conversation;
  }

  @override
  Future<void> clearAll() async {
    _conversation = null;
  }
}

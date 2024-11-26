import 'package:hive_flutter/hive_flutter.dart';

import '../entity/piku_user.dart';

abstract class PikuUserDao {
  Future<void> saveUser(PikuUser user);
  PikuUser? getUser();
  Future<void> deleteUser();
  Future<void> onDispose();
  Future<void> clearAll();
}

//Only used when persistence is enabled
enum PikuUserBoxNames { USERS, CLIENT_INSTANCE_TO_USER }

class PersistedPikuUserDao extends PikuUserDao {
  //box containing chat users
  final Box<PikuUser> _box;
  //box with one to one relation between generated client instance id and user identifier
  final Box<String> _clientInstanceIdToUserIdentifierBox;

  final String _clientInstanceKey;

  PersistedPikuUserDao(this._box, this._clientInstanceIdToUserIdentifierBox,
      this._clientInstanceKey);

  @override
  Future<void> deleteUser() async {
    final userIdentifier =
        _clientInstanceIdToUserIdentifierBox.get(_clientInstanceKey);
    await _clientInstanceIdToUserIdentifierBox.delete(_clientInstanceKey);
    await _box.delete(userIdentifier);
  }

  @override
  Future<void> saveUser(PikuUser user) async {
    await _clientInstanceIdToUserIdentifierBox.put(
        _clientInstanceKey, user.identifier.toString());
    await _box.put(user.identifier, user);
  }

  @override
  PikuUser? getUser() {
    if (_box.values.isEmpty) {
      return null;
    }
    final userIdentifier =
        _clientInstanceIdToUserIdentifierBox.get(_clientInstanceKey);

    return _box.get(userIdentifier);
  }

  @override
  Future<void> onDispose() async {}

  @override
  Future<void> clearAll() async {
    await _box.clear();
    await _clientInstanceIdToUserIdentifierBox.clear();
  }

  static Future<void> openDB() async {
    await Hive.openBox<PikuUser>(PikuUserBoxNames.USERS.toString());
    await Hive.openBox<String>(
        PikuUserBoxNames.CLIENT_INSTANCE_TO_USER.toString());
  }
}

class NonPersistedPikuUserDao extends PikuUserDao {
  PikuUser? _user;

  @override
  Future<void> deleteUser() async {
    _user = null;
  }

  @override
  PikuUser? getUser() {
    return _user;
  }

  @override
  Future<void> onDispose() async {
    _user = null;
  }

  @override
  Future<void> saveUser(PikuUser user) async {
    _user = user;
  }

  @override
  Future<void> clearAll() async {
    _user = null;
  }
}

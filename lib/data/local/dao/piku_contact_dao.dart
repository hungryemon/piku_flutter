import 'package:hive_flutter/hive_flutter.dart';

import '../entity/piku_contact.dart';

///Data access object for retriving piku contact from local storage
abstract class PikuContactDao {
  Future<void> saveContact(PikuContact contact);
  PikuContact? getContact();
  Future<void> deleteContact();
  Future<void> onDispose();
  Future<void> clearAll();
}

//Only used when persistence is enabled
enum PikuContactBoxNames { CONTACTS, CLIENT_INSTANCE_TO_CONTACTS }

class PersistedPikuContactDao extends PikuContactDao {
  //box containing all persisted contacts
  final Box<PikuContact> _box;

  //_box with one to one relation between generated client instance id and conversation id
  final Box<String> _clientInstanceIdToContactIdentifierBox;

  final String _clientInstanceKey;

  PersistedPikuContactDao(this._box,
      this._clientInstanceIdToContactIdentifierBox, this._clientInstanceKey);

  @override
  Future<void> deleteContact() async {
    final contactIdentifier =
        _clientInstanceIdToContactIdentifierBox.get(_clientInstanceKey);
    await _clientInstanceIdToContactIdentifierBox.delete(_clientInstanceKey);
    await _box.delete(contactIdentifier);
  }

  @override
  Future<void> saveContact(PikuContact contact) async {
    await _clientInstanceIdToContactIdentifierBox.put(
        _clientInstanceKey, contact.contactIdentifier!);
    await _box.put(contact.contactIdentifier, contact);
  }

  @override
  PikuContact? getContact() {
    if (_box.values.isEmpty) {
      return null;
    }

    final contactIdentifier =
        _clientInstanceIdToContactIdentifierBox.get(_clientInstanceKey);

    if (contactIdentifier == null) {
      return null;
    }

    return _box.get(contactIdentifier, defaultValue: null);
  }

  @override
  Future<void> onDispose() async {}

  @override
  Future<void> clearAll() async {
    await _box.clear();
    await _clientInstanceIdToContactIdentifierBox.clear();
  }

  static Future<void> openDB() async {
    await Hive.openBox<PikuContact>(PikuContactBoxNames.CONTACTS.toString());
    await Hive.openBox<String>(
        PikuContactBoxNames.CLIENT_INSTANCE_TO_CONTACTS.toString());
  }
}

class NonPersistedPikuContactDao extends PikuContactDao {
  PikuContact? _contact;

  @override
  Future<void> deleteContact() async {
    _contact = null;
  }

  @override
  PikuContact? getContact() {
    return _contact;
  }

  @override
  Future<void> onDispose() async {
    _contact = null;
  }

  @override
  Future<void> saveContact(PikuContact contact) async {
    _contact = contact;
  }

  @override
  Future<void> clearAll() async {
    _contact = null;
  }
}

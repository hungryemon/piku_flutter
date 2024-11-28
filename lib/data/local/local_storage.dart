import 'package:hive_flutter/hive_flutter.dart';

import '../remote/responses/piku_event.dart';
import 'dao/piku_contact_dao.dart';
import 'dao/piku_conversation_dao.dart';
import 'dao/piku_messages_dao.dart';
import 'dao/piku_user_dao.dart';
import 'entity/piku_attachment.dart';
import 'entity/piku_contact.dart';
import 'entity/piku_conversation.dart';
import 'entity/piku_message.dart';
import 'entity/piku_user.dart';


const PIKU_CONTACT_HIVE_TYPE_ID = 0;
const PIKU_CONVERSATION_HIVE_TYPE_ID = 1;
const PIKU_MESSAGE_HIVE_TYPE_ID = 2;
const PIKU_USER_HIVE_TYPE_ID = 3;
const PIKU_EVENT_USER_HIVE_TYPE_ID = 4;
const PIKU_ATTACHMENT_HIVE_TYPE_ID = 5;


class LocalStorage {
  PikuUserDao userDao;
  PikuConversationDao conversationDao;
  PikuContactDao contactDao;
  PikuMessagesDao messagesDao;

  LocalStorage({
    required this.userDao,
    required this.conversationDao,
    required this.contactDao,
    required this.messagesDao,
  });

  static Future<void> openDB({void Function()? onInitializeHive}) async {
    if (onInitializeHive == null) {
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(PIKU_ATTACHMENT_HIVE_TYPE_ID)) {
        Hive.registerAdapter(PikuAttachmentAdapter());
      }
      if (!Hive.isAdapterRegistered(PIKU_CONTACT_HIVE_TYPE_ID)) {
        Hive.registerAdapter(PikuContactAdapter());
      }
      if (!Hive.isAdapterRegistered(PIKU_CONVERSATION_HIVE_TYPE_ID)) {
        Hive.registerAdapter(PikuConversationAdapter());
      }
      if (!Hive.isAdapterRegistered(PIKU_MESSAGE_HIVE_TYPE_ID)) {
        Hive.registerAdapter(PikuMessageAdapter());
      }
      if (!Hive.isAdapterRegistered(PIKU_EVENT_USER_HIVE_TYPE_ID)) {
        Hive.registerAdapter(PikuEventMessageUserAdapter());
      }
      if (!Hive.isAdapterRegistered(PIKU_USER_HIVE_TYPE_ID)) {
        Hive.registerAdapter(PikuUserAdapter());
      }
    } else {
      onInitializeHive();
    }

    await PersistedPikuContactDao.openDB();
    await PersistedPikuConversationDao.openDB();
    await PersistedPikuMessagesDao.openDB();
    await PersistedPikuUserDao.openDB();
  }

  Future<void> clear({bool clearPikuUserStorage = true}) async {
    await conversationDao.deleteConversation();
    await messagesDao.clear();
    if (clearPikuUserStorage) {
      await userDao.deleteUser();
      await contactDao.deleteContact();
    }
  }

  Future<void> clearAll() async {
    await conversationDao.clearAll();
    await contactDao.clearAll();
    await messagesDao.clearAll();
    await userDao.clearAll();
  }

  dispose() {
    userDao.onDispose();
    conversationDao.onDispose();
    contactDao.onDispose();
    messagesDao.onDispose();
  }
}

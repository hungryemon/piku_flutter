
import 'data/local/entity/piku_message.dart';
import 'data/remote/piku_client_exception.dart';

///Piku callback are specified for each created client instance. Methods are triggered
///when a method satisfying their respective conditions occur.
///
///
/// {@category FlutterClientSdk}
class PikuCallbacks {
  ///Triggered when a welcome event/message is received after connecting to
  ///the piku websocket. See [PikuRepository.listenForEvents]
  void Function()? onWelcome;

  ///Triggered when a ping event/message is received after connecting to
  ///the piku websocket. See [PikuRepository.listenForEvents]
  void Function()? onPing;

  ///Triggered when a subscription confirmation event/message is received after connecting to
  ///the piku websocket. See [PikuRepository.listenForEvents]
  void Function()? onConfirmedSubscription;

  ///Triggered when a conversation typing on event/message [PikuEventMessageType.conversation_typing_on]
  ///is received after connecting to the piku websocket. See [PikuRepository.listenForEvents]
  void Function()? onConversationStartedTyping;

  ///Triggered when a presence update event/message [PikuEventMessageType.presence_update]
  ///is received after connecting to the piku websocket and conversation is online. See [PikuRepository.listenForEvents]
  void Function()? onConversationIsOnline;

  ///Triggered when a presence update event/message [PikuEventMessageType.presence_update]
  ///is received after connecting to the piku websocket and conversation is offline.
  ///See [PikuRepository.listenForEvents]
  void Function()? onConversationIsOffline;

  ///Triggered when a conversation typing off event/message [PikuEventMessageType.conversation_typing_off]
  ///is received after connecting to the piku websocket. See [PikuRepository.listenForEvents]
  void Function()? onConversationStoppedTyping;

  ///Triggered when a message created event/message [PikuEventMessageType.message_created]
  ///is received and message doesn't belong to current user after connecting to the piku websocket.
  ///See [PikuRepository.listenForEvents]
  void Function(PikuMessage)? onMessageReceived;

  ///Triggered when a message created event/message [PikuEventMessageType.message_updated]
  ///is received after connecting to the piku websocket.
  ///See [PikuRepository.listenForEvents]
  void Function(PikuMessage, bool)? onMessageUpdated;

  void Function(PikuMessage, String, bool)? onMessageSent;

  ///Triggered when a message created event/message [PikuEventMessageType.message_created]
  ///is received and message belongs to current user after connecting to the piku websocket.
  ///See [PikuRepository.listenForEvents]
  void Function(PikuMessage, String)? onMessageDelivered;

  ///Triggered when a conversation's messages persisted on device are successfully retrieved
  void Function(List<PikuMessage>)? onPersistedMessagesRetrieved;

  ///Triggered when a conversation's messages is successfully retrieved from remote server
  void Function(List<PikuMessage>)? onMessagesRetrieved;

  ///Triggered when an agent resolves the current conversation
  void Function()? onConversationResolved;

  /// Triggered when any error occurs in piku client's operations with the error
  ///
  /// See [PikuClientExceptionType] for the various types of exceptions that can be triggered
  void Function(PikuClientException)? onError;

  PikuCallbacks({
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
    this.onConversationResolved,
    this.onError,
  });
}

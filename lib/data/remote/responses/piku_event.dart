import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../local/entity/piku_message.dart';
import '../../local/local_storage.dart';

part 'piku_event.g.dart';

@JsonSerializable(explicitToJson: true)
class PikuEvent {
  @JsonKey(toJson: eventTypeToJson, fromJson: eventTypeFromJson)
  final PikuEventType? type;

  @JsonKey()
  final String? identifier;

  @JsonKey(fromJson: eventMessageFromJson)
  final PikuEventMessage? message;

  PikuEvent({this.type, this.message, this.identifier});

  factory PikuEvent.fromJson(Map<String, dynamic> json) =>
      _$PikuEventFromJson(json);

  Map<String, dynamic> toJson() => _$PikuEventToJson(this);
}

PikuEventMessage? eventMessageFromJson(value) {
  if (value == null) {
    return null;
  } else if (value is num) {
    return PikuEventMessage();
  } else if (value is String) {
    return PikuEventMessage();
  } else {
    return PikuEventMessage.fromJson(value as Map<String, dynamic>);
  }
}

@JsonSerializable(explicitToJson: true)
class PikuEventMessage {
  @JsonKey()
  final PikuEventMessageData? data;

  @JsonKey(toJson: eventMessageTypeToJson, fromJson: eventMessageTypeFromJson)
  final PikuEventMessageType? event;

  PikuEventMessage({this.data, this.event});

  factory PikuEventMessage.fromJson(Map<String, dynamic> json) =>
      _$PikuEventMessageFromJson(json);

  Map<String, dynamic> toJson() => _$PikuEventMessageToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PikuEventMessageData {
  @JsonKey(name: "account_id")
  final int? accountId;

  @JsonKey()
  final String? content;

  @JsonKey(name: "content_attributes")
  final dynamic contentAttributes;

  @JsonKey(name: "content_type")
  final String? contentType;

  @JsonKey(name: "conversation_id")
  final int? conversationId;

  @JsonKey(name: "created_at")
  final dynamic createdAt;

  @JsonKey(name: "echo_id")
  final String? echoId;

  @JsonKey(name: "external_source_ids")
  final dynamic externalSourceIds;

  @JsonKey()
  final int? id;

  @JsonKey(name: "inbox_id")
  final int? inboxId;

  @JsonKey(name: "message_type")
  final int? messageType;

  @JsonKey(name: "private")
  final bool? private;

  @JsonKey()
  final PikuEventMessageUser? sender;

  @JsonKey(name: "sender_id")
  final int? senderId;

  @JsonKey(name: "source_id")
  final String? sourceId;

  @JsonKey()
  final String? status;

  @JsonKey(name: "updated_at")
  final dynamic updatedAt;

  @JsonKey()
  final dynamic conversation;

  @JsonKey()
  final PikuEventMessageUser? user;

  @JsonKey()
  final dynamic users;

  PikuEventMessageData(
      {this.id,
      this.user,
      this.conversation,
      this.echoId,
      this.sender,
      this.conversationId,
      this.createdAt,
      this.contentAttributes,
      this.contentType,
      this.messageType,
      this.content,
      this.inboxId,
      this.sourceId,
      this.updatedAt,
      this.status,
      this.accountId,
      this.externalSourceIds,
      this.private,
      this.senderId,
      this.users});

  factory PikuEventMessageData.fromJson(Map<String, dynamic> json) =>
      _$PikuEventMessageDataFromJson(json);

  Map<String, dynamic> toJson() => _$PikuEventMessageDataToJson(this);

  getMessage() {
    return PikuMessage.fromJson(toJson());
  }
}

/// {@category FlutterClientSdk}
@HiveType(typeId: PIKU_EVENT_USER_HIVE_TYPE_ID)
@JsonSerializable(explicitToJson: true)
class PikuEventMessageUser extends Equatable {
  @JsonKey(name: "avatar_url")
  @HiveField(0)
  final String? avatarUrl;

  @JsonKey()
  @HiveField(1)
  final int? id;

  @JsonKey()
  @HiveField(2)
  final String? name;

  @JsonKey()
  @HiveField(3)
  final String? thumbnail;

  const PikuEventMessageUser(
      {this.id, this.avatarUrl, this.name, this.thumbnail});

  factory PikuEventMessageUser.fromJson(Map<String, dynamic> json) =>
      _$PikuEventMessageUserFromJson(json);

  Map<String, dynamic> toJson() => _$PikuEventMessageUserToJson(this);

  @override
  List<Object?> get props => [id, avatarUrl, name, thumbnail];
}

enum PikuEventType { welcome, ping, confirm_subscription }

String? eventTypeToJson(PikuEventType? actionType) {
  return actionType.toString();
}

PikuEventType? eventTypeFromJson(String? value) {
  switch (value) {
    case "welcome":
      return PikuEventType.welcome;
    case "ping":
      return PikuEventType.ping;
    case "confirm_subscription":
      return PikuEventType.confirm_subscription;
    default:
      return null;
  }
}

enum PikuEventMessageType {
  presence_update,
  message_created,
  message_updated,
  conversation_typing_off,
  conversation_typing_on,
  conversation_status_changed
}

String? eventMessageTypeToJson(PikuEventMessageType? actionType) {
  switch (actionType) {
    case null:
      return null;
    case PikuEventMessageType.conversation_typing_on:
      return "conversation.typing_on";
    case PikuEventMessageType.conversation_typing_off:
      return "conversation.typing_off";
    case PikuEventMessageType.presence_update:
      return "presence.update";
    case PikuEventMessageType.message_created:
      return "message.created";
    case PikuEventMessageType.message_updated:
      return "message.updated";
    case PikuEventMessageType.conversation_status_changed:
      return "conversation.status_changed";
    default:
      return actionType.toString();
  }
}

PikuEventMessageType? eventMessageTypeFromJson(String? value) {
  switch (value) {
    case "presence.update":
      return PikuEventMessageType.presence_update;
    case "message.created":
      return PikuEventMessageType.message_created;
    case "message.updated":
      return PikuEventMessageType.message_updated;
    case "conversation.typing_on":
      return PikuEventMessageType.conversation_typing_on;
    case "conversation.typing_off":
      return PikuEventMessageType.conversation_typing_off;
    case "conversation.status_changed":
      return PikuEventMessageType.conversation_status_changed;
    default:
      return null;
  }
}

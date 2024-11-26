import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:piku_flutter/data/local/entity/piku_message.dart';

import '../local_storage.dart';
import 'piku_contact.dart';
part 'piku_conversation.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: PIKU_CONVERSATION_HIVE_TYPE_ID)
class PikuConversation extends Equatable {
  ///The numeric ID of the conversation
  @JsonKey()
  @HiveField(0)
  final int id;

  ///The numeric ID of the inbox
  @JsonKey(name: "inbox_id")
  @HiveField(1)
  final int inboxId;

  ///List of all messages from the conversation
  @JsonKey()
  @HiveField(2)
  final List<PikuMessage> messages;

  ///Contact of the conversation
  @JsonKey()
  @HiveField(3)
  final PikuContact contact;

  const PikuConversation(
      {required this.id,
      required this.inboxId,
      required this.messages,
      required this.contact});

  factory PikuConversation.fromJson(Map<String, dynamic> json) =>
      _$PikuConversationFromJson(json);

  Map<String, dynamic> toJson() => _$PikuConversationToJson(this);

  @override
  List<Object?> get props => [id, inboxId, messages, contact];
}

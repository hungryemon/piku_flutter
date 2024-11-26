// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piku_conversation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PikuConversationAdapter extends TypeAdapter<PikuConversation> {
  @override
  final int typeId = 1;

  @override
  PikuConversation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PikuConversation(
      id: fields[0] as int,
      inboxId: fields[1] as int,
      messages: (fields[2] as List).cast<PikuMessage>(),
      contact: fields[3] as PikuContact,
    );
  }

  @override
  void write(BinaryWriter writer, PikuConversation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.inboxId)
      ..writeByte(2)
      ..write(obj.messages)
      ..writeByte(3)
      ..write(obj.contact);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PikuConversationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PikuConversation _$PikuConversationFromJson(Map<String, dynamic> json) =>
    PikuConversation(
      id: (json['id'] as num).toInt(),
      inboxId: (json['inbox_id'] as num).toInt(),
      messages: (json['messages'] as List<dynamic>)
          .map((e) => PikuMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      contact: PikuContact.fromJson(json['contact'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PikuConversationToJson(PikuConversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inbox_id': instance.inboxId,
      'messages': instance.messages.map((e) => e.toJson()).toList(),
      'contact': instance.contact.toJson(),
    };

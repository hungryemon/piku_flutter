// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piku_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PikuMessageAdapter extends TypeAdapter<PikuMessage> {
  @override
  final int typeId = 2;

  @override
  PikuMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PikuMessage(
      id: fields[0] as int,
      content: fields[1] as String?,
      messageType: fields[2] as int?,
      contentType: fields[3] as String?,
      contentAttributes: fields[4] as dynamic,
      createdAt: fields[5] as String,
      conversationId: fields[6] as int?,
      attachments: (fields[7] as List?)?.cast<PikuAttachment>(),
      sender: fields[8] as PikuEventMessageUser?,
    );
  }

  @override
  void write(BinaryWriter writer, PikuMessage obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.messageType)
      ..writeByte(3)
      ..write(obj.contentType)
      ..writeByte(4)
      ..write(obj.contentAttributes)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.conversationId)
      ..writeByte(7)
      ..write(obj.attachments)
      ..writeByte(8)
      ..write(obj.sender);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PikuMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PikuMessage _$PikuMessageFromJson(Map<String, dynamic> json) => PikuMessage(
      id: idFromJson(json['id']),
      content: json['content'] as String?,
      messageType: messageTypeFromJson(json['message_type']),
      contentType: json['content_type'] as String?,
      contentAttributes: json['content_attributes'],
      createdAt: createdAtFromJson(json['created_at']),
      conversationId: idFromJson(json['conversation_id']),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => PikuAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      sender: json['sender'] == null
          ? null
          : PikuEventMessageUser.fromJson(
              json['sender'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PikuMessageToJson(PikuMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'message_type': instance.messageType,
      'content_type': instance.contentType,
      'content_attributes': instance.contentAttributes,
      'created_at': instance.createdAt,
      'conversation_id': instance.conversationId,
      'attachments': instance.attachments?.map((e) => e.toJson()).toList(),
      'sender': instance.sender?.toJson(),
    };

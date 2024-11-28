// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piku_attachment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PikuAttachmentAdapter extends TypeAdapter<PikuAttachment> {
  @override
  final int typeId = 5;

  @override
  PikuAttachment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PikuAttachment(
      id: fields[0] as int?,
      messageId: fields[1] as int?,
      fileType: fields[2] as String?,
      accountId: fields[3] as int?,
      extension: fields[4] as dynamic,
      dataUrl: fields[5] as String?,
      thumbUrl: fields[6] as String?,
      fileSize: fields[7] as int?,
      width: fields[8] as int?,
      height: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PikuAttachment obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.messageId)
      ..writeByte(2)
      ..write(obj.fileType)
      ..writeByte(3)
      ..write(obj.accountId)
      ..writeByte(4)
      ..write(obj.extension)
      ..writeByte(5)
      ..write(obj.dataUrl)
      ..writeByte(6)
      ..write(obj.thumbUrl)
      ..writeByte(7)
      ..write(obj.fileSize)
      ..writeByte(8)
      ..write(obj.width)
      ..writeByte(9)
      ..write(obj.height);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PikuAttachmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PikuAttachment _$PikuAttachmentFromJson(Map<String, dynamic> json) =>
    PikuAttachment(
      id: (json['id'] as num?)?.toInt(),
      messageId: messageIdFromJson(json['message_id']),
      fileType: json['file_type'] as String?,
      accountId: (json['account_id'] as num?)?.toInt(),
      extension: json['extension'],
      dataUrl: json['data_url'] as String?,
      thumbUrl: json['thumb_url'] as String?,
      fileSize: (json['file_size'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PikuAttachmentToJson(PikuAttachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message_id': instance.messageId,
      'file_type': instance.fileType,
      'account_id': instance.accountId,
      'extension': instance.extension,
      'data_url': instance.dataUrl,
      'thumb_url': instance.thumbUrl,
      'file_size': instance.fileSize,
      'width': instance.width,
      'height': instance.height,
    };

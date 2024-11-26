// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piku_contact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PikuContactAdapter extends TypeAdapter<PikuContact> {
  @override
  final int typeId = 0;

  @override
  PikuContact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PikuContact(
      id: fields[0] as int,
      contactIdentifier: fields[1] as String?,
      pubsubToken: fields[2] as String?,
      name: fields[3] as String?,
      email: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PikuContact obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.contactIdentifier)
      ..writeByte(2)
      ..write(obj.pubsubToken)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PikuContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PikuContact _$PikuContactFromJson(Map<String, dynamic> json) => PikuContact(
      id: (json['id'] as num).toInt(),
      contactIdentifier: json['source_id'] as String?,
      pubsubToken: json['pubsub_token'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$PikuContactToJson(PikuContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source_id': instance.contactIdentifier,
      'pubsub_token': instance.pubsubToken,
      'name': instance.name,
      'email': instance.email,
    };

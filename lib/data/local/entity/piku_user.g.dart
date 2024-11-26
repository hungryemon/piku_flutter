// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piku_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PikuUserAdapter extends TypeAdapter<PikuUser> {
  @override
  final int typeId = 3;

  @override
  PikuUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PikuUser(
      identifier: fields[0] as String?,
      identifierHash: fields[1] as String?,
      name: fields[2] as String?,
      email: fields[3] as String?,
      avatarUrl: fields[4] as String?,
      customAttributes: fields[5] as dynamic,
      phoneNumber: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PikuUser obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.identifier)
      ..writeByte(1)
      ..write(obj.identifierHash)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.avatarUrl)
      ..writeByte(5)
      ..write(obj.customAttributes)
      ..writeByte(6)
      ..write(obj.phoneNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PikuUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PikuUser _$PikuUserFromJson(Map<String, dynamic> json) => PikuUser(
      identifier: json['identifier'] as String?,
      identifierHash: json['identifier_hash'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      customAttributes: json['custom_attributes'],
      phoneNumber: json['phone_number'] as String?,
    );

Map<String, dynamic> _$PikuUserToJson(PikuUser instance) => <String, dynamic>{
      'identifier': instance.identifier,
      'identifier_hash': instance.identifierHash,
      'name': instance.name,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
      'custom_attributes': instance.customAttributes,
      'phone_number': instance.phoneNumber,
    };

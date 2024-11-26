import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../local_storage.dart';

part 'piku_user.g.dart';

///
@JsonSerializable(explicitToJson: true)
@HiveType(typeId: PIKU_USER_HIVE_TYPE_ID)
class PikuUser extends Equatable {
  ///custom Piku user identifier
  @JsonKey()
  @HiveField(0)
  final String? identifier;

  ///custom user identifier hash
  @JsonKey(name: "identifier_hash")
  @HiveField(1)
  final String? identifierHash;

  ///name of Piku user
  @JsonKey()
  @HiveField(2)
  final String? name;

  ///email of Piku user
  @JsonKey()
  @HiveField(3)
  final String? email;

  ///profile picture url of user
  @JsonKey(name: "avatar_url")
  @HiveField(4)
  final String? avatarUrl;

  ///any other custom attributes to be linked to the user
  @JsonKey(name: "custom_attributes")
  @HiveField(5)
  final dynamic customAttributes;

  ///any other custom attributes to be linked to the user
  @JsonKey(name: "phone_number")
  @HiveField(6)
  final String? phoneNumber;

  const PikuUser(
      {this.identifier,
      this.identifierHash,
      this.name,
      this.email,
      this.avatarUrl,
      this.customAttributes,
      this.phoneNumber});

  @override
  List<Object?> get props => [
        identifier,
        identifierHash,
        name,
        email,
        avatarUrl,
        customAttributes,
        phoneNumber
      ];

  factory PikuUser.fromJson(Map<String, dynamic> json) =>
      _$PikuUserFromJson(json);

  Map<String, dynamic> toJson() => _$PikuUserToJson(this);
}

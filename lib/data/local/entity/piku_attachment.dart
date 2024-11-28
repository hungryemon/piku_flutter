import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:piku_flutter/data/local/local_storage.dart';

part 'piku_attachment.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(
    typeId:
        PIKU_ATTACHMENT_HIVE_TYPE_ID) // Assign a unique typeId for this model
class PikuAttachment extends Equatable {
  @JsonKey()
  @HiveField(0)
  final int? id;

  @JsonKey(name: "message_id", fromJson: messageIdFromJson)
  @HiveField(1)
  final int? messageId;

  @JsonKey(name: "file_type")
  @HiveField(2)
  final String? fileType;

  @JsonKey(name: "account_id")
  @HiveField(3)
  final int? accountId;

  @JsonKey()
  @HiveField(4)
  final dynamic extension;

  @JsonKey(name: "data_url")
  @HiveField(5)
  final String? dataUrl;

  @JsonKey(name: "thumb_url")
  @HiveField(6)
  final String? thumbUrl;

  @JsonKey(name: "file_size")
  @HiveField(7)
  final int? fileSize;

  @JsonKey()
  @HiveField(8)
  final int? width;

  @JsonKey()
  @HiveField(9)
  final int? height;

  const PikuAttachment({
    this.id,
    this.messageId,
    this.fileType,
    this.accountId,
    this.extension,
    this.dataUrl,
    this.thumbUrl,
    this.fileSize,
    this.width,
    this.height,
  });

  factory PikuAttachment.fromJson(Map<String, dynamic> json) =>
      _$PikuAttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$PikuAttachmentToJson(this);

  @override
  List<Object?> get props => [
        id,
        messageId,
        fileType,
        accountId,
        extension,
        dataUrl,
        thumbUrl,
        fileSize,
        width,
        height
      ];
}

int? messageIdFromJson(value) {
  print("VALUEEE: $value");
  if (value == null) {
    return null; // Return null if the value is null
  }
  if (value is String) {
    return int.tryParse(
        value); // Try to parse the string to int, return null if it fails
  }
  if (value is int) {
    return value; // If it's already an integer, return as is
  }
  return null;
}

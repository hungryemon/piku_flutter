// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piku_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PikuAction _$PikuActionFromJson(Map<String, dynamic> json) => PikuAction(
      identifier: json['identifier'] as String,
      data: json['data'] == null
          ? null
          : PikuActionData.fromJson(json['data'] as Map<String, dynamic>),
      command: json['command'] as String,
    );

Map<String, dynamic> _$PikuActionToJson(PikuAction instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'command': instance.command,
      'data': instance.data?.toJson(),
    };

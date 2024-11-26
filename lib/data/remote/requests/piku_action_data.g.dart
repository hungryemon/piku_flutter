// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piku_action_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PikuActionData _$PikuActionDataFromJson(Map<String, dynamic> json) =>
    PikuActionData(
      action: actionTypeFromJson(json['action'] as String?),
    );

Map<String, dynamic> _$PikuActionDataToJson(PikuActionData instance) =>
    <String, dynamic>{
      'action': actionTypeToJson(instance.action),
    };

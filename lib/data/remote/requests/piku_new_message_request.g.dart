// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piku_new_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PikuNewMessageRequest _$PikuNewMessageRequestFromJson(
        Map<String, dynamic> json) =>
    PikuNewMessageRequest(
      content: json['content'] as String,
      echoId: json['echo_id'] as String,
    );

Map<String, dynamic> _$PikuNewMessageRequestToJson(
        PikuNewMessageRequest instance) =>
    <String, dynamic>{
      'content': instance.content,
      'echo_id': instance.echoId,
    };

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'piku_new_message_request.g.dart';

@JsonSerializable(explicitToJson: true)
class PikuNewMessageRequest extends Equatable {
  @JsonKey()
  final String content;
  @JsonKey(name: "echo_id")
  final String echoId;

  const PikuNewMessageRequest({required this.content, required this.echoId});

  @override
  List<Object> get props => [content, echoId];

  factory PikuNewMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$PikuNewMessageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PikuNewMessageRequestToJson(this);
}

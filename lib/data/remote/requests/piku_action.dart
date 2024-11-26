import 'package:json_annotation/json_annotation.dart';

import 'piku_action_data.dart';


part 'piku_action.g.dart';

@JsonSerializable(explicitToJson: true)
class PikuAction {
  @JsonKey()
  final String identifier;

  @JsonKey()
  final String command;

  @JsonKey()
  final PikuActionData? data;

  PikuAction({required this.identifier, this.data, required this.command});

  factory PikuAction.fromJson(Map<String, dynamic> json) =>
      _$PikuActionFromJson(json);

  Map<String, dynamic> toJson() => _$PikuActionToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'piku_action_data.g.dart';

@JsonSerializable(explicitToJson: true)
class PikuActionData {
  @JsonKey(toJson: actionTypeToJson, fromJson: actionTypeFromJson)
  final PikuActionType action;

  PikuActionData({required this.action});

  factory PikuActionData.fromJson(Map<String, dynamic> json) =>
      _$PikuActionDataFromJson(json);

  Map<String, dynamic> toJson() => _$PikuActionDataToJson(this);
}

enum PikuActionType { subscribe, update_presence }

String actionTypeToJson(PikuActionType actionType) {
  switch (actionType) {
    case PikuActionType.update_presence:
      return "update_presence";
    case PikuActionType.subscribe:
      return "subscribe";
  }
}

PikuActionType actionTypeFromJson(String? value) {
  switch (value) {
    case "update_presence":
      return PikuActionType.update_presence;
    case "subscribe":
      return PikuActionType.subscribe;
    default:
      return PikuActionType.update_presence;
  }
}

import 'package:flutter_app/Model/HomeModelData.dart';
import 'package:json_annotation/json_annotation.dart';

part 'WidgetHome.g.dart';

@JsonSerializable()
class WidgetHome {
  WidgetHome(this.type, this.bgColor, this.textColor, this.data);

  String type;
  @JsonKey(name: 'background_color')
  String bgColor;
  @JsonKey(name: 'text_color')
  String textColor;
  HomeModelData data;

  factory WidgetHome.fromJson(Map<String, dynamic> json) => _$WidgetHomeFromJson(json);

  Map<String, dynamic> toJson() => _$WidgetHomeToJson(this);
}

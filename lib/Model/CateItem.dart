import 'package:flutter_app/Model/BaseCate.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CateItem.g.dart';

@JsonSerializable()
class CateItem {
  CateItem(this.data);

  List<BaseCate> data;

  factory CateItem.fromJson(Map<String, dynamic> json) => _$CateItemFromJson(json);

  Map<String, dynamic> toJson() => _$CateItemToJson(this);
}
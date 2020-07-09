import 'package:flutter_app/Model/HomeModelData.dart';
import 'package:json_annotation/json_annotation.dart';

part 'BaseCate.g.dart';

@JsonSerializable()
class BaseCate {
  BaseCate(this.title, this.image,this.bannerList,this.child);

  String title;
  String image;
  @JsonKey(name: 'banner_list')
  List<BaseCate> bannerList;
  List<BaseCate> child;
  bool isSelected = false;
  factory BaseCate.fromJson(Map<String, dynamic> json) => _$BaseCateFromJson(json);

  Map<String, dynamic> toJson() => _$BaseCateToJson(this);
}
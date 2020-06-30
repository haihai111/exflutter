import 'package:equatable/equatable.dart';
import 'package:flutter_app/Model/BaseCate.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CateItem.g.dart';

@JsonSerializable()
class CateItem extends Equatable {
  CateItem(this.data);

  final List<BaseCate> data;

  factory CateItem.fromJson(Map<String, dynamic> json) => _$CateItemFromJson(json);

  Map<String, dynamic> toJson() => _$CateItemToJson(this);

  @override
  List<Object> get props => [data];
}

import 'package:flutter_app/Model/HomeModelItem.dart';
import 'package:json_annotation/json_annotation.dart';

part 'DailySaleData.g.dart';


@JsonSerializable()
class DailySaleData {
  DailySaleData(this.status,this.message,this.data);

  int status;
  String message;
  DailySaleItem data;

  factory DailySaleData.fromJson(Map<String, dynamic> json) =>
      _$DailySaleDataFromJson(json);

  Map<String, dynamic> toJson() => _$DailySaleDataToJson(this);
}

@JsonSerializable()
class DailySaleItem {
  DailySaleItem(this.products,this.waitTime);

  List<HomeModelItem> products;
  @JsonKey(name: 'wait_time')
  int waitTime;

  factory DailySaleItem.fromJson(Map<String, dynamic> json) =>
      _$DailySaleItemFromJson(json);

  Map<String, dynamic> toJson() => _$DailySaleItemToJson(this);
}
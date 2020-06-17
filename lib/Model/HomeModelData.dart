import 'package:json_annotation/json_annotation.dart';
import 'HomeModelItem.dart';

part 'HomeModelData.g.dart';

@JsonSerializable()
class HomeModelData {
  HomeModelData(this.title, this.link, this.homeModelItems,this.endTime);

  String title;
  dynamic link;
  @JsonKey(name: 'list')
  List<HomeModelItem> homeModelItems;
  @JsonKey(name: 'end_time')
  int endTime;

  factory HomeModelData.fromJson(Map<String, dynamic> json) =>
      _$HomeModelDataFromJson(json);

  Map<String, dynamic> toJson() => _$HomeModelDataToJson(this);
}

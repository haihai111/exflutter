// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HomeModelData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeModelData _$HomeModelDataFromJson(Map<String, dynamic> json) {
  return HomeModelData(
    json['title'] as String,
    json['link'] as dynamic,
    (json['list'] as List)
        ?.map((e) => e == null
            ? null
            : HomeModelItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['end_time'] as int,
  );
}

Map<String, dynamic> _$HomeModelDataToJson(HomeModelData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'link': instance.link,
      'list': instance.homeModelItems,
      'end_time': instance.endTime,
    };

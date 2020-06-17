// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WidgetHome.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WidgetHome _$WidgetHomeFromJson(Map<String, dynamic> json) {
  return WidgetHome(
    json['type'] as String,
    json['background_color'] as String,
    json['text_color'] as String,
    json['data'] == null
        ? null
        : HomeModelData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WidgetHomeToJson(WidgetHome instance) =>
    <String, dynamic>{
      'type': instance.type,
      'background_color': instance.bgColor,
      'text_color': instance.textColor,
      'data': instance.data,
    };

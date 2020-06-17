// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BaseCate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseCate _$BaseCateFromJson(Map<String, dynamic> json) {
  return BaseCate(
    json['title'] as String,
    json['image'] as String,
    (json['banner_list'] as List)
        ?.map((e) =>
            e == null ? null : BaseCate.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['child'] as List)
        ?.map((e) =>
            e == null ? null : BaseCate.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BaseCateToJson(BaseCate instance) => <String, dynamic>{
      'title': instance.title,
      'image': instance.image,
      'banner_list': instance.bannerList,
      'child': instance.child
    };

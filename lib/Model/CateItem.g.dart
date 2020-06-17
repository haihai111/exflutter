// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CateItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CateItem _$CateItemFromJson(Map<String, dynamic> json) {
  return CateItem(
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : BaseCate.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CateItemToJson(CateItem instance) =>
    <String, dynamic>{'data': instance.data};

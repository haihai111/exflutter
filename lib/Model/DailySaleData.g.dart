// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DailySaleData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailySaleData _$DailySaleDataFromJson(Map<String, dynamic> json) {
  return DailySaleData(
    json['status'] as int,
    json['message'] as String,
    json['data'] == null
        ? null
        : DailySaleItem.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DailySaleDataToJson(DailySaleData instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

DailySaleItem _$DailySaleItemFromJson(Map<String, dynamic> json) {
  return DailySaleItem(
    (json['products'] as List)
        ?.map((e) => e == null
            ? null
            : HomeModelItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['wait_time'] as int,
  );
}

Map<String, dynamic> _$DailySaleItemToJson(DailySaleItem instance) =>
    <String, dynamic>{
      'products': instance.products,
      'wait_time': instance.waitTime,
    };

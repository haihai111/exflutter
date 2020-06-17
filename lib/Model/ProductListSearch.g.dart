// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductListSearch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductListSearch _$ProductListSearchFromJson(Map<String, dynamic> json) {
  return ProductListSearch(
    (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : ProductListData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ProductListSearchToJson(ProductListSearch instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

ProductListData _$ProductListDataFromJson(Map<String, dynamic> json) {
  return ProductListData(
    json['name'] as String,
    json['original_price'] as String,
    json['min_max_price'] as String,
    json['img_url_mob'] as String,
  );
}

Map<String, dynamic> _$ProductListDataToJson(ProductListData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'img_url_mob': instance.imageUrl,
      'min_max_price': instance.finalPrice,
      'original_price': instance.price,
    };

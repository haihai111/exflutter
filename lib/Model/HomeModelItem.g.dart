// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HomeModelItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeModelItem _$HomeModelItemFromJson(Map<String, dynamic> json) {
  return HomeModelItem(
    json['title'] as String,
    json['background_color'] as String,
    json['url'] as String,
    json['image'] as String,
    (json['ratio_image'] as num)?.toDouble(),
    json['img_url_mob'] as String,
    json['final_price'] as int,
    json['price'] as int,
    json['stock_percent'] as int,
    json['buy_number'] as int,
  );
}

Map<String, dynamic> _$HomeModelItemToJson(HomeModelItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'background_color': instance.backgroundColor,
      'url': instance.url,
      'image': instance.image,
      'ratio_image': instance.ratioImage,
      'img_url_mob': instance.imgUrlMob,
      'final_price': instance.finalPrice,
      'price': instance.price,
      'stock_percent': instance.stockPercent,
      'buy_number': instance.buyBumber,
    };

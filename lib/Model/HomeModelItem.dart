import 'package:json_annotation/json_annotation.dart';

part 'HomeModelItem.g.dart';

@JsonSerializable()
class HomeModelItem {
  HomeModelItem(
      this.title,
      this.backgroundColor,
      this.url,
      this.image,
      this.ratioImage,
      this.imgUrlMob,
      this.finalPrice,
      this.price,
      this.stockPercent,
      this.buyBumber);

  String title;
  @JsonKey(name: 'background_color')
  String backgroundColor;
  String url;
  String image;
  @JsonKey(name: 'ratio_image')
  double ratioImage;
  @JsonKey(name: 'img_url_mob')
  String imgUrlMob;
  @JsonKey(name: 'final_price')
  int finalPrice;
  int price;
  @JsonKey(name: 'stock_percent')
  int stockPercent;
  @JsonKey(name: 'buy_number')
  int buyBumber;

  factory HomeModelItem.fromJson(Map<String, dynamic> json) =>
      _$HomeModelItemFromJson(json);

  Map<String, dynamic> toJson() => _$HomeModelItemToJson(this);
}

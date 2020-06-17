import 'package:json_annotation/json_annotation.dart';

part 'ProductListSearch.g.dart';


@JsonSerializable()
class ProductListSearch {

  ProductListSearch(this.data);

  @JsonKey(name: 'data')
  List<ProductListData> data;

  factory ProductListSearch.fromJson(Map<String, dynamic> json) =>
      _$ProductListSearchFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListSearchToJson(this);
}

@JsonSerializable()
class ProductListData {

  ProductListData(this.name, this.price, this.finalPrice, this.imageUrl);

  String name;
  @JsonKey(name: 'img_url_mob')
  String imageUrl;
  @JsonKey(name: 'min_max_price')
  String finalPrice;
  @JsonKey(name: 'original_price')
  String price;

  factory ProductListData.fromJson(Map<String, dynamic> json) =>
      _$ProductListDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListDataToJson(this);
}

import 'dart:convert';

import 'package:flutter_app/Model/DailySaleData.dart';
import 'package:flutter_app/Model/HomeModelItem.dart';
import 'package:flutter_app/Model/ProductListSearch.dart';
import 'package:flutter_app/Model/WidgetHome.dart';
import 'package:flutter_app/Res/http_utility.dart';

class HomeRepository {
  final httpUtility = HttpUtility();

  Future<List<WidgetHome>> getHome() async {
    final request = Request();
    request.method = Method.GET;
    request.urlEnpoint = "mob/home";

    ResultModel response = await httpUtility.getRequest(request);

    if (response.status == StatusRequest.SUCCESS) {
      //decode json
      Iterable result = json.decode(response.result);
      List<WidgetHome> list = new List();
      list = result.map((i) => WidgetHome.fromJson(i)).toList();
      return list;
    } else {
      return [];
    }
  }

  Future<DailySaleData> getDaily() async {
    final request = Request(baseUrl: "api.sendo.vn");
    request.method = Method.POST;
    request.urlEnpoint = "flash-deal/daily-sale/";
    Map<String, dynamic> output = {};
    output["limit"] = 20;
    output["page"] = 1;
    request.params = output;
    ResultModel response = await httpUtility.postRequest(request);
    if (response.status == StatusRequest.SUCCESS) {
      //decode json
      return DailySaleData.fromJson(json.decode(response.result));
    } else {
      return null;
    }
  }

  Future<ProductListSearch> getListSearchImage(String listProduct) async {
    final request = Request();
    request.method = Method.GET;
    request.urlEnpoint = "/mob_v2/product/1/related/";
    Map<String, String> output = {};
    output["product_relateds"] = listProduct;
    request.params = output;
    ResultModel response = await httpUtility.getRequest(request);
    if (response.status == StatusRequest.SUCCESS) {
      //decode json
      return ProductListSearch.fromJson(json.decode(response.result));
    } else {
      return null;
    }
  }
}

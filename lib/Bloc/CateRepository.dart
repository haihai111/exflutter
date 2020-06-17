import 'dart:convert';

import 'package:flutter_app/Model/CateItem.dart';
import 'package:flutter_app/Model/DailySaleData.dart';
import 'package:flutter_app/Model/HomeModelItem.dart';
import 'package:flutter_app/Model/ProductListSearch.dart';
import 'package:flutter_app/Model/WidgetHome.dart';
import 'package:flutter_app/Res/http_utility.dart';

class CateRepository {
  final httpUtility = HttpUtility();

  Future<CateItem> getCategory() async {
    final request = Request();
    request.method = Method.GET;
    request.urlEnpoint = "/mob/category/all";
    Map<String, String> output = {};
    output["v"] = "1592208458";
    output["event_time"] = "1";
    request.params = output;
    ResultModel response = await httpUtility.getRequest(request);
    if (response.status == StatusRequest.SUCCESS) {
      //decode json
      return CateItem.fromJson(json.decode(response.result));
    } else {
      return null;
    }
  }
}

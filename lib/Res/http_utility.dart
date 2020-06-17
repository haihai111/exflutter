import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

import 'config.dart';

//class DataRequest<T> {
//  Function(T output) onSuccess;
//  Function(dynamic output) onFailure;
//}
//
//class Request {
//  //StartPoint and EndPoint, Param
//  String urlEnpoint;
//
//  Map<String, String> params = Map();
//
//  Method method;
//
//  Request({Key key, this.urlEnpoint, this.method = Method.GET});
//
//  Function(String data) onSuccess;
//
//  Function(dynamic data) onFailure;
//}
//
//enum Method { GET, POST }
//
//class HttpUtility {
//  static final String baseUrl = Config.domain;
//
//  //Create Client
//  final _httpRequest = HttpClient();
//
//  void request(Request request) async {
//    var url = Uri.https(baseUrl, request.urlEnpoint, request.params);
//
//    print('Sang Dep Trai: ${url.toString()}');
//
//    String strMethod = 'GET';
//    if (request.method == Method.GET) {
//      strMethod = 'GET';
//    } else {
//      strMethod = 'POST';
//    }
//
//    _httpRequest.openUrl(strMethod, url).then((requestClient) {
//      var response = requestClient.close();
//
//      response.then((value) async {
//
//        //get header
//        var header = value.headers;
//
//        //save current server time
//        serverTime = header.value('servertime');
//
//        //get body data
//        String strJSONDATA = await value.transform(utf8.decoder).join();
//
//        request.onSuccess(strJSONDATA);
//      }, onError: (e) {
//        request.onFailure(e);
//      });
//    }, onError: (e) {
//      request.onFailure(e);
//    });
//
//    print(url);
//    print(request.params);
//  }
//}

class SendoErrorText {
  static const validateUserName = 'Bạn cần nhập họ tên';
  static const validateEmail = 'Địa chỉ email chưa đúng định dạng';
  static const validatePhone = 'Số điện thoại là số gồm 10 chữ số';
  static const validateAddress = 'Địa chỉ cần có 5 đến 250 ký tự';
  static const connectServerError =
      'Kết nối hệ thống thất bại, vui lòng thử lại';
  static const formatError = 'Định dạng dữ liệu sai';
  static const serverError = 'Có lỗi xảy ra, vui lòng thử lại';
  static const validateWard = 'Chưa chọn phường/xã';
  static const validateRegion = 'Chưa chọn Tỉnh thành/Quận huyện';
}

class Request {
  String baseUrl;

  //StartPoint and EndPoint, Param
  String urlEnpoint;

  ///
  ///Param POST, GET
  ///[params] POST is Map<dynamic, dynamic>
  ///[params] GET is Map<String, String>
  ///
  dynamic params;

  Method method;

  Request({
    Key key,
    this.urlEnpoint,
    this.method = Method.GET,
    this.baseUrl = Config.domain,
  });

  Uri uri() {
    dynamic _temp;
    if (method == Method.POST ||
        method == Method.PUT ||
        method == Method.DELETE) {
      _temp = null; //params as Map<dynamic, dynamic>;
    } else {
      _temp = params as Map<String, dynamic>;
    }
    if (baseUrl.contains('test') || baseUrl.contains('pilot')) {
      print('${Uri.http(baseUrl, urlEnpoint, _temp)}');
      return Uri.http(baseUrl, urlEnpoint, _temp);
    } else {
      print('${Uri.https(baseUrl, urlEnpoint, _temp)}');
      return Uri.https(baseUrl, urlEnpoint, _temp);
    }
  }
}

enum StatusRequest { SUCCESS, FAILURE, TIMEOUT }
enum Method { GET, POST, PUT, DELETE }

class ResultModel {
  String result;
  String message = '';
  String statusCode = '';
  StatusRequest status;

  ResultModel(this.status, this.message);
}

class HttpUtility {
  static final String baseUrl = Config.domain;
  Duration _timeOut = const Duration(seconds: 30);

  //Create Client
  final _httpClient = new HttpClient();

  _setHeaders(HttpHeaders headers) {
//    if (core.Shared.currentUser.accessToken.length > 0) {
//      headers.set('Authorization', core.Shared.currentUser.accessToken);
//    }
    headers.set('Content-Type', 'application/json');
  }

  void _setCookies(HttpClientRequest request) {
//    if (core.Shared.currentCheckoutInfo.affiliate != '') {
//      final affiliate = core.Shared.currentCheckoutInfo.affiliate;
//      print('affiliate =====>$affiliate');
//      final cookie = Cookie.fromSetCookieValue(affiliate);
//      request.cookies.add(cookie);
//    }
  }

  Future<ResultModel> getRequest(Request _request) async {
    var uri = _request.uri();
    //init resultModel data default status "failure", message ""
    ResultModel resultModel = ResultModel(StatusRequest.FAILURE, '');

    try {
      var request = await _httpClient.getUrl(uri);
      _setHeaders(request.headers);

      print("URL REQUEST =============================>");
      print(_request.uri());
      print(_request.params);
      print(_request.method);
      print("<<======================================>>");

      var response = await request.close().timeout(_timeOut);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await response.transform(utf8.decoder).join().then((data) {
          resultModel.status = StatusRequest.SUCCESS;
          resultModel.result = data;
        });
      } else {
        resultModel.message = SendoErrorText.connectServerError;
//        TrackingManager.server.requestFailure('get', _request.uri().toString());
      }

      return resultModel;
    } on TimeoutException catch (_) {
      //Timeout
      resultModel.status = StatusRequest.TIMEOUT;
      resultModel.message = SendoErrorText.connectServerError;
//      TrackingManager.server.timeout('get', _request.uri().toString());
    } catch (error) {
      resultModel.message = SendoErrorText.connectServerError;
//      TrackingManager.server.otherFailure('get', _request.uri().toString());
    }
    return resultModel;
  }

  Future<ResultModel> postRequest(Request _request) async {
    var uri = _request.uri();
    //init resultModel data default status "failure", message ""
    ResultModel resultModel = ResultModel(StatusRequest.FAILURE, '');

    try {
      var request = await _httpClient.postUrl(uri);
      _setHeaders(request.headers);
      _setCookies(request);
      request.add(utf8.encode(json.encode(_request.params)));

      print("URL REQUEST =============================>");
      print(_request.uri());
      print(_request.params);
      print(_request.method);
      print(request.cookies);
      print("<<======================================>>");

      var response = await request.close().timeout(_timeOut);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        //success
        await response.transform(utf8.decoder).join().then((data) {
          resultModel.status = StatusRequest.SUCCESS;
          resultModel.result = data;
        });
      } else {
        //failure
        resultModel.message = SendoErrorText.connectServerError;
//        TrackingManager.server.requestFailure('post', _request.uri().toString());
      }
    } on TimeoutException catch (_) {
      //Timeout
      resultModel.status = StatusRequest.TIMEOUT;
      resultModel.message = SendoErrorText.connectServerError;
//      TrackingManager.server.timeout('post', _request.uri().toString());
    } catch (error) {
      //ERROR OTHER
      resultModel.message = SendoErrorText.connectServerError;
//      TrackingManager.server.otherFailure('post', _request.uri().toString());
    }
    return resultModel;
  }

  Future<ResultModel> putRequest(Request _request) async {
    var uri = _request.uri();
    //init resultModel data default status "failure", message ""
    ResultModel resultModel = ResultModel(StatusRequest.FAILURE, '');

    try {
      var request = await _httpClient.putUrl(uri);
      _setHeaders(request.headers);
      request.add(utf8.encode(json.encode(_request.params)));

      print("URL REQUEST =============================>");
      print(_request.uri());
      print(_request.params);
      print(_request.method);
      print("<<======================================>>");

      var response = await request.close().timeout(_timeOut);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await response.transform(utf8.decoder).join().then((data) {
          resultModel.status = StatusRequest.SUCCESS;
          resultModel.result = data;
        });
      } else {
        resultModel.message = SendoErrorText.connectServerError;
//        TrackingManager.server.requestFailure('put', _request.uri().toString());
      }

      return resultModel;
    } on TimeoutException catch (_) {
      //Timeout
      resultModel.status = StatusRequest.TIMEOUT;
      resultModel.message = SendoErrorText.connectServerError;
//      TrackingManager.server.timeout('put', _request.uri().toString());
    } catch (error) {
      resultModel.message = SendoErrorText.connectServerError;
//      TrackingManager.server.otherFailure('put', _request.uri().toString());
    }
    return resultModel;
  }

  Future<ResultModel> deleteRequest(Request _request) async {
    var uri = _request.uri();
    //init resultModel data default status "failure", message ""
    ResultModel resultModel = ResultModel(StatusRequest.FAILURE, '');

    try {
      var request = await _httpClient.deleteUrl(uri);
      _setHeaders(request.headers);

      print("URL REQUEST =============================>");
      print(_request.uri());
      print(_request.params);
      print(_request.method);
      print("<<======================================>>");

      var response = await request.close().timeout(_timeOut);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await response.transform(utf8.decoder).join().then((data) {
          resultModel.status = StatusRequest.SUCCESS;
          resultModel.result = data;
        });
      } else {
        resultModel.message = SendoErrorText.connectServerError;
//        TrackingManager.server.requestFailure('delete', _request.uri().toString());
      }

      return resultModel;
    } on TimeoutException catch (_) {
      //Timeout
      resultModel.status = StatusRequest.TIMEOUT;
      resultModel.message = SendoErrorText.connectServerError;
//      TrackingManager.server.timeout('delete', _request.uri().toString());
    } catch (error) {
      resultModel.message = SendoErrorText.connectServerError;
//      TrackingManager.server.otherFailure('delete', _request.uri().toString());
    }
    return resultModel;
  }
}

import 'package:flutter/services.dart';

class Config {
  static const String domain = "mapi.sendo.vn";

  static const checkoutChannel = const MethodChannel('com.sendo.flutter.io/channel/checkout');

  static const platformChannel = const MethodChannel('com.sendo.flutter.io/channel/main');

  static const eventChannel = EventChannel('com.sendo.flutter.io/event');

}

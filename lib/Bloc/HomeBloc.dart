import 'dart:async';

import 'package:flutter_app/Bloc/bloc_provider.dart';
import 'package:flutter_app/Model/DailySaleData.dart';
import 'package:flutter_app/Model/HomeModelItem.dart';
import 'package:flutter_app/Model/ProductListSearch.dart';
import 'package:flutter_app/Model/WidgetHome.dart';
import 'package:rxdart/rxdart.dart';

import 'HomeRepository.dart';

class HomeBloc extends BlocBase {
  final _homeRepository = HomeRepository();

  final _homeController = BehaviorSubject<List<WidgetHome>>();

  final _dailyController = BehaviorSubject<DailySaleData>();

  final _listImageSearchController = BehaviorSubject<ProductListSearch>();

  Stream<List<WidgetHome>> get homeStream => _homeController.stream;

  Stream<DailySaleData> get dailyStream => _dailyController.stream;

  Stream<ProductListSearch> get imageSearchStream => _listImageSearchController.stream;

  getListImageSearch(String listProduct) async {
    ProductListSearch widgets = await _homeRepository.getListSearchImage(listProduct);
    _listImageSearchController.sink.add(widgets);
  }

  getDaily() async {
    DailySaleData widgets = await _homeRepository.getDaily();
    _dailyController.sink.add(widgets);
  }

  getHome() async {
    List<WidgetHome> widgets = await _homeRepository.getHome();
    _homeController.sink.add(widgets);
  }

  @override
  void dispose() {
    _homeController.close();
    _dailyController.close();
  }
}

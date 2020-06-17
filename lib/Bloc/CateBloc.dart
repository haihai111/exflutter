import 'dart:async';

import 'package:flutter_app/Bloc/bloc_provider.dart';
import 'package:flutter_app/Model/CateItem.dart';
import 'package:rxdart/rxdart.dart';

import 'CateRepository.dart';

class CateBloc extends BlocBase {
  final _cateRepository = CateRepository();

  final _cateController = BehaviorSubject<CateItem>();

  Stream<CateItem> get cateStream => _cateController.stream;


  getCate() async {
    CateItem cateItem = await _cateRepository.getCategory();
    _cateController.sink.add(cateItem);
  }

  @override
  void dispose() {
    _cateController.close();
  }
}

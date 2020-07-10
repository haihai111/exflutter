import 'package:flutter/cupertino.dart';

import 'BaseCate.dart';

class AllCateItemModel with ChangeNotifier {
  final List<BaseCate> allCate;

  AllCateItemModel({this.allCate});

  void changeAllCate(int _index) {
    allCate
        .asMap()
        .forEach((index, cate) => {cate.isSelected = _index == index});
    notifyListeners();
  }
}

class CateItemModel with ChangeNotifier {
  BaseCate cateItemLv1;

  CateItemModel({this.cateItemLv1});

  void changeAllCate(BaseCate cateItemLv1) {
    this.cateItemLv1 = cateItemLv1;
    notifyListeners();
  }
}

class CateGuidance with ChangeNotifier {
  bool isGuidance = true;

  void changeIsGuidance(bool isGuidance) {
    this.isGuidance = isGuidance;
    notifyListeners();
  }
}

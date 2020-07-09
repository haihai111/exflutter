import 'package:equatable/equatable.dart';
import 'package:flutter_app/Model/BaseCate.dart';
import 'package:flutter_app/Model/CateItem.dart';

abstract class CateItemState extends Equatable {
  const CateItemState();

  @override
  List<Object> get props => [];
}

class CateItemInitial extends CateItemState {}

class CateItemFailure extends CateItemState {}

class CateItemSuccess extends CateItemState {
  final CateItem cateItem;

  const CateItemSuccess({
    this.cateItem,
  });

  @override
  List<Object> get props => [cateItem];
}

class CateItem1Success extends CateItemState {
  final BaseCate cateItemLv1;
  final List<BaseCate> allCate;

  const CateItem1Success({
    this.cateItemLv1,
    this.allCate,
  });

  @override
  List<Object> get props => [cateItemLv1];
}

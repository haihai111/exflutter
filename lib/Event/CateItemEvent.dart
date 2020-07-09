import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class CateItemEvent extends Equatable {
  const CateItemEvent();

  @override
  List<Object> get props => [];
}

class CateItemFetched extends CateItemEvent {}

class CateItemChange extends CateItemEvent {
  final int index;

  const CateItemChange({
    @required this.index,
  });

  @override
  List<Object> get props => [index];
}

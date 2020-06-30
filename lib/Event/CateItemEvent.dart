import 'package:equatable/equatable.dart';

abstract class CateItemEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CateItemFetched extends CateItemEvent {}


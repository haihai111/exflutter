import 'dart:async';

import 'package:flutter_app/Event/CateItemEvent.dart';
import 'package:flutter_app/Model/BaseCate.dart';
import 'package:flutter_app/Model/CateItem.dart';
import 'package:flutter_app/State/CateItemState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'CateRepository.dart';

class CateBloc extends Bloc<CateItemEvent, CateItemState> {
  final _cateRepository = CateRepository();

  Future<CateItem> getCate() async {
    CateItem cateItem = await _cateRepository.getCategory();
    return cateItem;
  }

  @override
  Stream<Transition<CateItemEvent, CateItemState>> transformEvents(
    Stream<CateItemEvent> events,
    TransitionFunction<CateItemEvent, CateItemState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  CateItemState get initialState => CateItemInitial();

  @override
  Stream<CateItemState> mapEventToState(CateItemEvent event) async* {
    final currentState = state;
    if (event is CateItemFetched) {
      try {
        if (currentState is CateItemInitial) {
          final cateItem = await getCate();
          yield CateItemSuccess(cateItem: cateItem);
          return;
        }
      } catch (_) {
        yield CateItemFailure();
      }
    }
  }
}

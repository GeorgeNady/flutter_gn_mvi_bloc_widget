import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../core/base_event.dart';
import '../core/base_side_effect.dart';
import '../core/base_state.dart';

export '../core/base_event.dart';
export '../core/base_side_effect.dart';
export '../core/base_state.dart';

abstract class BaseBloc<E extends BaseEvent, SE extends BaseSideEffect,
    S extends BaseState> extends Bloc<E, S> {
  final _sideEffectController = StreamController<SE>.broadcast();

  Stream<SE> get sideEffects => _sideEffectController.stream;

  BaseBloc(super.initialState);

  @protected
  void emitSideEffect(SE effect) {
    _sideEffectController.add(effect);
  }

  @override
  Future<void> close() {
    _sideEffectController.close();
    return super.close();
  }
}

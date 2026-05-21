import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class BaseEvent {}

abstract class BaseSideEffect {}

abstract class BaseState extends Equatable {
  const BaseState();
}

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

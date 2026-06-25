import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/base_bloc.dart';
import '../core/base_event.dart';
import '../core/base_side_effect.dart';
import '../core/base_state.dart';

extension BaseBlocX<B extends BaseBloc<BaseEvent, BaseSideEffect, S>,
    S extends BaseState> on B {
  /// Watches this bloc's state reactively within a build method.
  ///
  /// Instead of `context.watch<MyBloc>().state`, you can use `bloc.watchState(context)`.
  /// This provides better type inference for the state.
  S watchState(BuildContext context) => context.watch<B>().state;

  /// Selects a specific value from the bloc's state reactively.
  ///
  /// This is a shorthand for `context.select<MyBloc, T>((bloc) => selector(bloc.state))`.
  /// It helps in minimizing rebuilds by only listening to specific changes.
  T selectState<T>(BuildContext context, T Function(S state) selector) =>
      context.select<B, T>((bloc) => selector(bloc.state));
}

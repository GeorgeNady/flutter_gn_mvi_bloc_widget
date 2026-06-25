import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/base_bloc.dart';
import '../core/base_event.dart';
import '../core/base_side_effect.dart';
import '../core/base_state.dart';

extension BaseBlocBuildContextX on BuildContext {
  /// Shorthand for context.read<B>() to get the Bloc instance.
  B readBloc<B extends BaseBloc<BaseEvent, BaseSideEffect, BaseState>>() =>
      read<B>();

  /// Shorthand for context.watch<B>() to get the Bloc instance.
  B watchBloc<B extends BaseBloc<BaseEvent, BaseSideEffect, BaseState>>() =>
      watch<B>();
}

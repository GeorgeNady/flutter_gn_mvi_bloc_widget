import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/base_bloc.dart';

abstract class StatelessBlocWidget<
        B extends BaseBloc<BaseEvent, BaseSideEffect, BaseState>>
    extends StatelessWidget {
  const StatelessBlocWidget({super.key});

  Widget buildWithBloc(BuildContext context, B bloc);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<B>(context);
    return buildWithBloc(context, bloc);
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/base_bloc.dart';

abstract class StatefulBlocWidget<
    B extends BaseBloc<BaseEvent, SE, BaseState>,
    SE extends BaseSideEffect> extends StatefulWidget {
  const StatefulBlocWidget({super.key});

  /// UI builder with bloc
  Widget buildWithBloc(BuildContext context, B bloc);

  /// Called once in initState()
  void onInit(B bloc) {}

  /// Called once after the first frame
  void onPostFrame(B bloc) {}

  /// App comes from background (Activity onResume)
  void onResume(B bloc) {}

  /// Called when user navigates back to this page (Fragment onResume)
  void onPageResumed(B bloc) {}

  /// Called once system back triggered
  void onPopInvokedWithResult(bool didPop, Object? result) {}

  /// 🔑 INTERNAL: determines if back handling is overridden
  bool get handlePop => false;

  /// Called for **each emitted side effect**
  void onSideEffects(BuildContext context, SE sideEffect) {}

  /// Optional RouteObserver to subscribe to navigation lifecycle
  RouteObserver<PageRoute<dynamic>>? get routeObserver => null;

  @override
  BaseBlocState<B, BaseEvent, SE, BaseState> createState() =>
      BaseBlocState<B, BaseEvent, SE, BaseState>();
}

class BaseBlocState<
    B extends BaseBloc<E, SE, S>,
    E extends BaseEvent,
    SE extends BaseSideEffect,
    S extends BaseState> extends State<StatefulBlocWidget<B, SE>>
    with WidgetsBindingObserver, RouteAware {
  late final B bloc;
  late final StreamSubscription<SE> _sideEffectsSub;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<B>(context);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onInit(bloc);
      widget.onPostFrame(bloc);
      _listenSideEffects();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.onResume(bloc);
    }
  }

  /// subscribe to navigation lifecycle
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final observer = widget.routeObserver;
    if (observer != null) {
      final route = ModalRoute.of(context);
      if (route is PageRoute) {
        observer.subscribe(this, route);
      }
    }
  }

  /// 🔥 Navigation resume (Fragment onResume)
  @override
  void didPopNext() {
    widget.onPageResumed(bloc);
  }

  void _listenSideEffects() {
    _sideEffectsSub = bloc.sideEffects.listen((SE sideEffect) {
      if (!mounted) return; // ✅ guard async gap
      widget.onSideEffects(context, sideEffect);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.handlePop, // disables back gesture or Prevents automatic popping
      onPopInvokedWithResult: widget.handlePop ? widget.onPopInvokedWithResult : null,
      child: widget.buildWithBloc(context, bloc),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.routeObserver?.unsubscribe(this);
    _sideEffectsSub.cancel();
    super.dispose();
  }
}

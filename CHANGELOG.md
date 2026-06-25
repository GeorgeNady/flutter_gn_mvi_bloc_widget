## 1.1.0

* **Refactoring & SOLID Principles**:
  * Project structure reorganized to follow Clean Architecture principles.
  * Split core components (`BaseEvent`, `BaseSideEffect`, `BaseState`) into `src/core/`.
  * Moved BLoC implementation to `src/bloc/`.
  * Moved widgets to `src/widgets/`.
  * Moved extensions to `src/extensions/`.
* **Enhanced Extensions**:
  * Added `BaseBloc` extensions: `bloc.watchState(context)` and `bloc.selectState(context, selector)` for better type inference.
  * Added `BuildContext` extensions: `context.readBloc<B>()` and `context.watchBloc<B>()`.
  * Decoupled state watching from `BuildContext` to prevent accidental misuse.

## 1.0.0

* Initial release of `flutter_gn_mvi_bloc_widget`.
* Support for MVI-like pattern with `BaseBloc` and Side Effects.
* `StatelessBlocWidget` for easy BLoC access in stateless widgets.
* `StatefulBlocWidget` with extended lifecycle hooks:
  * `onInit`, `onPostFrame`, `onResume`, `onPageResumed`.
  * Dedicated `onSideEffects` listener.
  * Built-in `PopScope` integration with `onPopInvokedWithResult`.

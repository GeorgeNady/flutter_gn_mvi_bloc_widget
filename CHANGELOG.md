## 1.0.0

* Initial release of `flutter_gn_mvi_bloc_widget`.
* Added `BaseBloc` with support for Side Effects (MVI-like pattern).
* Added `StatelessBlocWidget` for easy access to BLoCs in stateless widgets.
* Added `StatefulBlocWidget` with extended lifecycle hooks:
  * `onInit`: Called during initialization.
  * `onPostFrame`: Called after the first frame.
  * `onResume`: Triggered when the app returns to the foreground.
  * `onPageResumed`: Triggered when navigating back to the widget.
  * `onSideEffects`: Dedicated stream listener for BLoC side effects.
  * `onPopInvokedWithResult`: Built-in back navigation handling using `PopScope`.

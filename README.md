# flutter_gn_mvi_bloc_widget

A lightweight, boilerplate-reducing Flutter library for implementing the **MVI (Model-View-Intent)** pattern using **BLoC**. It provides base classes for BLoCs with side-effect support and specialized widgets that simplify lifecycle management and BLoC integration.

## Features

- **BaseBloc**: A base class for BLoCs that handles States, Events, and **Side Effects** (single-shot events like navigation, toasts, or dialogs).
- **StatelessBlocWidget**: Simplifies using BLoCs in stateless widgets.
- **StatefulBlocWidget**: A powerful base for stateful widgets that automatically handles:
    - Side-effect listening.
    - `onInit` and `onPostFrame` callbacks.
    - App lifecycle states (e.g., `onResume`).
    - Navigation lifecycle (with `RouteObserver`).
    - Back button/Pop handling with `PopScope`.

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_gn_mvi_bloc_widget:
    git:
      url: https://github.com/GeorgeNady/flutter_gn_mvi_bloc_widget.git
```

## Usage

### 1. Define your BLoC Components

```dart
// Events
abstract class HomeEvent extends BaseEvent {}
class LoadData extends HomeEvent {}

// States
abstract class HomeState extends BaseState {}
class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

// Side Effects
abstract class HomeSideEffect extends BaseSideEffect {}
class ShowToast extends HomeSideEffect {
  final String message;
  ShowToast(this.message);
}

// BLoC
class HomeBloc extends BaseBloc<HomeEvent, HomeSideEffect, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadData>((event, emit) {
      // Logic here
      emitSideEffect(ShowToast("Data Loaded!"));
    });
  }
}
```

### 2. Create a Stateful BLoC Widget

`StatefulBlocWidget` manages the subscription to side effects and provides lifecycle hooks.

```dart
class HomePage extends StatefulBlocWidget<HomeBloc, HomeSideEffect> {
  const HomePage({super.key});

  @override
  void onInit(HomeBloc bloc) {
    bloc.add(LoadData());
  }

  @override
  void onSideEffects(BuildContext context, HomeSideEffect sideEffect) {
    if (sideEffect is ShowToast) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(sideEffect.message)),
      );
    }
  }

  @override
  Widget buildWithBloc(BuildContext context, HomeBloc bloc) {
    return Scaffold(
      app_bar: AppBar(title: const Text('MVI BLoC Widget')),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Center(child: Text('State: $state'));
        },
      ),
    );
  }
}
```

### 3. Create a Stateless BLoC Widget

For simpler views that don't need lifecycle hooks or side-effect listening.

```dart
class SimpleView extends StatelessBlocWidget<HomeBloc> {
  const SimpleView({super.key});

  @override
  Widget buildWithBloc(BuildContext context, HomeBloc bloc) {
    return ElevatedButton(
      onPressed: () => bloc.add(LoadData()),
      child: const Text('Load'),
    );
  }
}
```

## Advanced Lifecycle & Navigation

`StatefulBlocWidget` can also listen to navigation events (like when returning to a page) by providing a `RouteObserver`.

```dart
@override
RouteObserver<PageRoute<dynamic>>? get routeObserver => myRouteObserver;

@override
void onPageResumed(HomeBloc bloc) {
  // Called when this page becomes visible again after popping a top route
}
```

## Author

**George Nady**
GitHub: [@GeorgeNady](https://github.com/GeorgeNady)

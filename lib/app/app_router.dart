import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lotspot/bloc/app_state_bloc.dart';
import 'package:lotspot/features/home/home_page.dart';
import 'package:lotspot/features/login/login_page.dart';
import 'package:lotspot/features/splash/view/splash_screen.dart';

class AppRouter {
  final BuildContext appContext;

  late final AppStateBloc _appStateBloc;
  GoRouter get router => _goRouter;

  AppRouter(this.appContext) {
    _appStateBloc = appContext.read<AppStateBloc>();
  }

  late final GoRouter _goRouter = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        )
      ],
      redirect: (context, state) {
        final appState = _appStateBloc.state;
        final matchedLocation = state.matchedLocation;

        print(appState);

        final bool isOnSplashScreen = matchedLocation == '/splash';
        final bool isOnLoginPage = matchedLocation == '/login';

        if (appState is AppStateLoading) return '/splash';
        if (appState is AppStateInitial) return '/login';

        if (isOnSplashScreen || isOnLoginPage) return '/';

        return null;
      },
      refreshListenable: _appStateBloc);
}

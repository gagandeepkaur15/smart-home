import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/bloc/auth/auth_bloc.dart';
import 'package:smart_home/bloc/auth/auth_state.dart';
import 'package:smart_home/screens/ble.dart';
import 'package:smart_home/screens/dashboard.dart';
import 'package:smart_home/screens/login.dart';
import 'package:smart_home/screens/signup.dart';

GoRouter router(AuthenticationBloc authBloc) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      if (state.uri.toString() != '/sign-up') {
        if (authState is AuthenticationFailureState ||
            authState is AuthenticationInitialState) {
          return '/';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, authState) {
              if (authState is AuthenticationSuccessState) {
                return const DashboardScreen();
              } else {
                return LoginScreen();
              }
            },
          );
        },
      ),
      GoRoute(
        path: '/dashboard',
        builder: (BuildContext context, GoRouterState state) {
          return const DashboardScreen();
        },
      ),
      GoRoute(
        path: '/ble-scan',
        builder: (BuildContext context, GoRouterState state) {
          return const BLEScanScreen();
        },
      ),
      GoRoute(
        path: '/sign-up',
        builder: (BuildContext context, GoRouterState state) {
          return SignUpScreen();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return LoginScreen();
        },
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    stream.listen((_) {
      notifyListeners();
    });
  }
}

import 'package:smart_home/models/user.dart';

abstract class AuthenticationState {}

class AuthenticationInitialState extends AuthenticationState {}

class AuthenticationLoadingState extends AuthenticationState {
  final bool isLoading;

  AuthenticationLoadingState({required this.isLoading});
}

class AuthenticationSuccessState extends AuthenticationState {
  final UserModel user;

  AuthenticationSuccessState(this.user);
}

class AuthenticationFailureState extends AuthenticationState {
  final String message;

  AuthenticationFailureState(this.message);
}

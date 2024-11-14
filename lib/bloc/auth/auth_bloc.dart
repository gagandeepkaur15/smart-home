import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/bloc/auth/auth_event.dart';
import 'package:smart_home/bloc/auth/auth_state.dart';
import 'package:smart_home/models/user.dart';
import 'package:smart_home/services/auth.dart';

class AuthenticationBloc extends Bloc<AuthEvent, AuthenticationState> {
  final AuthService authService = AuthService();

  AuthenticationBloc() : super(AuthenticationInitialState()) {
    on<AuthSignUp>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        final UserModel? user =
            await authService.signUpUser(event.email, event.password, event.displayName);
        if (user != null) {
          emit(AuthenticationSuccessState(user));
        }else {
          emit( AuthenticationFailureState('User creation failed'));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(AuthenticationFailureState(e.toString()));
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<AuthLogin>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        final UserModel? user =
            await authService.signInUser(event.email, event.password);
        if (user != null) {
          emit(AuthenticationSuccessState(user));
        } else {
          emit( AuthenticationFailureState('Invalid credentials'));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(AuthenticationFailureState('Login failed: ${e.toString()}'));
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<AuthLogout>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        await authService.signOutUser();
        emit(AuthenticationInitialState()); 
      } catch (e) {
        debugPrint('SignOut Error: ${e.toString()}');
        emit(AuthenticationFailureState('Sign out failed'));
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });
  }
  }
  

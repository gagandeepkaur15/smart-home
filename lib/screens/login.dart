import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/bloc/auth/auth_bloc.dart';
import 'package:smart_home/bloc/auth/auth_event.dart';
import 'package:smart_home/bloc/auth/auth_state.dart';
import 'package:smart_home/screens/signup.dart';
import 'package:smart_home/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Login',
          style: context.theme.textTheme.titleMedium,
        ),
        backgroundColor: context.theme.primaryColor,
      ),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Welcome ${state.user.displayName}'),
            ));
          } else if (state is AuthenticationFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          }
        },
        builder: (context, state) {
          if (state is AuthenticationLoadingState && state.isLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: context.theme.primaryColor,
            ));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SmartHome",
                  style: context.theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: context.theme.textTheme.labelSmall,
                  ),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: context.theme.textTheme.labelSmall,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;
                    context.read<AuthenticationBloc>().add(
                          AuthLogin(email, password),
                        );
                  },
                  child: const Text('Log In'),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have account?",
                      style: context.theme.textTheme.displaySmall,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                      },
                      child: Text(
                        " SignUp",
                        style: context.theme.textTheme.displaySmall!.copyWith(
                          color: context.theme.primaryColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     context.read<AuthenticationBloc>().add(AuthLogout());
                //   },
                //   child: const Text('Sign Out'),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}

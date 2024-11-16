import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/bloc/auth/auth_bloc.dart';
import 'package:smart_home/bloc/auth/auth_event.dart';
import 'package:smart_home/bloc/auth/auth_state.dart';
import 'package:smart_home/theme/app_theme.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Sign Up',
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "SmartHome",
                    style: context.theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: context.theme.textTheme.labelSmall,
                    ),
                  ),
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
                      final name = nameController.text;
                      final email = emailController.text;
                      final password = passwordController.text;
                      context.read<AuthenticationBloc>().add(
                            AuthSignUp(email, password, name),
                          );
                    },
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have account?",
                        style: context.theme.textTheme.displaySmall,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/login');
                        },
                        child: Text(
                          " Login",
                          style: context.theme.textTheme.displaySmall!.copyWith(
                            color: context.theme.primaryColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

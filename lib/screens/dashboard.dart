import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/bloc/auth/auth_bloc.dart';
import 'package:smart_home/bloc/auth/auth_event.dart';
import 'package:smart_home/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.primaryColor,
        title: Row(
          children: [
            Text(
              "Dashboard",
              style: context.theme.textTheme.titleMedium,
            ),
            const Spacer(),
            IconButton(
              onPressed: () async {
                BlocProvider.of<AuthenticationBloc>(context).add(AuthLogout());
                context.go('/');
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

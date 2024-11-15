// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/bloc/auth/auth_bloc.dart';
import 'package:smart_home/bloc/auth/auth_event.dart';
import 'package:smart_home/bloc/ble/ble_bloc.dart';
import 'package:smart_home/bloc/ble/ble_state.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.push('/ble-scan');
              },
              child: const Text("Ble Scan"),
            ),
            BlocBuilder<BLEBloc, BLEState>(
              builder: (context, state) {
                if (state is BLEDeviceConnectedState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "Connected Device: ",
                            style: context.theme.textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            state.device.name,
                            style: context.theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Data: ",
                            style: context.theme.textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            state.data,
                            style: context.theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  );
                } else if (state is BLEDeviceErrorState) {
                  return Center(child: Text("Error: ${state.message}"));
                } else {
                  return const Center(child: Text("No device connected"));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

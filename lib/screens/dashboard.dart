// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/bloc/auth/auth_bloc.dart';
import 'package:smart_home/bloc/auth/auth_event.dart';
import 'package:smart_home/bloc/ble/ble_bloc.dart';
import 'package:smart_home/bloc/ble/ble_state.dart';
import 'package:smart_home/bloc/mqtt/mqtt_bloc.dart';
import 'package:smart_home/bloc/mqtt/mqtt_event.dart';
import 'package:smart_home/bloc/mqtt/mqtt_state.dart';
import 'package:smart_home/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mqttBloc = BlocProvider.of<MQTTBloc>(context);
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Text(
                "BLE Services",
                style: context.theme.textTheme.bodyLarge!.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.push('/ble-scan');
              },
              child: const Text("Ble Scan"),
            ),
            const SizedBox(height: 10),
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
                  return const Text("No device connected");
                }
              },
            ),
            const SizedBox(height: 50),
            Center(
              child: Text(
                "MQTT Services",
                style: context.theme.textTheme.bodyLarge!.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    mqttBloc.add(MQTTConnectEvent());
                  },
                  child: const Text('Connect'),
                ),
                ElevatedButton(
                  onPressed: () {
                    mqttBloc.add(MQTTSubscribeEvent('home/sensor/temperature'));
                  },
                  child: const Text('Subscribe'),
                ),
                ElevatedButton(
                  onPressed: () {
                    mqttBloc.add(
                        MQTTPublishEvent('home/control/device', 'Turn on'));
                  },
                  child: const Text('Publish'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<MQTTBloc, MQTTState>(
                builder: (context, state) {
                  if (state is MQTTConnectingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MQTTConnectedState) {
                    return const Center(
                        child: Text('Connected to MQTT broker.'));
                  } else if (state is MQTTSubscribedState) {
                    return Center(child: Text('Subscribed to ${state.topic}.'));
                  } else if (state is MQTTMessagePublishedState) {
                    return Center(
                        child: Text('Message published: ${state.message}'));
                  } else if (state is MQTTMessageReceivedState) {
                    return ListView.builder(
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.messages[index]),
                        );
                      },
                    );
                  } else if (state is MQTTErrorState) {
                    return Text('Error: ${state.error}');
                  }
                  return const Text('Press a button to interact with MQTT.');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

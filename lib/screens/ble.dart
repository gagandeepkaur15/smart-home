// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/bloc/ble/ble_bloc.dart';
import 'package:smart_home/bloc/ble/ble_event.dart';
import 'package:smart_home/bloc/ble/ble_state.dart';
import 'package:smart_home/theme/app_theme.dart';

class BLEScanScreen extends StatefulWidget {
  const BLEScanScreen({super.key});

  @override
  State<BLEScanScreen> createState() => _BLEScanScreenState();
}

class _BLEScanScreenState extends State<BLEScanScreen> {
  @override
  void initState() {
    super.initState();

    final bleBloc = BlocProvider.of<BLEBloc>(context, listen: false);
    bleBloc.add(BLEInitialLoad());
  }

  @override
  Widget build(BuildContext context) {
    final bleBloc = BlocProvider.of<BLEBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'BLE Devices',
          style: context.theme.textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                bleBloc.add(BLEScanStart());
              },
              child: const Text('Start Scanning'),
            ),
            Expanded(
              child: BlocBuilder<BLEBloc, BLEState>(
                builder: (context, state) {
                  List devices = [];
                  String? connectedDeviceName;
                  String? connectedDeviceId;
                  if (state is BLECachedDevicesState) {
                    return ListView.builder(
                      itemCount: state.devices.length,
                      itemBuilder: (context, index) {
                        final device = state.devices[index];
                        return Column(
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              "Cached Devices",
                              style:
                                  context.theme.textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                device.name.isNotEmpty
                                    ? device.name
                                    : "Unknown Device",
                                style: context.theme.textTheme.bodyMedium,
                              ),
                              subtitle: Text(
                                device.id,
                                style: context.theme.textTheme.bodySmall,
                              ),
                              onTap: () {},
                            ),
                          ],
                        );
                      },
                    );
                  } else if (state is BLEScanCompleteState) {
                    devices = state.devices;
                  } else if (state is BLEDeviceConnectedState) {
                    connectedDeviceName = state.device.name.isNotEmpty
                        ? state.device.name
                        : "Unknown Device";
                    connectedDeviceId = state.device.id.toString();
                  } else if (state is BLEScanInProgressState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BLEDeviceErrorState) {
                    return Center(child: Text(state.message));
                  }

                  return Column(
                    children: [
                      if (connectedDeviceName != null &&
                          connectedDeviceId != null)
                        Card(
                          color: Colors.green.shade50,
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(
                                  "Connected to: ",
                                  style: context.theme.textTheme.bodySmall!
                                      .copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  connectedDeviceName,
                                  style: context.theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  "ID: ",
                                  style: context.theme.textTheme.bodySmall!
                                      .copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  connectedDeviceId,
                                  style: context.theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: devices.length,
                          itemBuilder: (context, index) {
                            final device = devices[index];
                            return ListTile(
                              title: Text(
                                device.name.isEmpty
                                    ? "Unknown Device"
                                    : device.name,
                                style: context.theme.textTheme.bodyMedium,
                              ),
                              subtitle: Text(
                                device.id.toString(),
                                style: context.theme.textTheme.bodySmall,
                              ),
                              onTap: () {
                                bleBloc.add(BLEDeviceSelect(device));
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/bloc/ble/ble_bloc.dart';
import 'package:smart_home/bloc/ble/ble_event.dart';
import 'package:smart_home/bloc/ble/ble_state.dart';

class BLEScanScreen extends StatelessWidget {
  const BLEScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bleBloc = BlocProvider.of<BLEBloc>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('BLE Devices')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              bleBloc.add(BLEScanStart()); // Start scanning
            },
            child: const Text('Start Scanning'),
          ),
          Expanded(
            child: BlocBuilder<BLEBloc, BLEState>(
              builder: (context, state) {
                if (state is BLEScanInProgressState) {
                  return const Center(
                      child: CircularProgressIndicator()); // Show loading
                } else if (state is BLEScanCompleteState) {
                  return ListView.builder(
                    itemCount: state.devices.length, // Show list of devices
                    itemBuilder: (context, index) {
                      final device = state.devices[index];
                      return ListTile(
                        title: Text(device.name.isEmpty
                            ? "Unknown Device"
                            : device.name),
                        subtitle: Text(device.id.toString()),
                        onTap: () {
                          bleBloc.add(BLEDeviceSelect(
                              device)); // Connect to selected device
                        },
                      );
                    },
                  );
                } else if (state is BLEDeviceConnectedState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Connected to ${state.device.name}'),
                        const SizedBox(height: 10),
                        Text('Data: ${state.data}'),
                      ],
                    ),
                  );
                } else if (state is BLEDeviceErrorState) {
                  return Center(child: Text(state.message)); 
                }
                return const Center(
                    child: Text('Press "Start Scanning" to find devices.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}

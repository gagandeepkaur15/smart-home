import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BLEState {}

class BLEInitialState extends BLEState {}

class BLEScanInProgressState extends BLEState {}

class BLEScanCompleteState extends BLEState {
  final List<BluetoothDevice> devices;

  BLEScanCompleteState(this.devices);
}

class BLEDeviceConnectedState extends BLEState {
  final BluetoothDevice device;
  final String data;

  BLEDeviceConnectedState(this.device, this.data);
}

class BLEDeviceErrorState extends BLEState {
  final String message;

  BLEDeviceErrorState(this.message);
}

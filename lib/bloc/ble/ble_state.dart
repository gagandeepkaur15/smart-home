import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_home/models/cached_device.dart';

abstract class BLEState {}

class BLEInitialState extends BLEState {}

class BLECachedDevicesState extends BLEState {
  final List<CachedDevice> devices;

  BLECachedDevicesState(this.devices);
}

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

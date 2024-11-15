import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BLEEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class BLEScanStart extends BLEEvent {}

class BLEScanStop extends BLEEvent {}

class BLEDeviceSelect extends BLEEvent {
  final BluetoothDevice device;

  BLEDeviceSelect(this.device);

  @override
  List<Object?> get props => [device];
}

class BLEReadData extends BLEEvent {
  final BluetoothDevice device;

  BLEReadData(this.device);

  @override
  List<Object?> get props => [device];
}
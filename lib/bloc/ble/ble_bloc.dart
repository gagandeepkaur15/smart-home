import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/bloc/ble/ble_event.dart';
import 'package:smart_home/bloc/ble/ble_state.dart';
import 'package:smart_home/services/ble.dart';

class BLEBloc extends Bloc<BLEEvent, BLEState> {
  final BLEService _bleService = BLEService();

  BLEBloc() : super(BLEInitialState()) {
    on<BLEScanStart>((event, emit) async {
      emit(BLEScanInProgressState());
      try {
        final devices = await _bleService.scanForDevices();
        if (devices.isEmpty) {
          emit(BLEDeviceErrorState("No devices found"));
        } else {
          emit(BLEScanCompleteState(devices));
        }
      } catch (e) {
        emit(BLEDeviceErrorState("Failed to scan for devices"));
      }
    });

    on<BLEDeviceSelect>((event, emit) async {
      try {
        final device = event.device;
        await _bleService.connectToDevice(device);
        emit(BLEDeviceConnectedState(device, "Device connected"));
        add(BLEReadData(device));
      } catch (e) {
        emit(BLEDeviceErrorState("Failed to connect to the device"));
      }
    });

    on<BLEReadData>((event, emit) async {
      try {
        final device = event.device;
        final data = await _bleService.readDataFromDevice(device);
        emit(BLEDeviceConnectedState(device, data));
      } catch (e) {
        emit(BLEDeviceErrorState("Failed to read data from device"));
      }
    });
  }
}

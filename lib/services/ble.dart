// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/models/cached_device.dart';

class BLEService {
  Future<void> saveDevices(List<BluetoothDevice> devices) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> deviceData = devices.map((device) {
      final deviceMap = {
        "id": device.id.toString(),
        "name": device.name,
      };
      return jsonEncode(deviceMap);
    }).toList();
    await prefs.setStringList('scanned_devices', deviceData);
  }

  Future<List<CachedDevice>> getCachedDevices() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? deviceData = prefs.getStringList('scanned_devices');

    if (deviceData != null && deviceData.isNotEmpty) {
      return deviceData
          .map((data) {
            try {
              final deviceMap = Map<String, String>.from(jsonDecode(data));
              return CachedDevice(deviceMap['id']!, deviceMap['name']!);
            } catch (e) {
              debugPrint("Error decoding device data: $e");
              return null;
            }
          })
          .whereType<CachedDevice>()
          .toList();
    }
    return [];
  }

  // Scan for available devices
  Future<List<BluetoothDevice>> scanForDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      await requestBluetoothPermissions();
      final isBluetoothOn = await FlutterBluePlus.isOn;
      debugPrint('Is Bluetooth on: $isBluetoothOn');
      if (!isBluetoothOn) {
        debugPrint('Bluetooth is off, attempting to turn on Bluetooth');
        await FlutterBluePlus.turnOn();
      }
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 6));
      await Future.delayed(const Duration(seconds: 6));

      final results = await FlutterBluePlus.scanResults.first;

      debugPrint("Scan results received: ${results.length} devices found.");

      FlutterBluePlus.scanResults.listen((results) {
        debugPrint("Received scan results: ${results.length}");
        for (var r in results) {
          var advertisementData = r.advertisementData;
          debugPrint("Advertising Data: ${advertisementData.serviceUuids}");
          debugPrint("Service Data: ${advertisementData.serviceData}");
          if (!devices.any((device) => device.id == r.device.id)) {
            devices.add(r.device);
          }
        }
      });
      await FlutterBluePlus.stopScan();
      return devices;
    } catch (e) {
      debugPrint("Error during scan: $e");
    } finally {
      FlutterBluePlus.stopScan();
    }
    return devices;
  }

  Future<void> requestBluetoothPermissions() async {
    var status = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location
    ].request();

    if (status[Permission.bluetoothScan] != PermissionStatus.granted ||
        status[Permission.bluetoothConnect] != PermissionStatus.granted ||
        status[Permission.location] != PermissionStatus.granted) {
      debugPrint("Necessary permissions not granted.");
    }
  }

  // Connect to a device
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
    } catch (e) {
      debugPrint("Error connecting to device: $e");
      rethrow;
    }
  }

  // Read data from a connected device
  Future<String> readDataFromDevice(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();

      for (var service in services) {
        debugPrint("Service: ${service.uuid}");
        for (var characteristic in service.characteristics) {
          debugPrint(
              "Characteristic: ${characteristic.uuid}, Properties: ${characteristic.properties}");
          if (characteristic.properties.read) {
            var value = await characteristic.read();
            debugPrint("Raw value: $value");
            String decodedValue = String.fromCharCodes(value);
            debugPrint("Decoded value: $decodedValue");
            String hexValue = bytesToHex(value);
            debugPrint("Hex value: $hexValue");

            return hexValue;
          }
          if (characteristic.properties.notify) {
            String hexValue = "";
            await characteristic.setNotifyValue(true);
            characteristic.value.listen((value) {
              debugPrint("Notification received: $value");
              hexValue = bytesToHex(value);
              debugPrint("Hex value notif: $hexValue");
            });

            return hexValue;
          }
        }
      }
      return "No readable characteristics found";
    } catch (e) {
      debugPrint("Error reading data from device: $e");
      return "Error reading data";
    }
  }

  String bytesToHex(List<int> bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
  }
}

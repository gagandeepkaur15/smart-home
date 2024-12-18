import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_home/bloc/auth/auth_bloc.dart';
import 'package:smart_home/bloc/ble/ble_bloc.dart';
import 'package:smart_home/bloc/mqtt/mqtt_bloc.dart';
import 'package:smart_home/routes/routes.dart';
import 'package:smart_home/services/mqtt.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await Permission.bluetoothScan.request();
  // await Permission.bluetoothConnect.request();
  // await Permission.location.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mqttService = MQTTService();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationBloc()),
        BlocProvider(create: (_) => BLEBloc()),
        BlocProvider(create: (_) => MQTTBloc(mqttService)),
      ],
      child: Builder(builder: (context) {
        return MaterialApp.router(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
          ),
          routerConfig: router(BlocProvider.of<AuthenticationBloc>(context)),
        );
      }),
    );
  }
}

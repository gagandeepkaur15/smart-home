// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA1Dsk4HeBP-rZvIxGPZ6LGGS3FvuAcKUE',
    appId: '1:587116319413:web:48ae982de2c0e9989964fc',
    messagingSenderId: '587116319413',
    projectId: 'test-6cdba',
    authDomain: 'test-6cdba.firebaseapp.com',
    storageBucket: 'test-6cdba.appspot.com',
    measurementId: 'G-GFXPM2D1P6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXvIzMBdKzUbb68dtjUnJ7yAmmYv53a6A',
    appId: '1:587116319413:android:4c50e7dcb0c2173a9964fc',
    messagingSenderId: '587116319413',
    projectId: 'test-6cdba',
    storageBucket: 'test-6cdba.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA1Dsk4HeBP-rZvIxGPZ6LGGS3FvuAcKUE',
    appId: '1:587116319413:web:65b3372c8816a29b9964fc',
    messagingSenderId: '587116319413',
    projectId: 'test-6cdba',
    authDomain: 'test-6cdba.firebaseapp.com',
    storageBucket: 'test-6cdba.appspot.com',
    measurementId: 'G-JPQHM7QJVN',
  );
}
# Smart Home

## Description

A Flutter application that integrates Firebase for authentication and data storage, Bluetooth Low Energy (BLE) functionality using `flutter_blue_plus`, and MQTT communication for real-time messaging. The app uses `flutter_bloc` for state management.

---

## Getting Started

### 1. Clone the Repository

```
git clone <repository_url>
cd <project_directory>
```

### 2. Install Dependencies

Run the following command to fetch the project dependencies:

```
flutter pub get
```

### 3. Firebase Setup

1. Set up a Firebase project and enable Firebase Authentication.
2. Download the google-services.json for Android or GoogleService-Info.plist for iOS.
3. Place the respective file in the correct directory:
- Android: android/app/
- iOS: ios/Runner/

### 4. Bluetooth and Permissions

Ensure necessary Bluetooth and location permissions are added:

- Android: Modify AndroidManifest.xml with required Bluetooth and location permissions.
- iOS: Modify Info.plist for Bluetooth permissions.

 ### 5. Run the App

 ```
flutter run
```

### Dependencies

The project uses the following dependencies:

- firebase_core
- flutter_bloc
- firebase_auth
- google_fonts
- go_router
- flutter_blue_plus
- permission_handler
- mqtt_client
- shared_preferences

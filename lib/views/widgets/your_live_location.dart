// import 'package:geolocator/geolocator.dart';
// import 'package:geolocator_android/geolocator_android.dart';
// import 'package:geolocator_android/geolocator_web.dart';
// import 'package:geolocator_apple/geolocator_apple.dart';

// late LocationSettings locationSettings;

// if (defaultTargetPlatform == TargetPlatform.android) {
//   locationSettings = AndroidSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 100,
//       forceLocationManager: true,
//       intervalDuration: const Duration(seconds: 10),
//       //(Optional) Set foreground notification config to keep the app alive
//       //when going to the background
//       foregroundNotificationConfig: const ForegroundNotificationConfig(
//         notificationText:
//         "Example app will continue to receive your location even when you aren't using it",
//         notificationTitle: "Running in Background",
//         enableWakeLock: true,
//       )
//   );
// } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
//   locationSettings = AppleSettings(
//     accuracy: LocationAccuracy.high,
//     activityType: ActivityType.fitness,
//     distanceFilter: 100,
//     pauseLocationUpdatesAutomatically: true,
//     // Only set to true if our app will be started up in the background.
//     showBackgroundLocationIndicator: false,
//   );
// } else if (kIsWeb) {
//   locationSettings = WebSettings(
//     accuracy: LocationAccuracy.high,
//     distanceFilter: 100,
//     maximumAge: Duration(minutes: 5),
//   );
// } else {
//   locationSettings = LocationSettings(
//     accuracy: LocationAccuracy.high,
//     distanceFilter: 100,
//   );
// }

// // supply location settings to getCurrentPosition
// Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

// // supply location settings to getPositionStream
// StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
//         (Position? position) {
//       print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
//     });

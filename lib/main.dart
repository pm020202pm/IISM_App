import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iism/firebase_options.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:iism/DashBoard/pages/dashboard.dart';
import 'package:in_app_update/in_app_update.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void checkForUpdates() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable &&
          updateInfo.immediateUpdateAllowed) {
        // Trigger force update
        InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error checking for updates: $e");
      }
    }
  }



  @override
  void initState() {
    checkForUpdates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inter IIT Sports',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: SplashScreen(),
      home: const DashBoard(index: 0),
    );
  }
}



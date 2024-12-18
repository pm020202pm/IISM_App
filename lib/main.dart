import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart'; // To get app version info
import 'package:url_launcher/url_launcher.dart'; // To launch App Store URL
import 'package:in_app_update/in_app_update.dart'; // For Android in-app updates
import 'package:firebase_core/firebase_core.dart'; // For Firebase
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:iism/DashBoard/pages/dashboard.dart'; // Your dashboard page
import 'package:iism/firebase_options.dart'; // Your Firebase config
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        // iOS-specific update handling
        final packageInfo = await PackageInfo.fromPlatform();
        final currentVersion = packageInfo.version;

        const appId = '6738761317'; // Replace with your App Store app ID
        final response = await http.get(Uri.parse(
            'https://itunes.apple.com/lookup?bundleId=com.iitk.iism&country=in'));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['resultCount'] > 0) {
            final latestVersion = data['results'][0]['version'];
            if (currentVersion != latestVersion) {
              // Prompt user to update
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Update Required'),
                  content: const Text(
                      'A new version of the app is available. Please update to continue.'),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        const url = 'https://apps.apple.com/app/id$appId';
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      child: const Text('Update Now'),
                    ),
                  ],
                ),
              );
            }
          }
        }
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        // Android-specific update handling
        AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
        if (updateInfo.updateAvailability ==
            UpdateAvailability.updateAvailable &&
            updateInfo.immediateUpdateAllowed) {
          InAppUpdate.performImmediateUpdate();
        }
      }
    } catch (e) {
      debugPrint("Error checking for updates: $e");
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
      home: const DashBoard(index: 0),
    );
  }
}

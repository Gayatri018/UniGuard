import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/loading_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/onboarding_screen.dart'; // Import onboarding screen

Future<void> main() async {

  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyAAMgoLQXg3I6OPlXztVGnoU4gyUUzZhEM',
      appId: '1:993667215602:android:70c058fba28f2d972f206b',
      // databaseURL: 'YOUR_DATABASE_URL',
      messagingSenderId: '993667215602',
      projectId: 'uniguard-app',
      // storageBucket: 'YOUR_STORAGE_BUCKET',

    ),
  );

  // Check if onboarding is completed
  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = prefs.getBool('onboardingComplete') ?? false;

  runApp(MyApp(showOnboarding: showOnboarding));
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;
  const MyApp({Key? key, required this.showOnboarding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: showOnboarding ? '/loading' : '/onboarding', // Decide initial screen
      getPages: [
        GetPage(name: '/onboarding', page: () => OnboardingScreen()),
        GetPage(name: '/loading', page: () => LoadingPage()),
        GetPage(name: '/signup', page: () => SignUpPage()),
        GetPage(name: '/login', page: () => LoginPage()),
      ],
    );
  }
}

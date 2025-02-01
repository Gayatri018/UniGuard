// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/loading_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';

void main() async {
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(  // Use GetMaterialApp for GetX features
      debugShowCheckedModeBanner: false,
      initialRoute: '/',  // Set the initial route
      routes: {
        '/': (context) => LoadingPage(),
        '/signup': (context) => SignUpPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
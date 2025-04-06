// screens/loading_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniguard/screens/login_page.dart';
import '../utils/token_manager.dart';
import 'landing_page.dart';
// import 'signup_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2));  // Optional splash delay

    bool loggedIn = await TokenManager.isLoggedIn();
    String? token = await TokenManager.getToken();

    print('loggedIn: $loggedIn');
    print('token: $token');

    if (loggedIn && token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LandingPage(token: token)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFFBF4F4),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8D0E02)),
          ),
        ),
      ),
    );
  }
}


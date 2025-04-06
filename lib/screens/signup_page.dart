import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uniguard/admin/view_reports.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart'; // Import GetX
import '../admin/admin_login.dart';
import '../utils/token_manager.dart';
import 'landing_page.dart';
import 'login_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _tapCount = 0;
  DateTime? _firstTapTime;

  Future<void> _signUpAnonymously() async {
    await Future.delayed(Duration(milliseconds: 100));
    try {

      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;

      if (user != null) {
        var uuid = Uuid();
        String token = uuid.v4();

        await TokenManager.saveToken(token); // instead of using SharedPreferences directly

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anonymous Login Successful')),
        );
        await Future.delayed(Duration(seconds: 1));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingPage(token: token)),
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to sign up anonymously: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _handleLogoTap() {
    DateTime now = DateTime.now();

    if (_firstTapTime == null || now.difference(_firstTapTime!) > Duration(seconds: 3)) {
      _firstTapTime = now;
      _tapCount = 1;
    } else {
      _tapCount++;
    }

    if (_tapCount == 5) {
      _tapCount = 0;
      _firstTapTime = null;
      _showAdminSplash();
    }
  }

  void _showAdminSplash() {
    Get.to(() => AdminSplashScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBF4F4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _handleLogoTap,
              child: SizedBox(
                height: 250,
                width: 250,
                child: Image.asset('assets/images/logo_final.png'),
              ),
            ),
            Text(
              'Welcome to UniGuard!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUpAnonymously,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8D0E02),
                  padding: EdgeInsets.all(15)),
              child: Text(
                'Sign Up Anonymously',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Get.to(() => LoginPage());
              },
              child: Text(
                'Have a token? Login here',
                style: TextStyle(
                  color: Color(0xFF8D0E02),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Admin Splash Screen that redirects to ViewReports after 2 seconds
class AdminSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => AdminLoginPage()); // Navigate to ViewReports after splash
    });

    return Scaffold(
      backgroundColor: Color(0xFF8D0E02),
      body: Center(
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Welcome, Admin!',
                speed: Duration(milliseconds: 100), // Typing speed
              ),
            ],
            totalRepeatCount: 1, // Show animation only once
          ),
        ),
      ),
    );
  }
}

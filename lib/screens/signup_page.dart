import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart'; // Import GetX
import 'landing_page.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUpAnonymously() async {
    try {
      // Sign in anonymously
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;

      if (user != null) {
        // Generate a unique token using uuid
        var uuid = Uuid();
        String token = uuid.v4();

        // Save token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('unique_token', token);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anonymous Login Successful')),
        );
        // Wait for a moment to allow the snackbar to show
        await Future.delayed(Duration(seconds: 1)); // Wait for 2 seconds

        // Navigate to LandingPage with the token
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBF4F4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 250,
              width: 250,
              child: Image.asset('assets/images/logo_final.png'),
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
                padding: EdgeInsets.all(15)
              ),
              child: Text('Sign Up Anonymously',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate to LoginPage when the link is clicked
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

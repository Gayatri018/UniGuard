// 4cb7fe6a-aa6e-4a92-b627-7f9c2f08d98d
// a76e2232-22fb-469b-b0e9-d1c933134ae4

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'landing_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _tokenController = TextEditingController();
  
  Future<void> _loginWithToken() async {
    String enteredToken = _tokenController.text.trim();
    if (enteredToken.isNotEmpty) {
      // Fetch the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedToken = prefs.getString('unique_token');

      if (storedToken != null && storedToken == enteredToken) {
        // If tokens match, navigate to LandingPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LandingPage(token: storedToken),
          ),
        );
      } else {
        // If tokens don't match, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid token. Please try again.')),
        );
      }
    } else {
      // If the input is empty, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your token.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login to UniGuard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Enter Your Token to Login',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _tokenController,
              decoration: InputDecoration(
                labelText: 'Token',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginWithToken,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

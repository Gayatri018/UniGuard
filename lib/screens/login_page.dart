import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniguard/screens/signup_page.dart';
import 'package:uniguard/utils/token_manager.dart';
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
      String? storedToken = await TokenManager.getToken();

      if (storedToken != null && storedToken == enteredToken) {
        await TokenManager.saveToken(enteredToken);
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
        centerTitle: true,
        backgroundColor: Color(0xFF8D0E02),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Enter Your Token to Login',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _tokenController,
              decoration: InputDecoration(
                floatingLabelStyle: TextStyle(color: Color(0xFF8D0E02)),
                labelStyle: TextStyle(color: Color(0xFF8D0E02)),
                labelText: 'Token',
                hintText: 'Enter your token',
                hintStyle: TextStyle(color: Color(0xFF8D0E02)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color(0xFF8D0E02)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color(0xFF8D0E02)),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text(
                'Forgot your token? Create a new account',
                style: TextStyle(
                  color: Color(0xFF8D0E02),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8D0E02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              onPressed: _loginWithToken,
              child: Text('Login', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}

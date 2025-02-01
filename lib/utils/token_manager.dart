// utils/token_manager.dart
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  // Save token to SharedPreferences
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_token', token);
  }

  // Get the saved token from SharedPreferences
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  // Clear the saved token (if needed)
  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user_token');
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static Future<void> saveUserCredentials(String pseudo, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(pseudo, password);
  }

  static Future<String?> getPassword(String pseudo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(pseudo);
  }

  static Future<String?> getLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('logged_in_user');
  }

  static Future<void> setLoggedInUser(String pseudo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('logged_in_user', pseudo);
  }

  static Future<void> removeLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_user');
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _prefs;

  /// Initialize this in `main()` before runApp()
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveUsername(String username) async {
    await _prefs?.setString('username', username);
  }

  static String? getUsername() {
    return _prefs?.getString('username');
  }

  static Future<void> saveUser(UserCredential? user) async {
    await _prefs?.setString('user', user.toString());
  }

  static String? getUser() {
    return _prefs?.getString('user');
  }

  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    await _prefs?.setBool('isLoggedIn', isLoggedIn);
  }

  static bool getLoginStatus() {
    return _prefs?.getBool('isLoggedIn') ?? false;
  }

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}

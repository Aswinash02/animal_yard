import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  Future<void> setLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }

  Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> setUserData(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', value);
  }

  Future<String> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_data') ?? '';
  }

  Future<void> setDeviceToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('device_token', value);
  }

  Future<String> getDeviceToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('device_token') ?? '';
  }
}

import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class AppSharedPreferences {
  static late SharedPreferences _preferences;
  static const _keyAccessToken = "access_token";
  static Future init() async {
    return _preferences = await SharedPreferences.getInstance();
  }

  static Future setAccessToken(String accessToken) async => _preferences.setString(_keyAccessToken, accessToken);

  static String getAccessToken() {
    final result = _preferences.getString(_keyAccessToken) ?? "";
    // print(result);
    return result;
  }

  static Future deleteAccessToken() async {
    return _preferences.clear();
  }
}

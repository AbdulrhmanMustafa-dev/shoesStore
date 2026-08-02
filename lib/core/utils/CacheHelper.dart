import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<bool> setBool(String key, bool value) async {
    return _prefs!.setBool(key, value);
  }

  static Future<bool> getBool(String key, {bool defaultValue = true}) async {
    return _prefs!.getBool(key) ?? defaultValue;
  }

  static Future<bool> saveGetStartedPressed({bool value = true}) async {
    return setBool('get_started_pressed', value);
  }

  static Future<bool> getGetStartedPressed({bool defaultValue = true}) async {
    return getBool('get_started_pressed', defaultValue: defaultValue);
  }

  static Future<bool> saveIsSignedIn({bool value = true}) async {
    return setBool('is_signed_in', value);
  }

  static Future<bool> getIsSignedIn({bool defaultValue = false}) async {
    return getBool('is_signed_in', defaultValue: defaultValue);
  }
}

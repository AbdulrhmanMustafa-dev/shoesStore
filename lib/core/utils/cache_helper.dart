import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class CacheHelper {
  final SharedPreferences _prefs;

  CacheHelper(this._prefs);

  static const _lastAddressKey = 'last_checkout_address';
  static const _lastLatitudeKey = 'last_checkout_latitude';
  static const _lastLongitudeKey = 'last_checkout_longitude';
  static const _getStartedPressedKey = 'get_started_pressed';
  static const _isSignedInKey = 'is_signed_in';

  Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = true}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  Future<bool> saveGetStartedPressed({bool value = true}) async {
    return setBool(_getStartedPressedKey, value);
  }

  bool getGetStartedPressed({bool defaultValue = false}) {
    return getBool(_getStartedPressedKey, defaultValue: defaultValue);
  }

  Future<bool> saveIsSignedIn({bool value = true}) async {
    return setBool(_isSignedInKey, value);
  }

  bool getIsSignedIn({bool defaultValue = false}) {
    return getBool(_isSignedInKey, defaultValue: defaultValue);
  }

  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> setDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  Future<void> saveLastCheckoutAddress({
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    await Future.wait([
      setString(_lastAddressKey, address),
      setDouble(_lastLatitudeKey, latitude),
      setDouble(_lastLongitudeKey, longitude),
    ]);
  }

  String? getLastCheckoutAddress() => getString(_lastAddressKey);
  double? getLastCheckoutLatitude() => getDouble(_lastLatitudeKey);
  double? getLastCheckoutLongitude() => getDouble(_lastLongitudeKey);
}

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/core/utils/cache_helper.dart';

part 'profile_state.dart';

@lazySingleton
class ProfileCubit extends Cubit<ProfileState> {
  final CacheHelper _cacheHelper;

  ProfileCubit(this._cacheHelper) : super(ProfileState()) {
    _loadSettings();
  }

  void _loadSettings() {
    emit(
      ProfileState(
        locale: Locale(_cacheHelper.getString('locale') ?? 'en'),
        isFaceIdEnabled: _cacheHelper.getBool('face_id', defaultValue: false),
        isPushNotificationsEnabled: _cacheHelper.getBool(
          'push_notifications',
          defaultValue: true,
        ),
        isLocationEnabled: _cacheHelper.getBool(
          'location_services',
          defaultValue: true,
        ),
        isDarkMode: _cacheHelper.getBool('dark_mode', defaultValue: false),

        // 💡 تحميل إعدادات الإشعارات
        isGeneralNotificationEnabled: _cacheHelper.getBool(
          'general_notif',
          defaultValue: true,
        ),
        isSoundEnabled: _cacheHelper.getBool('sound_notif', defaultValue: true),
        isVibrateEnabled: _cacheHelper.getBool(
          'vibrate_notif',
          defaultValue: false,
        ),
        isSpecialOffersEnabled: _cacheHelper.getBool(
          'special_offers_notif',
          defaultValue: true,
        ),
        isPromoDiscountEnabled: _cacheHelper.getBool(
          'promo_discount_notif',
          defaultValue: true,
        ),
        isPaymentsEnabled: _cacheHelper.getBool(
          'payments_notif',
          defaultValue: true,
        ),
      ),
    );
  }

  Future<void> setLocale(Locale locale) async {
    await _cacheHelper.setString('locale', locale.languageCode);
    if (!isClosed) emit(state.copyWith(locale: locale));
  }

  // الدوال السابقة...
  Future<void> toggleFaceId(bool value) async {
    await _cacheHelper.setBool('face_id', value);
    if (!isClosed) emit(state.copyWith(isFaceIdEnabled: value));
  }

  Future<void> togglePushNotifications(bool value) async {
    await _cacheHelper.setBool('push_notifications', value);
    if (!isClosed) emit(state.copyWith(isPushNotificationsEnabled: value));
  }

  Future<void> toggleLocation(bool value) async {
    await _cacheHelper.setBool('location_services', value);
    if (!isClosed) emit(state.copyWith(isLocationEnabled: value));
  }

  Future<void> toggleDarkMode(bool value) async {
    await _cacheHelper.setBool('dark_mode', value);
    if (!isClosed) emit(state.copyWith(isDarkMode: value));
  }

  // 💡 دوال الإشعارات الجديدة
  Future<void> toggleGeneralNotification(bool value) async {
    await _cacheHelper.setBool('general_notif', value);
    if (!isClosed) emit(state.copyWith(isGeneralNotificationEnabled: value));
  }

  Future<void> toggleSound(bool value) async {
    await _cacheHelper.setBool('sound_notif', value);
    if (!isClosed) emit(state.copyWith(isSoundEnabled: value));
  }

  Future<void> toggleVibrate(bool value) async {
    await _cacheHelper.setBool('vibrate_notif', value);
    if (!isClosed) emit(state.copyWith(isVibrateEnabled: value));
  }

  Future<void> toggleSpecialOffers(bool value) async {
    await _cacheHelper.setBool('special_offers_notif', value);
    // تحكم حقيقي في فايربيز
    if (value) {
      await FirebaseMessaging.instance.subscribeToTopic('special_offers');
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic('special_offers');
    }
    if (!isClosed) emit(state.copyWith(isSpecialOffersEnabled: value));
  }

  Future<void> togglePromoDiscount(bool value) async {
    await _cacheHelper.setBool('promo_discount_notif', value);
    if (value) {
      await FirebaseMessaging.instance.subscribeToTopic('promo_discount');
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic('promo_discount');
    }
    if (!isClosed) emit(state.copyWith(isPromoDiscountEnabled: value));
  }

  Future<void> togglePaymentsNotification(bool value) async {
    await _cacheHelper.setBool('payments_notif', value);
    if (!isClosed) emit(state.copyWith(isPaymentsEnabled: value));
  }
}

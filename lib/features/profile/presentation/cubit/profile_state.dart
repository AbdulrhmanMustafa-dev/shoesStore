part of 'profile_cubit.dart';

class ProfileState {
  final bool isFaceIdEnabled;
  final bool isPushNotificationsEnabled;
  final bool isLocationEnabled;
  final bool isDarkMode;

  // 💡 المتغيرات الجديدة للإشعارات
  final bool isGeneralNotificationEnabled;
  final bool isSoundEnabled;
  final bool isVibrateEnabled;
  final bool isSpecialOffersEnabled;
  final bool isPromoDiscountEnabled;
  final bool isPaymentsEnabled;

  ProfileState({
    this.isFaceIdEnabled = false,
    this.isPushNotificationsEnabled = true,
    this.isLocationEnabled = true,
    this.isDarkMode = false,
    this.isGeneralNotificationEnabled = true,
    this.isSoundEnabled = true,
    this.isVibrateEnabled = false,
    this.isSpecialOffersEnabled = true,
    this.isPromoDiscountEnabled = true,
    this.isPaymentsEnabled = true,
  });

  ProfileState copyWith({
    bool? isFaceIdEnabled,
    bool? isPushNotificationsEnabled,
    bool? isLocationEnabled,
    bool? isDarkMode,
    bool? isGeneralNotificationEnabled,
    bool? isSoundEnabled,
    bool? isVibrateEnabled,
    bool? isSpecialOffersEnabled,
    bool? isPromoDiscountEnabled,
    bool? isPaymentsEnabled,
  }) {
    return ProfileState(
      isFaceIdEnabled: isFaceIdEnabled ?? this.isFaceIdEnabled,
      isPushNotificationsEnabled:
          isPushNotificationsEnabled ?? this.isPushNotificationsEnabled,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isGeneralNotificationEnabled:
          isGeneralNotificationEnabled ?? this.isGeneralNotificationEnabled,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      isVibrateEnabled: isVibrateEnabled ?? this.isVibrateEnabled,
      isSpecialOffersEnabled:
          isSpecialOffersEnabled ?? this.isSpecialOffersEnabled,
      isPromoDiscountEnabled:
          isPromoDiscountEnabled ?? this.isPromoDiscountEnabled,
      isPaymentsEnabled: isPaymentsEnabled ?? this.isPaymentsEnabled,
    );
  }
}

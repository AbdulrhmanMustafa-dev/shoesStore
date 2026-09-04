part of 'checkout_cubit.dart';

class CheckoutState {
  final String email;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;
  final bool isFetchingLocation;
  final String? errorMessage;
  final String paymentMethod; // 💡 المتغير الجديد

  CheckoutState({
    this.email = '',
    this.phone = '',
    this.address = 'Your Address',
    this.latitude = 30.3712,
    this.longitude = 30.5256,
    this.isFetchingLocation = false,
    this.errorMessage,
    this.paymentMethod = 'Cash on Delivery',
  });

  CheckoutState copyWith({
    String? email,
    String? phone,
    String? address,
    double? latitude,
    double? longitude,
    bool? isFetchingLocation,
    String? errorMessage,
    bool clearError = false,
    String? paymentMethod, // 💡 التحديث هنا
  }) {
    return CheckoutState(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isFetchingLocation: isFetchingLocation ?? this.isFetchingLocation,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      paymentMethod: paymentMethod ?? this.paymentMethod, // 💡 التحديث هنا
    );
  }
}

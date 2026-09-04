import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/core/utils/cache_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

part 'checkout_state.dart';

@injectable
class CheckoutCubit extends Cubit<CheckoutState> {
  final CacheHelper _cacheHelper;

  CheckoutCubit(this._cacheHelper) : super(CheckoutState()) {
    _loadUserData();
    _restoreLastKnownAddress();
    getCurrentLocation();
  }

  void _loadUserData() {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'No Email Found';

    final phone =
        _cacheHelper.getString('user_phone') ?? 'Add your phone number';

    emit(state.copyWith(email: email, phone: phone));
  }

  void changePaymentMethod(String method) {
    emit(state.copyWith(paymentMethod: method));
  }

  Future<void> updatePhone(String newPhone) async {
    if (newPhone.trim().isEmpty) return;

    await _cacheHelper.setString('user_phone', newPhone.trim());
    emit(state.copyWith(phone: newPhone.trim()));
  }

  void _restoreLastKnownAddress() {
    final address = _cacheHelper.getLastCheckoutAddress();
    if (address == null || address.trim().isEmpty) return;

    emit(
      state.copyWith(
        address: address,
        latitude: _cacheHelper.getLastCheckoutLatitude() ?? state.latitude,
        longitude: _cacheHelper.getLastCheckoutLongitude() ?? state.longitude,
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    // نبدأ التحميل ونمسح أي إيرور قديم
    emit(state.copyWith(isFetchingLocation: true, clearError: true));

    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Please enable GPS services.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final List<geocoding.Placemark> placemarks = await geocoding.Geocoding()
          .placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isEmpty) {
        throw Exception('No address found for the current location.');
      }

      final place = placemarks.first;
      final currentAddress = [place.street, place.locality, place.country]
          .whereType<String>()
          .map((value) => value.trim())
          .where((value) => value.isNotEmpty)
          .join(', ');
      if (currentAddress.isEmpty) {
        throw Exception('No address found for the current location.');
      }

      await _cacheHelper.saveLastCheckoutAddress(
        address: currentAddress,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      emit(
        state.copyWith(
          isFetchingLocation: false,
          latitude: position.latitude,
          longitude: position.longitude,
          address: currentAddress,
        ),
      );
    } catch (e) {
      // 💡 لو حصل مشكلة، هنقفل التحميل ونبعت رسالة الخطأ
      emit(
        state.copyWith(
          isFetchingLocation: false,
          errorMessage: _cacheHelper.getLastCheckoutAddress() == null
              ? 'Could not fetch location. Check GPS or Internet.'
              : 'Could not refresh location. Showing your last saved address.',
        ),
      );
    }
  }
}

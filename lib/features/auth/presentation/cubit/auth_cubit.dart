import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/features/auth/domain/repositories/auth_repository.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthInitial());

  final AuthRepository _repository;

  // 1. دالة تسجيل الدخول (Sign In)
  Future<void> signIn({required String email, required String password}) async {
    if (state is AuthLoading) return;
    emit(const AuthLoading());
    try {
      final userId = await _repository.signIn(email: email, password: password);
      await saveDeviceToken(userId);
      emit(AuthSuccess(userId: userId));
    } on AuthException catch (exception) {
      emit(AuthFailure(errorMessage: exception.message));
    } on Object {
      _emitUnexpectedFailure();
    }
  }

  // 2. دالة إنشاء حساب جديد (Sign Up)
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    if (state is AuthLoading) return;
    emit(const AuthLoading());
    try {
      final userId = await _repository.signUp(
        name: name,
        email: email,
        password: password,
      );
      await saveDeviceToken(userId);
      emit(AuthSuccess(userId: userId));
    } on AuthException catch (exception) {
      emit(AuthFailure(errorMessage: exception.message));
    } on Object {
      _emitUnexpectedFailure();
    }
  }

  // 3. دالة استعادة كلمة المرور (Reset Password)
  Future<void> resetPassword({required String email}) async {
    if (state is AuthLoading) return;
    emit(const AuthLoading());
    try {
      await _repository.sendPasswordResetEmail(email);
      emit(const PasswordResetEmailSent());
    } on AuthException catch (exception) {
      emit(AuthFailure(errorMessage: exception.message));
    } on Object {
      _emitUnexpectedFailure();
    }
  }

  Future<void> signInWithGoogle() async {
    if (state is AuthLoading) return;
    emit(const AuthLoading());
    try {
      final userId = await _repository.signInWithGoogle();
      await saveDeviceToken(userId);
      emit(AuthSuccess(userId: userId));
    } on AuthException catch (exception) {
      emit(AuthFailure(errorMessage: exception.message));
    } on Object {
      _emitUnexpectedFailure();
    }
  }

  //notify the server about the device token for push notifications
  Future<void> saveDeviceToken(String userId) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      // تحديث أو إضافة الـ Token في الدوكيومنت الخاص بالمستخدم
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fcmToken': fcmToken,
      }, SetOptions(merge: true));
    }
  }

  void _emitUnexpectedFailure() {
    emit(
      const AuthFailure(
        errorMessage: 'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً.',
      ),
    );
  }
}

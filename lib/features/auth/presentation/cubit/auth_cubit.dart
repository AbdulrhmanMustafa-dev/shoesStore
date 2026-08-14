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
      emit(AuthSuccess(userId: userId));
    } on AuthException catch (exception) {
      emit(AuthFailure(errorMessage: exception.message));
    } on Object {
      _emitUnexpectedFailure();
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

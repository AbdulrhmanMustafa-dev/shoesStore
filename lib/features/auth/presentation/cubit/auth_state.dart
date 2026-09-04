part of 'auth_cubit.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final String userId;
  const AuthSuccess({required this.userId});
}

class AuthFailure extends AuthState {
  final String errorMessage;
  const AuthFailure({required this.errorMessage});
}

class PasswordResetEmailSent extends AuthState {
  const PasswordResetEmailSent();
}

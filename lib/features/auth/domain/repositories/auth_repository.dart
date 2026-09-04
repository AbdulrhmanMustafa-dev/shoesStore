abstract class AuthRepository {
  Future<String> signIn({required String email, required String password});
  Future<String> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<void> sendPasswordResetEmail(String email);
  Future<String> signInWithGoogle();
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;
}

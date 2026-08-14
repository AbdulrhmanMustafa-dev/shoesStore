import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/core/utils/cache_helper.dart';
import 'package:kicksvibe/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._auth, this._googleSignIn);

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  bool _googleSignInInitialized = false;

  @override
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _storeSignedInUser(credential);
    } on FirebaseAuthException catch (exception) {
      throw AuthException(_firebaseMessage(exception));
    }
  }

  @override
  Future<String> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException('Could not create the account.');
      }
      await user.updateDisplayName(name.trim());
      await CacheHelper.saveIsSignedIn(value: true);
      return user.uid;
    } on FirebaseAuthException catch (exception) {
      throw AuthException(_firebaseMessage(exception));
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (exception) {
      throw AuthException(_firebaseMessage(exception));
    }
  }

  @override
  Future<String> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();
      final googleUser = await _googleSignIn.authenticate();
      final authentication = googleUser.authentication;
      var authorization = await googleUser.authorizationClient
          .authorizationForScopes(<String>['email']);
      authorization ??= await googleUser.authorizationClient.authorizeScopes(
        <String>['email'],
      );
      final credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        idToken: authentication.idToken,
      );
      return _storeSignedInUser(await _auth.signInWithCredential(credential));
    } on GoogleSignInException catch (exception) {
      if (exception.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException('Sign-in was cancelled.');
      }
      throw AuthException(
        'Google sign-in failed: ${exception.description ?? exception.code}',
      );
    } on FirebaseAuthException catch (exception) {
      throw AuthException(_firebaseMessage(exception));
    }
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    await _googleSignIn.initialize();
    _googleSignInInitialized = true;
  }

  Future<String> _storeSignedInUser(UserCredential credential) async {
    final user = credential.user;
    if (user == null) {
      throw const AuthException('Could not sign in. Please try again.');
    }
    await CacheHelper.saveIsSignedIn(value: true);
    return user.uid;
  }

  String _firebaseMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return 'لا يوجد حساب مسجل بهذا البريد الإلكتروني.';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة.';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل.';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً.';
      case 'invalid-email':
        return 'صيغة البريد الإلكتروني غير صحيحة.';
      default:
        return exception.message ?? 'حدث خطأ في المصادقة.';
    }
  }
}

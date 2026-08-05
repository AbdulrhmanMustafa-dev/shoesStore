import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/core/utils/CacheHelper.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  AuthCubit(this._auth, this._googleSignIn) : super(AuthInitial());

  // 1. دالة تسجيل الدخول (Sign In)
  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      await CacheHelper.saveIsSignedIn(value: true);
      emit(AuthSuccess(userId: userCredential.user!.uid));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(errorMessage: _getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(
        AuthFailure(errorMessage: "حدث خطأ غير متوقع، يرجى المحاولة لاحقاً."),
      );
    }
  }

  // 2. دالة إنشاء حساب جديد (Sign Up)
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(AuthLoading());
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // تحديث اسم المستخدم في بروفايل فايربيس
      await userCredential.user?.updateDisplayName(name);
      await CacheHelper.saveIsSignedIn(value: true);

      emit(AuthSuccess(userId: userCredential.user!.uid));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(errorMessage: _getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(
        AuthFailure(errorMessage: "حدث خطأ غير متوقع، يرجى المحاولة لاحقاً."),
      );
    }
  }

  // 3. دالة استعادة كلمة المرور (Reset Password)
  Future<void> resetPassword({required String email}) async {
    emit(AuthLoading());
    try {
      await _auth.sendPasswordResetEmail(email: email);
      // بنبعت Success بس الـ UI هيتعامل معاها على إنها رسالة تأكيد مش دخول للتطبيق
      emit(AuthSuccess(userId: ""));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(errorMessage: _getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(
        AuthFailure(errorMessage: "حدث خطأ غير متوقع، يرجى المحاولة لاحقاً."),
      );
    }
  }

  // google_sign_in v7+ uses a singleton that must be initialized once.

  bool _googleSignInInitialized = false;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    await _googleSignIn.initialize(
      // clientId: 'YOUR_IOS_CLIENT_ID', // only needed on iOS/macOS if not using GoogleService-Info.plist
      // serverClientId: 'YOUR_WEB_CLIENT_ID', // needed if you use idToken with a backend / Firebase on Android
    );
    _googleSignInInitialized = true;
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      await _ensureGoogleSignInInitialized();

      // 1. Trigger the Google account picker (authenticate replaces signIn())
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // 2. Get the ID token (authentication is now synchronous)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // 3. Get an access token via the separate authorization client
      //    (authentication and authorization are split in v7+).
      GoogleSignInClientAuthorization? authorization = await googleUser
          .authorizationClient
          .authorizationForScopes(<String>['email']);
      authorization ??= await googleUser.authorizationClient.authorizeScopes(
        <String>['email'],
      );

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase using these keys
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      await CacheHelper.saveIsSignedIn(value: true);
      emit(AuthSuccess(userId: userCredential.user!.uid));
    } on GoogleSignInException catch (e) {
      // Covers user cancellation and other Google Sign-In specific errors.
      if (e.code == GoogleSignInExceptionCode.canceled) {
        emit(AuthFailure(errorMessage: 'Sign-in was cancelled.'));
      } else {
        emit(
          AuthFailure(
            errorMessage: 'Google sign-in failed: ${e.description ?? e.code}',
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(errorMessage: _getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(
        AuthFailure(
          errorMessage: "An unexpected error occurred during Google sign-in.",
        ),
      );
    }
  }

  // دالة مساعدة لتحويل أكواد فايربيس لرسائل مفهومة للمستخدم
  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
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
        return e.message ?? 'حدث خطأ في المصادقة.';
    }
  }
}

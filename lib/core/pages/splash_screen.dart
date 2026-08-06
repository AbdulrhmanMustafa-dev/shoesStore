import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';
import 'package:kicksvibe/core/utils/cache_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _routeUser();
  }

  Future<void> _routeUser() async {
    final isSignedIn = FirebaseAuth.instance.currentUser != null;
    final bool getStartedPressed = await CacheHelper.getGetStartedPressed();

    if (!mounted) return;

    final String nextRoute = isSignedIn
        ? AppRoutes.home
        : getStartedPressed
        ? AppRoutes.login
        : AppRoutes.onboarding;

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

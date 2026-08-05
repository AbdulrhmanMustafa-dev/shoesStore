import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/di/injection.dart';
import 'package:kicksvibe/core/pages/splash_screen.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
import 'package:kicksvibe/features/Home/presentation/cubit/home_cubit.dart';
import 'package:kicksvibe/features/Home/presentation/pages/homeScreen.dart';
import 'package:kicksvibe/features/Onboarding/presentation/pages/OnboardingScreen.dart';
import 'package:kicksvibe/features/auth/presentation/pages/login_screen.dart';
import 'package:kicksvibe/features/auth/presentation/pages/recovery_password_screen.dart';
import 'package:kicksvibe/features/auth/presentation/pages/register_screen.dart';
import 'package:kicksvibe/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:kicksvibe/features/product_details/presentation/pages/ProductDetailsScreen.dart';
import 'app_routes.dart';
class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) =>  OnboardingScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      case AppRoutes.recoveryPassword:
        return MaterialPageRoute(builder: (_) => RecoveryPasswordScreen());
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
              getIt<HomeCubit>()
                  ..fetchHomeData(), // جلب البيانات فور بناء الكيوبت
            child: const HomeScreen(),
          ),
        );
       // تأكد من عمل استيراد لملفات الـ Cubit والـ injection
      case AppRoutes.productDetails:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                getIt<ProductDetailsCubit>(), // توفير الكيوبت من getIt
            child: ProductDetailsScreen(product: product),
          ),
        );
      default:
        // شاشة افتراضية لو المسار غير موجود
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

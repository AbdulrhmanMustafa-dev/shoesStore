import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/di/injection.dart';
import 'package:kicksvibe/core/pages/splash_screen.dart';
import 'package:kicksvibe/features/home/data/models/product_model.dart';
import 'package:kicksvibe/features/home/presentation/cubit/home_cubit.dart';
import 'package:kicksvibe/features/home/presentation/pages/best_sellers_screen.dart';
import 'package:kicksvibe/features/home/presentation/pages/home_screen.dart';
import 'package:kicksvibe/features/home/presentation/pages/main_layout.dart';
import 'package:kicksvibe/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:kicksvibe/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:kicksvibe/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:kicksvibe/features/auth/presentation/pages/login_screen.dart';
import 'package:kicksvibe/features/auth/presentation/pages/recovery_password_screen.dart';
import 'package:kicksvibe/features/auth/presentation/pages/register_screen.dart';
import 'package:kicksvibe/features/cart/presentation/pages/cart_screen.dart';
import 'package:kicksvibe/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:kicksvibe/features/checkout/presentation/pages/checkout_screen.dart';
import 'package:kicksvibe/features/favourite/presentation/pages/favorite_screen.dart';
import 'package:kicksvibe/features/orders/data/models/order_model.dart';
import 'package:kicksvibe/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:kicksvibe/features/orders/presentation/pages/order_details_screen.dart';
import 'package:kicksvibe/features/orders/presentation/pages/orders_screen.dart';
import 'package:kicksvibe/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:kicksvibe/features/product_details/presentation/pages/product_details_screen.dart';
import 'package:kicksvibe/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:kicksvibe/features/profile/presentation/pages/NotificationSettingsScreen.dart';
import 'package:kicksvibe/features/profile/presentation/pages/PaymentInfoScreen.dart';
import 'package:kicksvibe/features/profile/presentation/pages/ProfileDetailsScreen.dart';
import 'package:kicksvibe/features/profile/presentation/pages/ShippingAddressScreen.dart';
import 'package:kicksvibe/features/profile/presentation/pages/profile_screen.dart';

import 'app_routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.recoveryPassword:
        return MaterialPageRoute(
          builder: (_) => const RecoveryPasswordScreen(),
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<HomeCubit>()..fetchHomeData(),
            child: const MainLayout(),
          ),
        );
      case AppRoutes.bestSellers:
        final products = settings.arguments;
        if (products is! List<ProductModel>) {
          return _errorRoute('Best sellers requires a list of products.');
        }
        return MaterialPageRoute(
          builder: (_) => BestSellersScreen(products: products),
        );
      case AppRoutes.productDetails:
        final product = settings.arguments;
        if (product is! ProductModel) {
          return _errorRoute('Product details requires a valid product.');
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                getIt<ProductDetailsCubit>(), // توفير الكيوبت من getIt
            child: ProductDetailsScreen(product: product),
          ),
        );
      case AppRoutes.favorite:
        return MaterialPageRoute(builder: (_) => const FavoriteScreen());
      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case AppRoutes.checkout:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<CheckoutCubit>(), // 💡 حقن الكيوبت هنا
            child: const CheckoutScreen(),
          ),
        );
      case AppRoutes.orders:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<OrdersCubit>(),
            child: const OrdersScreen(),
          ),
        );
      case AppRoutes.orderDetails:
        final order = settings.arguments;
        if (order is! OrderModel) {
          return _errorRoute('Order details requires a valid order.');
        }
        return MaterialPageRoute(
          builder: (_) => OrderDetailsScreen(order: order),
        );
      case AppRoutes.notifications:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<NotificationsCubit>(),
            child: const NotificationsScreen(),
          ),
        );
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppRoutes.profileDetails:
        return MaterialPageRoute(builder: (_) => const ProfileDetailsScreen());
      case AppRoutes.notificationSettings:
        return MaterialPageRoute(
          builder: (_) => const NotificationSettingsScreen(),
        );
      case AppRoutes.shippingAddress:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<OrdersCubit>(),
            child: const ShippingAddressScreen(),
          ),
        );
      case AppRoutes.paymentInfo:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<OrdersCubit>(),
            child: const PaymentInfoScreen(),
          ),
        );
      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  MaterialPageRoute<void> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(body: Center(child: Text(message))),
    );
  }
}

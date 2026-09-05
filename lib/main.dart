import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:kicksvibe/core/di/injection.dart';
import 'package:kicksvibe/core/routes/app_router.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';
import 'package:kicksvibe/core/utils/app_colors.dart';
import 'package:kicksvibe/core/localization/app_localizations.dart';
import 'package:kicksvibe/features/home/data/models/brand_model.dart';
import 'package:kicksvibe/features/home/data/models/product_model.dart';
import 'package:kicksvibe/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kicksvibe/features/cart/data/models/cart_item_model.dart';
import 'package:kicksvibe/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:kicksvibe/features/favourite/presentation/cubit/favourite_cubit.dart';
import 'package:kicksvibe/features/home/presentation/cubit/search_cubit.dart';
import 'package:kicksvibe/features/notifications/data/models/NotificationModel.dart';
import 'package:kicksvibe/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:kicksvibe/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(BrandModelAdapter());
  Hive.registerAdapter(CartItemModelAdapter());
  Hive.registerAdapter(
    NotificationModelAdapter(),
  ); // تسجيل الـ Adapter الخاص بالإشعارات

  // Open Hive Boxes
  await Future.wait([
    Hive.openBox<CartItemModel>('cartBox'),
    Hive.openBox<ProductModel>('favoritesBox'),
    Hive.openBox<ProductModel>('homeProductsBox'),
    Hive.openBox<BrandModel>('brandsBox'),
    Hive.openBox<NotificationModel>('notificationsBox'), // فتح صندوق الإشعارات
  ]);

  // Set up Firebase Messaging background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      // سيقوم هذا السطر بطباعة الإشعار في الكونسول للتأكد من وصوله
      print('Foreground Notification: ${message.notification?.title}');
      // ملاحظة: لإظهار شكل الإشعار المنبثق (Heads-up) والتطبيق مفتوح، ستحتاج لاحقاً لحزمة مثل flutter_local_notifications
    }
  });

  await configureDependencies();

  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  final String initialRoute;

  const MyApp({
    super.key,
    required this.appRouter,
    this.initialRoute = AppRoutes.splash,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
        BlocProvider<FavoriteCubit>(
          create: (context) => getIt<FavoriteCubit>(),
        ),
        BlocProvider<CartCubit>(create: (context) => getIt<CartCubit>()),
        BlocProvider<ProfileCubit>(create: (context) => getIt<ProfileCubit>()),
        BlocProvider<SearchCubit>(create: (context) => getIt<SearchCubit>()),
      ],
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shoes Store',
            theme: _buildTheme(Brightness.light),
            darkTheme: _buildTheme(Brightness.dark),
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            locale: state.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            onGenerateRoute: appRouter.generateRoute,
            initialRoute: initialRoute,
          );
        },
      ),
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: brightness,
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

// removed unused firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:kicksvibe/core/di/injection.dart';
import 'package:kicksvibe/core/routes/app_router.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';
import 'package:kicksvibe/core/utils/cache_helper.dart';
import 'package:kicksvibe/features/Home/data/models/brand_model.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
import 'package:kicksvibe/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kicksvibe/features/cart/data/models/cart_item_model.dart';
import 'package:kicksvibe/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:kicksvibe/features/favourite/presentation/cubit/favourite_cubit.dart';
import 'package:kicksvibe/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await CacheHelper.init();
  configureDependencies();

  await Hive.initFlutter();
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(BrandModelAdapter());

  Hive.registerAdapter(CartItemModelAdapter());
  await Hive.openBox<CartItemModel>('cartBox');

  await Hive.openBox<ProductModel>('favoritesBox');
  await Hive.openBox<ProductModel>('homeProductsBox');
  await Hive.openBox<BrandModel>('brandsBox');

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KicksVibe',
        theme: ThemeData(primarySwatch: Colors.blue),
        onGenerateRoute: appRouter.generateRoute,
        initialRoute: initialRoute,
      ),
    );
  }
}

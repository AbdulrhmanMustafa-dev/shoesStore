import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/di/injection.dart';
import 'package:kicksvibe/core/routes/app_router.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';
import 'package:kicksvibe/core/utils/CacheHelper.dart';
import 'package:kicksvibe/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kicksvibe/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();
  configureDependencies();
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
      providers: [BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>())],
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

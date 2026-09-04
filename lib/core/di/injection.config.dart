// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:kicksvibe/core/di/app_module.dart' as _i171;
import 'package:kicksvibe/core/utils/cache_helper.dart' as _i708;
import 'package:kicksvibe/features/auth/data/repositories/auth_repository_impl.dart'
    as _i63;
import 'package:kicksvibe/features/auth/domain/repositories/auth_repository.dart'
    as _i357;
import 'package:kicksvibe/features/auth/presentation/cubit/auth_cubit.dart'
    as _i437;
import 'package:kicksvibe/features/cart/data/repositories/cart_repository_impl.dart'
    as _i903;
import 'package:kicksvibe/features/cart/domain/repositories/cart_repository.dart'
    as _i31;
import 'package:kicksvibe/features/cart/presentation/cubit/cart_cubit.dart'
    as _i359;
import 'package:kicksvibe/features/checkout/presentation/cubit/checkout_cubit.dart'
    as _i683;
import 'package:kicksvibe/features/favourite/data/repositories/favorite_repository_impl.dart'
    as _i647;
import 'package:kicksvibe/features/favourite/domain/repositories/favorite_repository.dart'
    as _i940;
import 'package:kicksvibe/features/favourite/presentation/cubit/favourite_cubit.dart'
    as _i514;
import 'package:kicksvibe/features/home/data/repositories/home_repository_impl.dart'
    as _i210;
import 'package:kicksvibe/features/home/domain/repositories/home_repository.dart'
    as _i869;
import 'package:kicksvibe/features/home/presentation/cubit/home_cubit.dart'
    as _i147;
import 'package:kicksvibe/features/notifications/data/repositories/NotificationsRepositoryImpl.dart'
    as _i817;
import 'package:kicksvibe/features/notifications/presentation/cubit/notifications_cubit.dart'
    as _i410;
import 'package:kicksvibe/features/onboarding/presentation/cubit/onboarding_cubit.dart'
    as _i56;
import 'package:kicksvibe/features/orders/data/repositories/orders_repository_impl.dart'
    as _i119;
import 'package:kicksvibe/features/orders/domain/repositories/orders_repository.dart'
    as _i625;
import 'package:kicksvibe/features/orders/presentation/cubit/orders_cubit.dart'
    as _i233;
import 'package:kicksvibe/features/product_details/domain/usecases/add_product_to_cart.dart'
    as _i1014;
import 'package:kicksvibe/features/product_details/presentation/cubit/product_details_cubit.dart'
    as _i657;
import 'package:kicksvibe/features/profile/presentation/cubit/profile_cubit.dart'
    as _i505;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i974.FirebaseFirestore>(() => appModule.firestore);
    gh.lazySingleton<_i59.FirebaseAuth>(() => appModule.firebaseAuth);
    gh.lazySingleton<_i116.GoogleSignIn>(() => appModule.googleSignIn);
    gh.lazySingleton<_i31.CartRepository>(() => _i903.CartRepositoryImpl());
    gh.lazySingleton<_i940.FavoriteRepository>(
      () => _i647.FavoriteRepositoryImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i708.CacheHelper>(
      () => _i708.CacheHelper(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i869.HomeRepository>(
      () => _i210.HomeRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i625.OrdersRepository>(
      () => _i119.OrdersRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i1014.AddProductToCart>(
      () => _i1014.AddProductToCart(gh<_i31.CartRepository>()),
    );
    gh.lazySingleton<_i817.NotificationsRepository>(
      () => _i817.NotificationsRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i359.CartCubit>(
      () => _i359.CartCubit(gh<_i31.CartRepository>()),
    );
    gh.factory<_i657.ProductDetailsCubit>(
      () => _i657.ProductDetailsCubit(gh<_i1014.AddProductToCart>()),
    );
    gh.lazySingleton<_i514.FavoriteCubit>(
      () => _i514.FavoriteCubit(gh<_i940.FavoriteRepository>()),
    );
    gh.lazySingleton<_i357.AuthRepository>(
      () => _i63.AuthRepositoryImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i116.GoogleSignIn>(),
        gh<_i708.CacheHelper>(),
      ),
    );
    gh.factory<_i147.HomeCubit>(
      () => _i147.HomeCubit(gh<_i869.HomeRepository>()),
    );
    gh.factory<_i56.OnboardingCubit>(
      () => _i56.OnboardingCubit(gh<_i708.CacheHelper>()),
    );
    gh.lazySingleton<_i683.CheckoutCubit>(
      () => _i683.CheckoutCubit(gh<_i708.CacheHelper>()),
    );
    gh.lazySingleton<_i505.ProfileCubit>(
      () => _i505.ProfileCubit(gh<_i708.CacheHelper>()),
    );
    gh.factory<_i410.NotificationsCubit>(
      () => _i410.NotificationsCubit(gh<_i817.NotificationsRepository>()),
    );
    gh.factory<_i233.OrdersCubit>(
      () => _i233.OrdersCubit(gh<_i625.OrdersRepository>()),
    );
    gh.factory<_i437.AuthCubit>(
      () => _i437.AuthCubit(gh<_i357.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i708.RegisterModule {}

class _$AppModule extends _i171.AppModule {}

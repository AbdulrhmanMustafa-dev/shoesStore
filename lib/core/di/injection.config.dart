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
import 'package:kicksvibe/features/favourite/data/repositories/favorite_repository_impl.dart'
    as _i647;
import 'package:kicksvibe/features/favourite/domain/repositories/favorite_repository.dart'
    as _i940;
import 'package:kicksvibe/features/favourite/presentation/cubit/favourite_cubit.dart'
    as _i514;
import 'package:kicksvibe/features/Home/data/repositories/home_repository_impl.dart'
    as _i854;
import 'package:kicksvibe/features/Home/domain/repositories/home_repository.dart'
    as _i102;
import 'package:kicksvibe/features/Home/presentation/cubit/home_cubit.dart'
    as _i41;
import 'package:kicksvibe/features/product_details/domain/usecases/add_product_to_cart.dart'
    as _i1014;
import 'package:kicksvibe/features/product_details/presentation/cubit/product_details_cubit.dart'
    as _i657;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
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
    gh.lazySingleton<_i102.HomeRepository>(
      () => _i854.HomeRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i1014.AddProductToCart>(
      () => _i1014.AddProductToCart(gh<_i31.CartRepository>()),
    );
    gh.lazySingleton<_i359.CartCubit>(
      () => _i359.CartCubit(gh<_i31.CartRepository>()),
    );
    gh.lazySingleton<_i357.AuthRepository>(
      () => _i63.AuthRepositoryImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i116.GoogleSignIn>(),
      ),
    );
    gh.factory<_i437.AuthCubit>(
      () => _i437.AuthCubit(gh<_i357.AuthRepository>()),
    );
    gh.factory<_i657.ProductDetailsCubit>(
      () => _i657.ProductDetailsCubit(gh<_i1014.AddProductToCart>()),
    );
    gh.lazySingleton<_i514.FavoriteCubit>(
      () => _i514.FavoriteCubit(gh<_i940.FavoriteRepository>()),
    );
    gh.factory<_i41.HomeCubit>(
      () => _i41.HomeCubit(gh<_i102.HomeRepository>()),
    );
    return this;
  }
}

class _$AppModule extends _i171.AppModule {}

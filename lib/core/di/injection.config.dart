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
import 'package:kicksvibe/features/auth/presentation/cubit/auth_cubit.dart'
    as _i437;
import 'package:kicksvibe/features/Home/presentation/cubit/home_cubit.dart'
    as _i41;
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
    gh.factory<_i657.ProductDetailsCubit>(() => _i657.ProductDetailsCubit());
    gh.lazySingleton<_i974.FirebaseFirestore>(() => appModule.firestore);
    gh.lazySingleton<_i59.FirebaseAuth>(() => appModule.firebaseAuth);
    gh.lazySingleton<_i116.GoogleSignIn>(() => appModule.googleSignIn);
    gh.factory<_i437.AuthCubit>(
      () => _i437.AuthCubit(gh<_i59.FirebaseAuth>(), gh<_i116.GoogleSignIn>()),
    );
    gh.factory<_i41.HomeCubit>(
      () => _i41.HomeCubit(gh<_i974.FirebaseFirestore>()),
    );
    return this;
  }
}

class _$AppModule extends _i171.AppModule {}

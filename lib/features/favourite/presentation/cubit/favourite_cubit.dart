import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
import 'package:kicksvibe/features/favourite/data/repositories/favorite_repository_impl.dart';
import 'package:kicksvibe/features/favourite/domain/repositories/favorite_repository.dart';

part 'favourite_state.dart';

@lazySingleton
class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit(this._repository) : super(FavoriteState()) {
    _favoritesSubscription = _repository.watchFavorites().listen(
      (products) {
        if (!isClosed) emit(FavoriteState(favoriteProducts: products));
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!isClosed) {
          emit(state.copyWith(errorMessage: 'Could not load favourites.'));
        }
      },
    );
  }

  final FavoriteRepository _repository;
  StreamSubscription<List<ProductModel>>? _favoritesSubscription;

  // 3. إضافة أو حذف المنتج من المفضلة في Firebase مباشرة
  Future<void> toggleFavorite(ProductModel product) async {
    try {
      await _repository.toggle(product);
    } on FavoriteAuthenticationException {
      if (isClosed) return;
      emit(state.copyWith(errorMessage: 'Please sign in to save favourites.'));
    } on Object {
      if (isClosed) return;
      emit(
        state.copyWith(
          errorMessage: 'Could not update favourites. Please try again.',
        ),
      );
    }
  }

  // 4. فحص هل المنتج موجود في المفضلة
  bool isFavorite(String productId) {
    return state.favoriteProducts.any((element) => element.id == productId);
  }

  @override
  Future<void> close() async {
    await _favoritesSubscription?.cancel();
    return super.close();
  }
}

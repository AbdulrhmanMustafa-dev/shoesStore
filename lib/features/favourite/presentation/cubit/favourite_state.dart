part of 'favourite_cubit.dart';

class FavoriteState {
  final List<ProductModel> favoriteProducts;
  final bool isLoading;
  final String? errorMessage;

  FavoriteState({
    List<ProductModel> favoriteProducts = const [],
    this.isLoading = false,
    this.errorMessage,
  }) : favoriteProducts = List.unmodifiable(favoriteProducts);

  FavoriteState copyWith({
    List<ProductModel>? favoriteProducts,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FavoriteState(
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

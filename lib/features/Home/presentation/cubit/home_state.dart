part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<BrandModel> brands;
  final String selectedBrand;
  final List<ProductModel> popularProducts;
  final List<ProductModel> newArrivalProducts;

  HomeLoaded({
    required List<BrandModel> brands,
    required this.selectedBrand,
    required List<ProductModel> popularProducts,
    required List<ProductModel> newArrivalProducts,
  }) : brands = List.unmodifiable(brands),
       popularProducts = List.unmodifiable(popularProducts),
       newArrivalProducts = List.unmodifiable(newArrivalProducts);
}

class HomeError extends HomeState {
  final String errorMessage;
  HomeError(this.errorMessage);
}

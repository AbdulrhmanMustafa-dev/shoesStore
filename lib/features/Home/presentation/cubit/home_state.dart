part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ProductModel> popularProducts;
  final List<ProductModel> newArrivalProducts;

  HomeLoaded({required this.popularProducts, required this.newArrivalProducts});
}

class HomeError extends HomeState {
  final String errorMessage;
  HomeError(this.errorMessage);
}

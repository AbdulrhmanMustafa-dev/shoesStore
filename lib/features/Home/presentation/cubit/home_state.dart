part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {} // حالة التحميل

class HomeLoaded extends HomeState {
  final List<ProductModel> products; // المنتجات اللي هتروح للـ UI
  HomeLoaded(this.products);
}

class HomeError extends HomeState {
  final String errorMessage;
  HomeError(this.errorMessage);
}

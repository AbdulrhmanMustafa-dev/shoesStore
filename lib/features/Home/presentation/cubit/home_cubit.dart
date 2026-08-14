import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
import 'package:kicksvibe/features/Home/data/models/brand_model.dart';
import 'package:kicksvibe/features/Home/domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeInitial());

  final HomeRepository _repository;
  StreamSubscription<HomeCatalog>? _catalogSubscription;

  List<ProductModel> _allProducts = const [];
  List<BrandModel> _brands = const [];
  String selectedBrand = 'All'; // الديفولت هو All

  Future<void> fetchHomeData() async {
    await _catalogSubscription?.cancel();
    emit(HomeLoading());
    _catalogSubscription = _repository.watchCatalog().listen(
      (catalog) {
        _allProducts = catalog.products;
        _brands = catalog.brands;
        if (!_brands.any((brand) => brand.title == selectedBrand)) {
          selectedBrand = 'All';
        }
        _emitFilteredProducts();
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!isClosed && _allProducts.isEmpty) {
          emit(const HomeError('Could not load products. Please try again.'));
        }
      },
    );
  }

  void changeBrand(String brandTitle) {
    selectedBrand = brandTitle;
    _emitFilteredProducts();
  }

  void _emitFilteredProducts() {
    final filteredList = selectedBrand == 'All'
        ? _allProducts
        : _allProducts
              .where((product) => product.category == selectedBrand)
              .toList();

    // التقسيم لـ Popular و New Arrivals
    final popular = filteredList.where((p) => p.isBestSeller).toList();
    final newArrivals = filteredList.where((p) => !p.isBestSeller).toList();

    emit(
      HomeLoaded(
        brands: _brands,
        selectedBrand: selectedBrand,
        popularProducts: popular,
        newArrivalProducts: newArrivals,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _catalogSubscription?.cancel();
    return super.close();
  }
}

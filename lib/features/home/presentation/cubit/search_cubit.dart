import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/core/utils/cache_helper.dart';
import 'package:kicksvibe/features/home/data/models/product_model.dart';
import 'package:kicksvibe/features/home/domain/repositories/home_repository.dart';

part 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  final CacheHelper _cacheHelper;
  final HomeRepository _homeRepository;

  List<ProductModel> _allProducts = [];
  StreamSubscription? _catalogSubscription;

  SearchCubit(this._cacheHelper, this._homeRepository)
    : super(const SearchState()) {
    _initSearch();
  }

  void _initSearch() {
    final recents = _cacheHelper.getStringList('recent_searches');
    emit(state.copyWith(recentSearches: recents));

    emit(state.copyWith(isLoading: true));
    _catalogSubscription = _homeRepository.watchCatalog().listen((catalog) {
      _allProducts = catalog.products;
      if (!isClosed) emit(state.copyWith(isLoading: false));
    });
  }

  void onSearchQueryChanged(String query) {
    if (query.trim().isEmpty) {
      emit(state.copyWith(searchQuery: query, searchResults: []));
      return;
    }
    _applySearchAndFilters(query: query);
  }

  void onSearchSubmitted(String query) {
    if (query.trim().isEmpty) return;

    final currentSearches = List<String>.from(state.recentSearches);
    currentSearches.remove(query.trim());
    currentSearches.insert(0, query.trim());
    if (currentSearches.length > 10) currentSearches.removeLast();

    _cacheHelper.setStringList('recent_searches', currentSearches);
    emit(state.copyWith(recentSearches: currentSearches));
    _applySearchAndFilters(query: query);
  }

  void removeRecentSearch(String query) {
    final currentSearches = List<String>.from(state.recentSearches);
    currentSearches.remove(query);
    _cacheHelper.setStringList('recent_searches', currentSearches);
    emit(state.copyWith(recentSearches: currentSearches));
  }

  void updateFilters({
    String? gender,
    String? size,
    double? minPrice,
    double? maxPrice,
  }) {
    emit(
      state.copyWith(
        selectedGender: gender,
        selectedSize: size,
        minPrice: minPrice,
        maxPrice: maxPrice,
      ),
    );
    _applySearchAndFilters();
  }

  void resetFilters() {
    emit(
      state.copyWith(
        selectedGender: 'Men',
        selectedSize: 'US 5.5',
        minPrice: 0.0,
        maxPrice: 5000.0, // تم رفع الحد الأقصى ليشمل كل منتجاتك
      ),
    );
    _applySearchAndFilters();
  }

  void _applySearchAndFilters({String? query}) {
    final activeQuery = (query ?? state.searchQuery).toLowerCase();

    final results = _allProducts.where((product) {
      final matchName = product.name.toLowerCase().contains(activeQuery);
      final matchPrice =
          product.price >= state.minPrice && product.price <= state.maxPrice;
      return matchName && matchPrice;
    }).toList();

    emit(state.copyWith(searchQuery: activeQuery, searchResults: results));
  }

  @override
  Future<void> close() {
    _catalogSubscription?.cancel();
    return super.close();
  }
}

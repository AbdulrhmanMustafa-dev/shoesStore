part of 'search_cubit.dart';

class SearchState {
  final List<String> recentSearches;
  final List<ProductModel> searchResults;
  final bool isLoading;
  final String searchQuery;

  final String selectedGender;
  final String selectedSize;
  final double minPrice;
  final double maxPrice;

  const SearchState({
    this.recentSearches = const [],
    this.searchResults = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.selectedGender = 'Men',
    this.selectedSize = 'US 5.5',
    this.minPrice = 0.0,
    this.maxPrice = 5000.0,
  });

  SearchState copyWith({
    List<String>? recentSearches,
    List<ProductModel>? searchResults,
    bool? isLoading,
    String? searchQuery,
    String? selectedGender,
    String? selectedSize,
    double? minPrice,
    double? maxPrice,
  }) {
    return SearchState(
      recentSearches: recentSearches ?? this.recentSearches,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedSize: selectedSize ?? this.selectedSize,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }
}

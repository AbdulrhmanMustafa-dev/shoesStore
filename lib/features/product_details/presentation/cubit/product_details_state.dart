part of 'product_details_cubit.dart';

class ProductDetailsState {
  final int selectedImageIndex; // خاص بدوران الـ 3D
  final int selectedColorIndex; // خاص بالـ Gallery
  final int selectedSizeIndex;
  final bool isAddingToCart;
  final ProductCartResult? cartResult;

  const ProductDetailsState({
    this.selectedImageIndex = 0,
    this.selectedColorIndex = 0,
    this.selectedSizeIndex = 0,
    this.isAddingToCart = false,
    this.cartResult,
  });

  ProductDetailsState copyWith({
    int? selectedImageIndex,
    int? selectedColorIndex,
    int? selectedSizeIndex,
    bool? isAddingToCart,
    ProductCartResult? cartResult,
    bool clearCartResult = false,
  }) {
    return ProductDetailsState(
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      selectedColorIndex: selectedColorIndex ?? this.selectedColorIndex,
      selectedSizeIndex: selectedSizeIndex ?? this.selectedSizeIndex,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
      cartResult: clearCartResult ? null : cartResult ?? this.cartResult,
    );
  }
}

enum ProductCartResult { added, sizeUnavailable, failed }

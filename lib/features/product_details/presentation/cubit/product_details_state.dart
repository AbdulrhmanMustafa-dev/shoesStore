part of 'product_details_cubit.dart';

class ProductDetailsState {
  final int selectedImageIndex; // خاص بدوران الـ 3D
  final int selectedColorIndex; // خاص بالـ Gallery
  final int selectedSizeIndex;

  const ProductDetailsState({
    this.selectedImageIndex = 0,
    this.selectedColorIndex = 0,
    this.selectedSizeIndex = 0,
  });

  ProductDetailsState copyWith({
    int? selectedImageIndex,
    int? selectedColorIndex,
    int? selectedSizeIndex,
  }) {
    return ProductDetailsState(
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      selectedColorIndex: selectedColorIndex ?? this.selectedColorIndex,
      selectedSizeIndex: selectedSizeIndex ?? this.selectedSizeIndex,
    );
  }
}

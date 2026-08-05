part of 'product_details_cubit.dart';

class ProductDetailsState {
  final int selectedImageIndex; // خاص بدوران الـ 3D
  final int selectedColorIndex; // خاص بالـ Gallery
  final int selectedSizeIndex;

  ProductDetailsState({
    this.selectedImageIndex = 0,
    this.selectedColorIndex = 0,
    this.selectedSizeIndex = 0,
  });
}

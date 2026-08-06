import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'product_details_state.dart';

@injectable
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(const ProductDetailsState());

  // لتحديث دوران الـ 3D
  void changeImage(int index) {
    if (index == state.selectedImageIndex) return;
    emit(state.copyWith(selectedImageIndex: index));
  }

  // لتحديث اختيار اللون من الـ Gallery
  void changeColor(int index) {
    if (index == state.selectedColorIndex) return;
    emit(state.copyWith(selectedColorIndex: index));
  }

  void changeSize(int index) {
    if (index == state.selectedSizeIndex) return;
    emit(state.copyWith(selectedSizeIndex: index));
  }
}

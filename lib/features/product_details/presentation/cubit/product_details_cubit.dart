import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'product_details_state.dart';

@injectable
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsState());

  // لتحديث دوران الـ 3D
  void changeImage(int index) {
    emit(
      ProductDetailsState(
        selectedImageIndex: index,
        selectedColorIndex: state.selectedColorIndex,
        selectedSizeIndex: state.selectedSizeIndex,
      ),
    );
  }

  // لتحديث اختيار اللون من الـ Gallery
  void changeColor(int index) {
    emit(
      ProductDetailsState(
        selectedImageIndex: state
            .selectedImageIndex, // يمكنك تصفيرها لـ 0 لو حابب الـ 3D يرجع للأول مع تغيير اللون
        selectedColorIndex: index,
        selectedSizeIndex: state.selectedSizeIndex,
      ),
    );
  }

  void changeSize(int index) {
    emit(
      ProductDetailsState(
        selectedImageIndex: state.selectedImageIndex,
        selectedColorIndex: state.selectedColorIndex,
        selectedSizeIndex: index,
      ),
    );
  }
}

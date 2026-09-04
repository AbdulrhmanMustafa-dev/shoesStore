import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/features/home/data/models/product_model.dart';
import 'package:kicksvibe/features/product_details/domain/usecases/add_product_to_cart.dart';

part 'product_details_state.dart';

@injectable
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(this._addProductToCart)
    : super(const ProductDetailsState());

  final AddProductToCart _addProductToCart;

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

  Future<void> addToCart(ProductModel product) async {
    if (state.isAddingToCart) return;
    emit(state.copyWith(isAddingToCart: true, clearCartResult: true));
    try {
      await _addProductToCart(product, state.selectedSizeIndex);
      emit(
        state.copyWith(
          isAddingToCart: false,
          cartResult: ProductCartResult.added,
        ),
      );
    } on ProductSizeUnavailableException {
      emit(
        state.copyWith(
          isAddingToCart: false,
          cartResult: ProductCartResult.sizeUnavailable,
        ),
      );
    } on Object {
      emit(
        state.copyWith(
          isAddingToCart: false,
          cartResult: ProductCartResult.failed,
        ),
      );
    }
  }
}

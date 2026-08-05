import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'product_details_state.dart';

@injectable
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsState());

  void changeImage(int index) {
    emit(
      ProductDetailsState(
        selectedImageIndex: index,
        selectedSizeIndex: state.selectedSizeIndex,
      ),
    );
  }

  void changeSize(int index) {
    emit(
      ProductDetailsState(
        selectedImageIndex: state.selectedImageIndex,
        selectedSizeIndex: index,
      ),
    );
  }
}

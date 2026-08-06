import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/widgets/cached_product_image.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
import 'package:kicksvibe/features/product_details/presentation/cubit/product_details_cubit.dart';

class ProductGallery extends StatelessWidget {
  final ProductModel product;
  final PageController pageController;

  const ProductGallery({
    super.key,
    required this.product,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final has3D = product.rotationImages.isNotEmpty;
    final itemCount = product.images.length + (has3D ? 1 : 0);

    return SizedBox(
      height: 60,
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final is3DItem = has3D && index == 0;
            final imageUrl = is3DItem
                ? product.rotationImages.first
                : product.images[has3D ? index - 1 : index];
            final isSelected = state.selectedColorIndex == index;

            return GestureDetector(
              onTap: () {
                context.read<ProductDetailsCubit>().changeColor(index);
                if (!is3DItem && pageController.hasClients) {
                  pageController.jumpToPage(has3D ? index - 1 : index);
                }
              },
              child: Container(
                width: 60,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF5A9AE5)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CachedProductImage(imageUrl: imageUrl, fit: BoxFit.contain),
                    if (is3DItem)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(102),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.threed_rotation,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

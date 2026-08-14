import 'package:flutter/material.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
import 'package:kicksvibe/features/product_details/presentation/widgets/product_gallery.dart';
import 'package:kicksvibe/features/product_details/presentation/widgets/product_size_selector.dart';

class ProductDetailsContent extends StatelessWidget {
  final ProductModel product;
  final PageController pageController;

  const ProductDetailsContent({
    super.key,
    required this.product,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.isBestSeller)
            const Text(
              'BEST SELLER',
              style: TextStyle(
                color: Color(0xFF5A9AE5),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2832),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${product.price}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E2832),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.description,
            style: const TextStyle(
              color: Colors.grey,
              height: 1.5,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Gallery',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2832),
            ),
          ),
          const SizedBox(height: 12),
          ProductGallery(product: product, pageController: pageController),
          const SizedBox(height: 24),
          const ProductSizeHeader(),
          const SizedBox(height: 12),
          ProductSizeSelector(product: product),
        ],
      ),
    );
  }
}

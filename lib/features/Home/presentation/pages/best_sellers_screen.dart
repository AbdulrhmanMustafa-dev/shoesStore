import 'package:flutter/material.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';
import 'package:kicksvibe/core/widgets/custom_back_button.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
import 'package:kicksvibe/features/Home/presentation/widgets/shoe_card.dart';

class BestSellersScreen extends StatelessWidget {
  final List<ProductModel> products;

  const BestSellersScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(onTap: () => Navigator.pop(context)),
                  const Text(
                    'Best Sellers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2832),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {}, // Filter Action
                        child: const Icon(
                          Icons.tune_rounded,
                          color: Color(0xFF1E2832),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {}, // Search Action
                        child: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF1E2832),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Products Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio:
                      0.68, // لضبط نسبة العرض للطول لتطابق الكارت في الصورة
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.productDetails,
                        arguments: product,
                      );
                    },
                    child: ShoeCard(product: product),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

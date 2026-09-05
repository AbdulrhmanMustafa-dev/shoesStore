import 'package:flutter/material.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';
import 'package:kicksvibe/core/widgets/custom_back_button.dart';
import 'package:kicksvibe/features/home/data/models/product_model.dart';
import 'package:kicksvibe/features/home/presentation/widgets/filter_bottom_sheet.dart';
import 'package:kicksvibe/features/home/presentation/widgets/shoe_card.dart';

class BestSellersScreen extends StatelessWidget {
  final List<ProductModel> products;

  const BestSellersScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                  Text(
                    'Best Sellers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true, // لتجنب مشاكل الحجم
                            backgroundColor: Colors
                                .transparent, // لجعل الحواف العلوية تظهر بشكل دائري
                            builder: (context) => const FilterBottomSheet(),
                          );
                        }, // Filter Action
                        child: Icon(
                          Icons.tune_rounded,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.search);
                        }, // Search Action
                        child: Icon(
                          Icons.search_rounded,
                          color: Theme.of(context).colorScheme.onSurface,
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

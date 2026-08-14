import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';
import 'package:kicksvibe/core/widgets/custom_back_button.dart';
import 'package:kicksvibe/features/favourite/presentation/cubit/favourite_cubit.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

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
                    'Favourite',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2832),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.cart);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shopping_bag_outlined, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // Grid View المربوط بالـ Cubit
            Expanded(
              child: BlocBuilder<FavoriteCubit, FavoriteState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.errorMessage != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          state.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  if (state.favoriteProducts.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Favorite Shoes Yet!',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio:
                              0.75, // لضبط طول الكارت ليتناسب مع الصورة
                        ),
                    itemCount: state.favoriteProducts.length,
                    itemBuilder: (context, index) {
                      final product = state.favoriteProducts[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to product details page
                          Navigator.pushNamed(
                            context,
                            AppRoutes.productDetails,
                            arguments: product,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // أيقونة القلب للإزالة
                              GestureDetector(
                                onTap: () => context
                                    .read<FavoriteCubit>()
                                    .toggleFavorite(product),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF8F9FA),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Colors.redAccent,
                                    size: 16,
                                  ),
                                ),
                              ),

                              // الصورة
                              Expanded(
                                child: Center(
                                  child: Image.network(
                                    product.images.isNotEmpty
                                        ? product.images.first
                                        : '',
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.broken_image,
                                              color: Colors.grey,
                                            ),
                                  ),
                                ),
                              ),

                              // التفاصيل
                              if (product.isBestSeller)
                                const Text(
                                  'BEST SELLER',
                                  style: TextStyle(
                                    color: Color(0xFF5A9AE5),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${product.price}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  // الدوائر اللونية الوهمية لتطابق الـ UI
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 6,
                                        backgroundColor: Colors.yellow.shade300,
                                      ),
                                      const SizedBox(width: 4),
                                      const CircleAvatar(
                                        radius: 6,
                                        backgroundColor: Colors.tealAccent,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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

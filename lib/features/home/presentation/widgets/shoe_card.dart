import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';
import 'package:kicksvibe/core/widgets/cached_product_image.dart';
import 'package:kicksvibe/features/home/data/models/product_model.dart';
import 'package:kicksvibe/features/favourite/presentation/cubit/favourite_cubit.dart';

class ShoeCard extends StatefulWidget {
  final ProductModel product;
  const ShoeCard({super.key, required this.product});

  @override
  State<ShoeCard> createState() => _ShoeCardState();
}

class _ShoeCardState extends State<ShoeCard> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  // 💡 نصيحة سينير: دالة تقليب الصور تلقائياً كل 3 ثواني
  void _startAutoScroll() {
    if (widget.product.images.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < widget.product.images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // ارجع لأول صورة لو وصلنا للآخر
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // 💡 نصيحة سينير: لازم نقفل الـ Timer والـ Controller عشان نتجنب الـ Memory Leaks
  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.productDetails,
          arguments: widget.product,
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // السلايدر الخاص بالصور
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: widget.product.images.isNotEmpty
                        ? widget.product.images.length
                        : 1,
                    itemBuilder: (context, index) {
                      if (widget.product.images.isEmpty) {
                        return const Icon(Icons.broken_image);
                      }
                      return CachedProductImage(
                        imageUrl: widget.product.images[index],
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                  // مؤشر النقاط (Dots Indicator) أسفل الصور
                  if (widget.product.images.length > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.product.images.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: _currentPage == index ? 8 : 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: BlocSelector<FavoriteCubit, FavoriteState, bool>(
                      selector: (state) => state.favoriteProducts.any(
                        (product) => product.id == widget.product.id,
                      ),
                      builder: (context, isFavorite) => IconButton(
                        tooltip: isFavorite
                            ? 'Remove from favourites'
                            : 'Add to favourites',
                        onPressed: () => context
                            .read<FavoriteCubit>()
                            .toggleFavorite(widget.product),
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (widget.product.isBestSeller)
              Text(
                'BEST SELLER',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              widget.product.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${widget.product.price}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

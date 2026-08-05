import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/widgets/CustomBackButton.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
import 'package:kicksvibe/features/product_details/presentation/cubit/product_details_cubit.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  // دالة التقليب التلقائي كل 3 ثواني
  void _startAutoScroll() {
    if (widget.product.images.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      // نقرأ الـ Index الحالي من الكيوبت مباشرة
      int currentIndex = context
          .read<ProductDetailsCubit>()
          .state
          .selectedImageIndex;

      if (currentIndex < widget.product.images.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      bottomNavigationBar: _buildBottomBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(onTap: () => Navigator.pop(context)),
                    const Text(
                      'Men\'s Shoes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2832),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shopping_bag_outlined, size: 20),
                    ),
                  ],
                ),
              ),

              // 1. قسم الصورة الرئيسية (PageView مربوط بالـ Cubit)
              BlocListener<ProductDetailsCubit, ProductDetailsState>(
                listener: (context, state) {
                  // هذا الـ Listener يتأكد أنه إذا ضغط المستخدم على صورة من الـ Gallery، الـ PageView يذهب إليها
                  if (_pageController.hasClients &&
                      _pageController.page?.round() !=
                          state.selectedImageIndex) {
                    _pageController.animateToPage(
                      state.selectedImageIndex,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: SizedBox(
                  height: 220,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      // تحديث الكيوبت عند التقليب اليدوي أو التلقائي
                      context.read<ProductDetailsCubit>().changeImage(index);
                    },
                    itemCount: widget.product.images.isNotEmpty
                        ? widget.product.images.length
                        : 1,
                    itemBuilder: (context, index) {
                      final imageUrl = widget.product.images.isNotEmpty
                          ? widget.product.images[index]
                          : '';
                      return Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // مؤشر النقاط (Dots)
              if (widget.product.images.length > 1) const SizedBox(height: 16),
              if (widget.product.images.length > 1)
                BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.product.images.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: state.selectedImageIndex == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: state.selectedImageIndex == index
                                ? const Color(0xFF5A9AE5)
                                : const Color(0xFFD3E0F2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 24),

              // 2. صندوق التفاصيل
              Container(
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
                    if (widget.product.isBestSeller)
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
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2832),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${widget.product.price}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E2832),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.product.description,
                      style: const TextStyle(
                        color: Colors.grey,
                        height: 1.5,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Gallery
                    const Text(
                      'Gallery',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2832),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 60,
                      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                        builder: (context, state) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.product.images.length,
                            itemBuilder: (context, index) {
                              final isSelected =
                                  state.selectedImageIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  // عند الضغط سيقوم الـ BlocListener في الأعلى بتحريك الـ PageView
                                  context
                                      .read<ProductDetailsCubit>()
                                      .changeImage(index);
                                },
                                child: Container(
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
                                  child: Image.network(
                                    widget.product.images[index],
                                    width: 60,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Size
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Size',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E2832),
                          ),
                        ),
                        Row(
                          children: const [
                            Text(
                              'EU',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E2832),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('US', style: TextStyle(color: Colors.grey)),
                            SizedBox(width: 8),
                            Text('UK', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 50,
                      child:
                          BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                            builder: (context, state) {
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.product.sizes.length,
                                itemBuilder: (context, index) {
                                  final isSelected =
                                      state.selectedSizeIndex == index;
                                  return GestureDetector(
                                    onTap: () => context
                                        .read<ProductDetailsCubit>()
                                        .changeSize(index),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      margin: const EdgeInsets.only(right: 12),
                                      width: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF5A9AE5)
                                            : const Color(0xFFF8F9FA),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        widget.product.sizes[index].toString(),
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  '\$${widget.product.price}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2832),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5A9AE5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Add To Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

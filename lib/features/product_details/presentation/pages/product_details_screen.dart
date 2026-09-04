import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/features/home/data/models/product_model.dart';
import 'package:kicksvibe/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:kicksvibe/features/product_details/presentation/widgets/product_bottom_bar.dart';
import 'package:kicksvibe/features/product_details/presentation/widgets/product_details_content.dart';
import 'package:kicksvibe/features/product_details/presentation/widgets/product_details_header.dart';
import 'package:kicksvibe/features/product_details/presentation/widgets/product_media_viewer.dart';
import 'package:kicksvibe/features/product_details/presentation/cubit/product_details_cubit.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductDetailsCubit, ProductDetailsState>(
      listenWhen: (previous, current) =>
          previous.cartResult != current.cartResult,
      listener: (context, state) {
        // 💡 التحديث: إجبار السلة على قراءة البيانات الجديدة
        if (state.cartResult == ProductCartResult.added) {
          context.read<CartCubit>().loadCart();
        }

        final message = switch (state.cartResult) {
          ProductCartResult.added => 'Added to cart!',
          ProductCartResult.sizeUnavailable =>
            'This product has no available size.',
          ProductCartResult.failed => 'Could not add this item to the cart.',
          null => null,
        };

        if (message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        bottomNavigationBar: ProductBottomBar(product: widget.product),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProductDetailsHeader(),
                ProductMediaViewer(
                  product: widget.product,
                  pageController: _pageController,
                ),
                const SizedBox(height: 24),
                ProductDetailsContent(
                  product: widget.product,
                  pageController: _pageController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

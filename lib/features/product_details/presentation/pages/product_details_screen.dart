import 'package:flutter/material.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
import 'package:kicksvibe/features/product_details/presentation/widgets/product_bottom_bar.dart';
import 'package:kicksvibe/features/product_details/presentation/widgets/product_details_content.dart';
import 'package:kicksvibe/features/product_details/presentation/widgets/product_details_header.dart';
import 'package:kicksvibe/features/product_details/presentation/widgets/product_media_viewer.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
    );
  }
}

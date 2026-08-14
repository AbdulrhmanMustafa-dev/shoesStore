import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
import 'package:kicksvibe/features/product_details/presentation/cubit/product_details_cubit.dart';

class ProductBottomBar extends StatelessWidget {
  final ProductModel product;

  const ProductBottomBar({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
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
                  '\$${product.price}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2832),
                  ),
                ),
              ],
            ),
            BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
              buildWhen: (previous, current) =>
                  previous.isAddingToCart != current.isAddingToCart,
              builder: (context, state) => ElevatedButton(
                onPressed: state.isAddingToCart
                    ? null
                    : () => context.read<ProductDetailsCubit>().addToCart(
                        product,
                      ),
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
                child: state.isAddingToCart
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Add To Cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

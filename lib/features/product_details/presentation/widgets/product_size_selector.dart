import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
import 'package:kicksvibe/features/product_details/presentation/cubit/product_details_cubit.dart';

class ProductSizeHeader extends StatelessWidget {
  const ProductSizeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Size',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2832),
          ),
        ),
        Row(
          children: [
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
    );
  }
}

class ProductSizeSelector extends StatelessWidget {
  final ProductModel product;

  const ProductSizeSelector({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: product.sizes.length,
          itemBuilder: (context, index) {
            final isSelected = state.selectedSizeIndex == index;
            return GestureDetector(
              onTap: () => context.read<ProductDetailsCubit>().changeSize(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
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
                  product.sizes[index].toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

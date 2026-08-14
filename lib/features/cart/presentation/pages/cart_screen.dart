import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/widgets/custom_back_button.dart';
import 'package:kicksvibe/features/cart/presentation/cubit/cart_cubit.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
                    'My Cart',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2832),
                    ),
                  ),
                  const SizedBox(width: 44), // للتوازن مع زر الرجوع
                ],
              ),
            ),

            // Cart Items List
            Expanded(
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  if (state.cartItems.isEmpty) {
                    return const Center(
                      child: Text(
                        'Your Cart is Empty',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = state.cartItems[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          children: [
                            // Product Image
                            Container(
                              width: 85,
                              height: 85,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Image.network(
                                item.product.images.isNotEmpty
                                    ? item.product.images.first
                                    : '',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Product Details & Controls
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.product.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E2832),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        item.selectedSize,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E2832),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${item.product.price}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E2832),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Quantity Controls & Delete
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () => context
                                                .read<CartCubit>()
                                                .decrementQuantity(item.id),
                                            child: const Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.grey,
                                              size: 24,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            child: Text(
                                              '${item.quantity}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => context
                                                .read<CartCubit>()
                                                .incrementQuantity(item.id),
                                            child: const Icon(
                                              Icons.add_circle,
                                              color: Color(0xFF5A9AE5),
                                              size: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () => context
                                            .read<CartCubit>()
                                            .removeFromCart(item.id),
                                        child: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.redAccent,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Bottom Summary Sheet
            _buildBottomSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSummary() {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state.cartItems.isEmpty) return const SizedBox();

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '\$${state.subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2832),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Shopping',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ), // كما في التصميم
                  Text(
                    '\$${state.shippingCost.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2832),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Dotted Line
              CustomPaint(
                painter: DottedLinePainter(),
                child: const SizedBox(width: double.infinity, height: 1),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Cost',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2832),
                    ),
                  ),
                  Text(
                    '\$${state.totalCost.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A9AE5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {}, // Checkout Logic
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A9AE5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Checkout',
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
        );
      },
    );
  }
}

// أداة لرسم الخط المنقط بدلاً من استخدام حزم خارجية
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;
    var max = size.width;
    var dashWidth = 5.0;
    var dashSpace = 3.0;
    double startX = 0;
    while (startX < max) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/localization/app_localizations.dart';
import 'package:kicksvibe/core/widgets/custom_back_button.dart';
import 'package:kicksvibe/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:kicksvibe/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:kicksvibe/features/cart/presentation/widgets/cart_summary.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(onTap: () => Navigator.pop(context)),
                  Text(
                    context.l10n.cart,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  if (state.cartItems.isEmpty) {
                    return Center(
                      child: Text(
                        context.l10n.cartEmpty,
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = state.cartItems[index];
                      final cartCubit = context.read<CartCubit>();
                      return CartItemCard(
                        item: item,
                        onRemove: () => cartCubit.removeFromCart(item.id),
                        onIncrease: () => cartCubit.incrementQuantity(item.id),
                        onDecrease: () => cartCubit.decrementQuantity(item.id),
                      );
                    },
                  );
                },
              ),
            ),
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) => CartSummary(state: state),
            ),
          ],
        ),
      ),
    );
  }
}

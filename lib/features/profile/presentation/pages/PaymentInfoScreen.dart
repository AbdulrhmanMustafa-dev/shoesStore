import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/widgets/custom_back_button.dart';
import 'package:kicksvibe/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:kicksvibe/features/profile/presentation/widgets/payment_method_card.dart';

class PaymentInfoScreen extends StatelessWidget {
  const PaymentInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ElevatedButton(
            onPressed: () {
              // TODO: برمجة إضافة كارت جديد
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Add New Card',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  CustomBackButton(onTap: () => Navigator.pop(context)),
                  Expanded(
                    child: Text(
                      'Payment Info',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),
            Expanded(
              // سحب طرق الدفع المستخدمة مسبقاً
              child: BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  final List<String> usedMethods = [];

                  if (state is OrdersLoaded) {
                    for (var order in state.orders) {
                      if (order.paymentMethod.isNotEmpty &&
                          !usedMethods.contains(order.paymentMethod)) {
                        usedMethods.add(order.paymentMethod);
                      }
                    }
                  }

                  if (usedMethods.isEmpty) {
                    return Center(
                      child: Text(
                        'No payment history found. Make an order!',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: usedMethods.length,
                    itemBuilder: (context, index) {
                      final method = usedMethods[index];
                      // نعتبر أحدث طريقة دفع (أول عنصر) هي الافتراضية
                      final isDefault = index == 0;
                      return PaymentMethodCard(
                        method: method,
                        isDefault: isDefault,
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

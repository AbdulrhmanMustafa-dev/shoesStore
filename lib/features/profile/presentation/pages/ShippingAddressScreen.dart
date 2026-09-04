import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/di/injection.dart';
import 'package:kicksvibe/core/utils/cache_helper.dart';
import 'package:kicksvibe/core/widgets/custom_back_button.dart';
import 'package:kicksvibe/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:kicksvibe/features/profile/presentation/widgets/address_card.dart';

class ShippingAddressScreen extends StatelessWidget {
  const ShippingAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب آخر عنوان تم استخدامه من الكاش
    final lastAddress = getIt<CacheHelper>().getLastCheckoutAddress();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ElevatedButton(
            onPressed: () {
              // TODO: برمجة إضافة عنوان جديد يدوياً
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Add New Address',
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
                      'Shipping Address',
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
              // استخدام OrdersCubit لاستخراج العناوين من الطلبات السابقة
              child: BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  final List<String> addresses = [];

                  // 1. إضافة عنوان الكاش ليكون أول عنصر (Default)
                  if (lastAddress != null && lastAddress.isNotEmpty) {
                    addresses.add(lastAddress);
                  }

                  // 2. تجميع كل العناوين غير المكررة من الطلبات
                  if (state is OrdersLoaded) {
                    for (var order in state.orders) {
                      if (order.address.isNotEmpty &&
                          !addresses.contains(order.address)) {
                        addresses.add(order.address);
                      }
                    }
                  }

                  if (addresses.isEmpty) {
                    return Center(
                      child: Text(
                        'No addresses found. Make an order to save one!',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      // نعتبر العنوان مطابق للكاش هو الافتراضي
                      final isDefault = address == lastAddress;
                      final title = isDefault
                          ? 'Default / Recent'
                          : 'Address ${index + 1}';

                      return AddressCard(
                        title: title,
                        address: address,
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

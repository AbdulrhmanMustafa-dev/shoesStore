import 'package:flutter/material.dart';

class OrderStatusHeader extends StatelessWidget {
  final String orderId;
  final String date;
  final String status;

  const OrderStatusHeader({
    super.key,
    required this.orderId,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order #$orderId',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              date,
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Status: $status',
          style: TextStyle(
            color: status == 'Processing' ? colors.tertiary : colors.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

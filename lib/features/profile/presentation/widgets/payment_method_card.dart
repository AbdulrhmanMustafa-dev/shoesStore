import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  final String method;
  final bool isDefault;

  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.isDefault,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    var title = method;
    var subtitle = 'Linked Payment Method';
    var icon = Icons.credit_card;
    var iconColor = colors.onSurfaceVariant;
    switch (method) {
      case 'Visa':
        title = 'Visa Card';
        subtitle = '**** **** 0696 4629';
        iconColor = colors.primary;
      case 'Meeza':
        title = 'Meeza Card';
        subtitle = '**** **** 1234';
        icon = Icons.credit_card_outlined;
        iconColor = colors.secondary;
      case 'Instapay':
        title = 'InstaPay';
        subtitle = 'user@instapay';
        icon = Icons.send_to_mobile_rounded;
        iconColor = colors.tertiary;
      case 'Vodafone Cash':
        title = 'Vodafone Cash';
        subtitle = '010xxxxxxx';
        icon = Icons.phone_android_rounded;
        iconColor = colors.error;
      case 'Cash on Delivery':
        title = 'Cash on Delivery';
        subtitle = 'Pay when your order arrives';
        icon = Icons.payments_outlined;
        iconColor = colors.secondary;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: isDefault ? Border.all(color: colors.primary, width: 2) : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (isDefault)
            Icon(Icons.check_circle, color: colors.primary, size: 24),
        ],
      ),
    );
  }
}

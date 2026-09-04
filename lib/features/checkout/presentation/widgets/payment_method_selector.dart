import 'package:flutter/material.dart';
import 'package:kicksvibe/core/utils/AppTest.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final String currentPhone;
  final ValueChanged<String> onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.currentPhone,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = _paymentMethodItems(context);
    final selected = items.any((item) => item.value == selectedMethod)
        ? selectedMethod
        : 'Cash on Delivery';
    final colorScheme = Theme.of(context).colorScheme;
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selected,
        isExpanded: true,
        itemHeight: 70,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: colorScheme.onSurfaceVariant,
        ),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
        items: items,
      ),
    );
  }

  List<DropdownMenuItem<String>> _paymentMethodItems(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final phone =
        currentPhone.isEmpty || currentPhone == 'Add your phone number'
        ? 'Please add phone number above'
        : (Apptest.ifTest ? '01010101010 (Test Mode)' : currentPhone);
    return [
      _item(
        context,
        'Visa',
        'Visa Card',
        '**** **** 0696 4629',
        Icons.credit_card,
        colorScheme.primary,
      ),
      _item(
        context,
        'Meeza',
        'Meeza Card',
        '**** **** 1234',
        Icons.credit_card_outlined,
        colorScheme.tertiary,
      ),
      _item(
        context,
        'Instapay',
        'InstaPay',
        phone,
        Icons.send_to_mobile_rounded,
        colorScheme.secondary,
      ),
      _item(
        context,
        'Vodafone Cash',
        'Vodafone Cash',
        phone,
        Icons.phone_android_rounded,
        colorScheme.error,
      ),
      _item(
        context,
        'Cash on Delivery',
        'Cash on Delivery',
        'Pay when your order arrives',
        Icons.payments_outlined,
        colorScheme.primary,
      ),
    ];
  }

  DropdownMenuItem<String> _item(
    BuildContext context,
    String id,
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return DropdownMenuItem(
      value: id,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

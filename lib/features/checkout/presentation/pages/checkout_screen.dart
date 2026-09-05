import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/localization/app_localizations.dart';
import 'package:kicksvibe/core/di/injection.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';
import 'package:kicksvibe/core/utils/AppTest.dart';
import 'package:kicksvibe/core/utils/paymob_manager.dart';
import 'package:kicksvibe/core/widgets/custom_back_button.dart';
import 'package:kicksvibe/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:kicksvibe/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:kicksvibe/features/checkout/presentation/pages/payment_webview_screen.dart';
import 'package:kicksvibe/features/checkout/presentation/widgets/address_map_section.dart';
import 'package:kicksvibe/features/checkout/presentation/widgets/checkout_bottom_summary.dart';
import 'package:kicksvibe/features/checkout/presentation/widgets/checkout_section_container.dart';
import 'package:kicksvibe/features/checkout/presentation/widgets/contact_info_row.dart';
import 'package:kicksvibe/features/checkout/presentation/widgets/payment_method_selector.dart';
import 'package:kicksvibe/features/orders/data/models/order_model.dart';
import 'package:kicksvibe/features/orders/domain/repositories/orders_repository.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController
        .dispose(); // 💡 2. تدميره عند الخروج من شاشة الـ Checkout بالكامل
    super.dispose();
  }

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
                    context.l10n.checkout,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<CheckoutCubit, CheckoutState>(
                      builder: (context, state) => CheckoutSectionContainer(
                        title: context.l10n.contactInformation,
                        child: Column(
                          children: [
                            ContactInfoRow(
                              icon: Icons.email_outlined,
                              title: state.email,
                              subtitle: context.l10n.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            ContactInfoRow(
                              icon: Icons.phone_outlined,
                              title: state.phone,
                              subtitle: context.l10n.phone,
                              onEdit: () =>
                                  _showEditPhoneDialog(context, state.phone),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CheckoutSectionContainer(
                      title: context.l10n.address,
                      child: BlocConsumer<CheckoutCubit, CheckoutState>(
                        listenWhen: (previous, current) =>
                            previous.errorMessage != current.errorMessage,
                        listener: (context, state) {
                          if (state.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.errorMessage!),
                                backgroundColor: colors.error,
                              ),
                            );
                          }
                        },
                        builder: (context, state) => AddressMapSection(
                          address: state.address,
                          latitude: state.latitude,
                          longitude: state.longitude,
                          isFetchingLocation: state.isFetchingLocation,
                          onLocationPressed: context
                              .read<CheckoutCubit>()
                              .getCurrentLocation,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CheckoutSectionContainer(
                      title: context.l10n.paymentMethod,
                      child: BlocBuilder<CheckoutCubit, CheckoutState>(
                        builder: (context, state) => PaymentMethodSelector(
                          selectedMethod: state.paymentMethod,
                          currentPhone: state.phone,
                          onChanged: context
                              .read<CheckoutCubit>()
                              .changePaymentMethod,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            CheckoutBottomSummary(onPaymentPressed: _handlePaymentPressed),
          ],
        ),
      ),
    );
  }

  void _showEditPhoneDialog(BuildContext context, String currentPhone) {
    // 💡 3. تعيين النص قبل فتح الديالوج
    _phoneController.text = currentPhone == 'Add your phone number'
        ? ''
        : currentPhone;

    final checkoutCubit = context.read<CheckoutCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.editPhoneNumber),
        content: TextField(
          controller: _phoneController, // 💡 4. استخدام الـ Controller المحفوظ
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: context.l10n.enterPhoneNumber,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              checkoutCubit.updatePhone(_phoneController.text);
              Navigator.pop(dialogContext);
            },
            child: Text(
              context.l10n.save,
              style: TextStyle(
                color: Theme.of(dialogContext).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePaymentPressed() async {
    final colors = Theme.of(context).colorScheme;
    var progressOpen = false;
    final cart = context.read<CartCubit>().state;
    final checkout = context.read<CheckoutCubit>().state;
    if (cart.cartItems.isEmpty) {
      _showMessage('Your cart is empty.', colors.error);
      return;
    }
    if (checkout.phone.isEmpty || checkout.phone == 'Add your phone number') {
      _showMessage('Please enter a valid phone number first.', colors.error);
      return;
    }
    unawaited(_showProgressDialog());
    progressOpen = true;
    try {
      final method = checkout.paymentMethod;
      var success = method == 'Cash on Delivery';
      if (!success) {
        final payment = PaymobManager();
        final phone = Apptest.ifTest ? '01010101010' : checkout.phone;
        final token = await payment.getPaymentKey(
          amountInEgp: cart.totalCost,
          paymentMethod: method,
          email: checkout.email,
          phoneNumber: phone,
        );
        final url = method == 'Vodafone Cash' || method == 'Instapay'
            ? await payment.getWalletRedirectUrl(
                paymentToken: token,
                phoneNumber: phone,
              )
            : 'https://accept.paymob.com/api/acceptance/iframes/${PaymobManager.iframeId}?payment_token=$token';
        if (!mounted) return;
        Navigator.pop(context);
        progressOpen = false;
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentWebViewScreen(paymentUrl: url),
          ),
        );
        success = result == true;
        if (success && mounted) {
          unawaited(_showProgressDialog());
          progressOpen = true;
        }
      }
      if (success) {
        await getIt<OrdersRepository>().placeOrder(
          OrderModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            userId: FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
            items: cart.cartItems,
            totalCost: cart.totalCost,
            paymentMethod: checkout.paymentMethod,
            address: checkout.address,
            createdAt: DateTime.now(),
          ),
        );
        if (!mounted) return;
        await context.read<CartCubit>().clearCart();
        if (!mounted) return;
        if (progressOpen) Navigator.pop(context);
        _showMessage('Payment Successful! Order Placed', colors.secondary);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => false,
        );
      } else if (method != 'Cash on Delivery' && mounted) {
        if (progressOpen) Navigator.pop(context);
        _showMessage('Payment Failed or Cancelled.', colors.error);
      }
    } catch (error) {
      if (!mounted) return;
      if (progressOpen) Navigator.pop(context);
      _showMessage('Error: $error', colors.error);
    }
  }

  Future<void> _showProgressDialog() => showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}

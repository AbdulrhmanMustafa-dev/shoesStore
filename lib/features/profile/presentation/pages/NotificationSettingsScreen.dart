import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/localization/app_localizations.dart';
import 'package:kicksvibe/core/widgets/custom_back_button.dart';
import 'package:kicksvibe/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:kicksvibe/features/profile/presentation/widgets/notification_toggle.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                      context.l10n.notificationSetting,
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    final cubit = context.read<ProfileCubit>();
                    return Column(
                      children: [
                        NotificationToggle(
                          title: context.l10n.generalNotification,
                          value: state.isGeneralNotificationEnabled,
                          onChanged: cubit.toggleGeneralNotification,
                        ),
                        NotificationToggle(
                          title: context.l10n.sound,
                          value: state.isSoundEnabled,
                          onChanged: cubit.toggleSound,
                        ),
                        NotificationToggle(
                          title: context.l10n.vibrate,
                          value: state.isVibrateEnabled,
                          onChanged: cubit.toggleVibrate,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            height: 1,
                          ),
                        ),
                        NotificationToggle(
                          title: context.l10n.specialOffers,
                          value: state.isSpecialOffersEnabled,
                          onChanged: cubit.toggleSpecialOffers,
                        ),
                        NotificationToggle(
                          title: context.l10n.promoDiscount,
                          value: state.isPromoDiscountEnabled,
                          onChanged: cubit.togglePromoDiscount,
                        ),
                        NotificationToggle(
                          title: context.l10n.payments,
                          value: state.isPaymentsEnabled,
                          onChanged: cubit.togglePaymentsNotification,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

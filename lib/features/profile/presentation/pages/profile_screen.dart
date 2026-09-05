import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/localization/app_localizations.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';
import 'package:kicksvibe/core/widgets/custom_back_button.dart';
import 'package:kicksvibe/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:kicksvibe/features/profile/presentation/widgets/profile_action_tile.dart';
import 'package:kicksvibe/features/profile/presentation/widgets/profile_switch_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final l10n = context.l10n;
    final userName = user?.displayName ?? l10n.userName;
    final userEmail = user?.email ?? l10n.noEmailLinked;
    final userImage = user?.photoURL;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
                      l10n.accountSettings,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.profileInfo,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.profileDetails);
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                colorScheme.surfaceContainerHighest,
                            backgroundImage: userImage != null
                                ? NetworkImage(userImage)
                                : null,
                            child: userImage == null
                                ? Icon(
                                    Icons.person,
                                    size: 30,
                                    color: colorScheme.onSurfaceVariant,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userEmail,
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    Text(
                      l10n.account,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ProfileActionTile(
                      icon: Icons.notifications_none,
                      title: l10n.notificationSetting,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.notificationSettings,
                      ),
                    ),
                    ProfileActionTile(
                      icon: Icons.local_shipping_outlined,
                      title: l10n.shippingAddress,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.shippingAddress,
                      ),
                    ),
                    ProfileActionTile(
                      icon: Icons.payment_outlined,
                      title: l10n.paymentInfo,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.paymentInfo),
                    ),
                    ProfileActionTile(
                      icon: Icons.delete_outline,
                      title: l10n.deleteAccount,
                      textColor: colorScheme.error,
                      onTap: () => _showDeleteConfirmation(context),
                    ),
                    const SizedBox(height: 32),

                    Text(
                      l10n.appSettings,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            ProfileSwitchTile(
                              title: l10n.enableFaceId,
                              value: state.isFaceIdEnabled,
                              onChanged: (val) => context
                                  .read<ProfileCubit>()
                                  .toggleFaceId(val),
                            ),
                            ProfileSwitchTile(
                              title: l10n.enablePushNotifications,
                              value: state.isPushNotificationsEnabled,
                              onChanged: (val) => context
                                  .read<ProfileCubit>()
                                  .togglePushNotifications(val),
                            ),
                            ProfileSwitchTile(
                              title: l10n.enableLocationServices,
                              value: state.isLocationEnabled,
                              onChanged: (val) => context
                                  .read<ProfileCubit>()
                                  .toggleLocation(val),
                            ),
                            ProfileSwitchTile(
                              title: l10n.darkMode,
                              value: state.isDarkMode,
                              onChanged: (val) => context
                                  .read<ProfileCubit>()
                                  .toggleDarkMode(val),
                            ),
                            ProfileActionTile(
                              icon: Icons.language,
                              title: l10n.language,
                              onTap: () => _showLanguagePicker(context),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.deleteAccount),
        content: Text(context.l10n.deleteAccountQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.currentUser?.delete();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                }
              } catch (e) {
                if (!ctx.mounted) return;
                Navigator.pop(ctx);
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text(context.l10n.deleteAccountError)),
                );
              }
            },
            child: Text(
              context.l10n.delete,
              style: TextStyle(color: Theme.of(ctx).colorScheme.onError),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ProfileCubit>();
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.language),
              leading: const Icon(Icons.language),
            ),
            for (final option in [
              (const Locale('en'), l10n.english),
              (const Locale('ar'), l10n.arabic),
              (const Locale('fr'), l10n.french),
            ])
              RadioListTile<Locale>(
                title: Text(option.$2),
                value: option.$1,
                groupValue: cubit.state.locale,
                onChanged: (locale) {
                  if (locale == null) return;
                  cubit.setLocale(locale);
                  Navigator.pop(sheetContext);
                },
              ),
          ],
        ),
      ),
    );
  }
}

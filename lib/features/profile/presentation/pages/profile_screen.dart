import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final userName = user?.displayName ?? 'User Name';
    final userEmail = user?.email ?? 'No email linked';
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
                      'Account & Settings',
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
                    const Text(
                      'Profile Info',
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

                    const Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ProfileActionTile(
                      icon: Icons.notifications_none,
                      title: 'Notification Setting',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.notificationSettings,
                      ),
                    ),
                    ProfileActionTile(
                      icon: Icons.local_shipping_outlined,
                      title: 'Shipping Address',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.shippingAddress,
                      ),
                    ),
                    ProfileActionTile(
                      icon: Icons.payment_outlined,
                      title: 'Payment Info',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.paymentInfo),
                    ),
                    ProfileActionTile(
                      icon: Icons.delete_outline,
                      title: 'Delete Account',
                      textColor: colorScheme.error,
                      onTap: () => _showDeleteConfirmation(context),
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      'App Settings',
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
                              title: 'Enable Face ID For Log In',
                              value: state.isFaceIdEnabled,
                              onChanged: (val) => context
                                  .read<ProfileCubit>()
                                  .toggleFaceId(val),
                            ),
                            ProfileSwitchTile(
                              title: 'Enable Push Notifications',
                              value: state.isPushNotificationsEnabled,
                              onChanged: (val) => context
                                  .read<ProfileCubit>()
                                  .togglePushNotifications(val),
                            ),
                            ProfileSwitchTile(
                              title: 'Enable Location Services',
                              value: state.isLocationEnabled,
                              onChanged: (val) => context
                                  .read<ProfileCubit>()
                                  .toggleLocation(val),
                            ),
                            ProfileSwitchTile(
                              title: 'Dark Mode',
                              value: state.isDarkMode,
                              onChanged: (val) => context
                                  .read<ProfileCubit>()
                                  .toggleDarkMode(val),
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
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
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
                  const SnackBar(
                    content: Text(
                      'Error: Please log in again before deleting your account.',
                    ),
                  ),
                );
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(ctx).colorScheme.onError),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب بيانات المستخدم الحالي من فايربيز
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? 'User Name';
    final userImage = user?.photoURL;

    return SafeArea(
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            // User Avatar
            CircleAvatar(
              radius: 35,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              backgroundImage: userImage != null
                  ? NetworkImage(userImage)
                  : null,
              child: userImage == null
                  ? Icon(
                      Icons.person,
                      size: 35,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              'Hey, 👋',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 40),

            // Menu Items
            _buildMenuItem(context, Icons.person_outline, 'Profile', () {
              Navigator.pushNamed(context, AppRoutes.profile);
            }),
            _buildMenuItem(context, Icons.home_outlined, 'Home Page', () {
              // TODO: Close Menu Logic will be handled by MainLayout
            }),
            _buildMenuItem(
              context,
              Icons.shopping_bag_outlined,
              'My Cart',
              () => Navigator.pushNamed(context, AppRoutes.cart),
            ),
            _buildMenuItem(
              context,
              Icons.favorite_border,
              'Favorite',
              () => Navigator.pushNamed(context, AppRoutes.favorite),
            ),
            _buildMenuItem(
              context,
              Icons.local_shipping_outlined,
              'Orders',
              () => Navigator.pushNamed(context, AppRoutes.orders),
            ),
            _buildMenuItem(
              context,
              Icons.notifications_none,
              'Notifications',
              () => Navigator.pushNamed(context, AppRoutes.notifications),
            ),

            const Spacer(),
            Divider(
              color: Theme.of(context).colorScheme.outlineVariant,
              height: 1,
            ),
            const SizedBox(height: 24),

            // Sign Out
            _buildMenuItem(context, Icons.logout_rounded, 'Sign Out', () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

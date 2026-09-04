import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';
import 'package:kicksvibe/core/widgets/custom_back_button.dart';
import 'package:kicksvibe/features/home/data/models/product_model.dart';
import 'package:kicksvibe/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:kicksvibe/features/notifications/presentation/widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(onTap: () => Navigator.pop(context)),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement Clear All Logic
                    },
                    child: Text(
                      'Clear All',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Notifications List
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is NotificationsError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }

                  if (state is NotificationsLoaded) {
                    if (state.notifications.isEmpty) {
                      return Center(
                        child: Text(
                          'No Notifications Yet!',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      itemCount: state.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = state.notifications[index];

                        // 1. فتح صندوق المنتجات من الكاش
                        final productsBox = Hive.box<ProductModel>(
                          'homeProductsBox',
                        );

                        // 2. البحث عن المنتج المطابق للـ ID الجاي من الإشعار بأمان
                        ProductModel? cachedProduct;
                        try {
                          cachedProduct = productsBox.values.firstWhere(
                            (p) => p.id == notification.productId,
                          );
                        } catch (e) {
                          cachedProduct = null; // المنتج مش موجود في الكاش
                        }

                        // 3. تحديد الصورة: لو المنتج متكيش هات أول صورة ليه، لو لأ استخدم صورة الإشعار الافتراضية
                        final String displayImage =
                            cachedProduct != null &&
                                cachedProduct.images.isNotEmpty
                            ? cachedProduct.images.first
                            : notification.imageUrl;

                        return GestureDetector(
                          onTap: () {
                            if (cachedProduct != null) {
                              // 4. توجيه المستخدم لشاشة التفاصيل وإرسال المنتج المتكيش
                              Navigator.pushNamed(
                                context,
                                AppRoutes.productDetails,
                                arguments: cachedProduct,
                              );
                            } else {
                              // تنبيه لو المنتج اتمسح أو مش متاح
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Product is currently unavailable.',
                                  ),
                                ),
                              );
                            }
                          },
                          child: NotificationCard(
                            title: notification.title,
                            // يمكنك أيضاً تحديث السعر من الكاش لضمان عرض أحدث سعر
                            price: cachedProduct != null
                                ? cachedProduct.price
                                : notification.currentPrice,
                            oldPrice: notification.oldPrice,
                            timeAgo: _getTimeAgo(notification.createdAt),
                            isUnread: notification.isUnread,
                            imageUrl: displayImage,
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
    } else {
      return 'Just now';
    }
  }
}

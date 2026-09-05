import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShoeCardShimmer extends StatelessWidget {
  const ShoeCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: colors.surfaceContainerHighest,
      highlightColor: colors.surface,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // اللون الأبيض هنا مطلوب فقط لكي يعمل الـ Shimmer بشكل صحيح، ولن يظهر كأبيض فعلي
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // محاكاة صورة الحذاء
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // محاكاة كلمة Best Seller
            Container(width: 60, height: 10, color: Colors.white),
            const SizedBox(height: 8),
            // محاكاة اسم الحذاء
            Container(width: 120, height: 16, color: Colors.white),
            const SizedBox(height: 8),
            // محاكاة السعر وزر الإضافة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 50, height: 14, color: Colors.white),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

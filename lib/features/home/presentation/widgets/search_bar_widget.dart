import 'package:flutter/material.dart';
import 'package:kicksvibe/core/localization/app_localizations.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // الانتقال لصفحة البحث الحقيقية عند الضغط هنا
        Navigator.pushNamed(context, AppRoutes.search);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withAlpha(13),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: AbsorbPointer(
          // نمنع التفاعل مع الـ TextField مباشرة لكي يتم تفعيل הـ GestureDetector
          child: TextField(
            decoration: InputDecoration(
              icon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              hintText: context.l10n.lookingForShoes,
              hintStyle: const TextStyle(fontSize: 14),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}

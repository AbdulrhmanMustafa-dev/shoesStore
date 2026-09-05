import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/localization/app_localizations.dart';
import 'package:kicksvibe/features/home/presentation/cubit/search_cubit.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _selectedGender;
  late String _selectedSize;
  late RangeValues _priceRange;

  final List<String> genders = ['Men', 'Women', 'Unisex'];
  final List<String> sizes = ['UK 4.4', 'US 5.5', 'UK 6.5', 'EU 11.5'];

  @override
  void initState() {
    super.initState();
    // قراءة الفلاتر الحالية من الكيوبت لكي نحافظ على اختيارات المستخدم
    final state = context.read<SearchCubit>().state;
    _selectedGender = state.selectedGender;
    _selectedSize = state.selectedSize;
    _priceRange = RangeValues(state.minPrice, state.maxPrice);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.outlineVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 50),
                Text(
                  context.l10n.filters,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<SearchCubit>().resetFilters();
                    Navigator.pop(context);
                  },
                  child: Text(
                    context.l10n.reset,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Text(
              context.l10n.gender,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: genders
                  .map(
                    (gender) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _buildSelectionChip(
                        text: gender,
                        isSelected: _selectedGender == gender,
                        onTap: () => setState(() => _selectedGender = gender),
                        colors: colors,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),

            Text(
              context.l10n.size,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: sizes
                    .map(
                      (size) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _buildSelectionChip(
                          text: size,
                          isSelected: _selectedSize == size,
                          onTap: () => setState(() => _selectedSize = size),
                          colors: colors,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              context.l10n.price,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 5000, // الحد الأقصى يغطي جميع منتجاتك
              activeColor: colors.primary,
              inactiveColor: colors.surfaceContainerHighest,
              onChanged: (RangeValues values) {
                setState(() => _priceRange = values);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${_priceRange.start.toInt()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  '\$${_priceRange.end.toInt()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // إرسال الفلاتر الجديدة للبحث وتحديث النتائج فوراً
                  context.read<SearchCubit>().updateFilters(
                    gender: _selectedGender,
                    size: _selectedSize,
                    minPrice: _priceRange.start,
                    maxPrice: _priceRange.end,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  context.l10n.apply,
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionChip({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme colors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? colors.onPrimary : colors.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

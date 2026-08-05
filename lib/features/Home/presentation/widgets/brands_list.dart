import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/features/Home/presentation/cubit/home_cubit.dart';

class BrandsList extends StatelessWidget {
  const BrandsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        if (cubit.brands.isEmpty) return const SizedBox();

        return SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cubit.brands.length,
            itemBuilder: (context, index) {
              final brand = cubit.brands[index];
              final isSelected = cubit.selectedBrand == brand.title;

              return GestureDetector(
                onTap: () => cubit.changeBrand(brand.title),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 16),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 16 : 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF5A9AE5) : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      brand.title == 'All'
                          ? Icon(
                              Icons.grid_view_rounded,
                              color: isSelected ? Colors.white : Colors.black87,
                              size: 24,
                            )
                          : Image.network(
                              brand.iconUrl,
                              width: 24,
                              height: 24,
                              // تم حذف خاصية color لكي تظهر الصورة بألوانها الطبيعية
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.sports_baseball,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                size: 24,
                              ),
                            ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Text(
                          brand.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

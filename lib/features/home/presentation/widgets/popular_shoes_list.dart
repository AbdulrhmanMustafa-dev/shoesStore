import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/localization/app_localizations.dart';
import 'package:kicksvibe/features/home/presentation/cubit/home_cubit.dart';
import 'package:kicksvibe/features/home/presentation/widgets/shoe_card.dart';
import 'package:kicksvibe/features/home/presentation/widgets/shoe_card_shimmer.dart'; // 💡 الاستدعاء الجديد

class PopularShoesList extends StatelessWidget {
  const PopularShoesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          // 💡 هنا استخدمنا الـ Shimmer بدلاً من CircularProgressIndicator
          if (state is HomeLoading) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4, // نعرض 4 بطاقات وهمية مؤقتاً
              itemBuilder: (context, index) => const ShoeCardShimmer(),
            );
          }

          if (state is HomeError) {
            return Center(child: Text(state.errorMessage));
          }

          if (state is HomeLoaded) {
            if (state.popularProducts.isEmpty) {
              return Center(child: Text(context.l10n.noPopularProducts));
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.popularProducts.length,
              itemBuilder: (context, index) {
                return ShoeCard(product: state.popularProducts[index]);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

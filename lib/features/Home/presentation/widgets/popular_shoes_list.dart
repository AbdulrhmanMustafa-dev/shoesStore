import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/features/Home/presentation/cubit/home_cubit.dart';
import 'package:kicksvibe/features/Home/presentation/widgets/shoe_card.dart';

class PopularShoesList extends StatelessWidget {
  const PopularShoesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeError) {
            return Center(child: Text(state.errorMessage));
          }

          if (state is HomeLoaded) {
            if (state.popularProducts.isEmpty) {
              return const Center(
                child: Text("لا توجد منتجات شائعة لهذه الماركة."),
              );
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

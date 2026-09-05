import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/localization/app_localizations.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';
import 'package:kicksvibe/features/home/data/models/product_model.dart';
import 'package:kicksvibe/features/home/presentation/cubit/home_cubit.dart';
import 'package:kicksvibe/features/home/presentation/widgets/brands_list.dart';
import 'package:kicksvibe/features/home/presentation/widgets/home_header.dart';
import 'package:kicksvibe/features/home/presentation/widgets/new_arrivals_card.dart';
import 'package:kicksvibe/features/home/presentation/widgets/popular_shoes_list.dart';
import 'package:kicksvibe/features/home/presentation/widgets/search_bar_widget.dart';
import 'package:kicksvibe/features/home/presentation/widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // عند الضغط على زر الـ Floating Action Button، انتقل إلى صفحة السلة
          Navigator.pushNamed(context, AppRoutes.cart);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        child: Icon(
          Icons.shopping_bag_outlined,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {},
                    child: Icon(
                      Icons.home_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.favorite);
                    },
                    child: Icon(
                      Icons.favorite_border,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.notifications);
                    },
                    child: Icon(
                      Icons.notifications_none,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.profile);
                    },
                    child: Icon(
                      Icons.person_outline,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // 2. محتوى الشاشة
      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: () async {
            // 2. استدعاء دالة جلب البيانات من الكيوبت عند السحب
            await context.read<HomeCubit>().fetchHomeData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // سنقوم بإنشاء هذه الـ Widgets في الخطوات القادمة
                const HomeHeader(),
                const SizedBox(height: 24),
                const SearchBarWidget(),
                const SizedBox(height: 24),
                const BrandsList(),
                const SizedBox(height: 24),
                // ستحتاج لتغليف هذا الجزء بـ BlocBuilder أو قراءة الـ state الحالية
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    List<ProductModel> popular = [];
                    if (state is HomeLoaded) {
                      popular = state.popularProducts;
                    }

                    return Column(
                      children: [
                        SectionTitle(
                          title: context.l10n.popularShoes,
                          onTap: () {
                            if (popular.isNotEmpty) {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.bestSellers,
                                arguments: popular,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        const PopularShoesList(),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                SectionTitle(title: context.l10n.newArrivals, onTap: () {}),
                const SizedBox(height: 16),
                const NewArrivalsCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

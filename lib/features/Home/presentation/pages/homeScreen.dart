import 'package:flutter/material.dart';
import 'package:kicksvibe/features/Home/presentation/widgets/home_header.dart';
import 'package:kicksvibe/features/Home/presentation/widgets/shoe_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // لون الخلفية الفاتح
      // 1. شريط التنقل السفلي المخصص
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF5A9AE5),
        shape: const CircleBorder(),
        child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
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
                    child: const Icon(
                      Icons.home_outlined,
                      color: Color(0xFF5A9AE5),
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {},
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {},
                    child: const Icon(
                      Icons.notifications_none,
                      color: Colors.grey,
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {},
                    child: const Icon(Icons.person_outline, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // 2. محتوى الشاشة
      body: SafeArea(
        child: SingleChildScrollView(
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
              SectionTitle(title: 'Popular Shoes', onTap: () {}),
              const SizedBox(height: 16),
              const PopularShoesList(),
              const SizedBox(height: 24),
              SectionTitle(title: 'New Arrivals', onTap: () {}),
              const SizedBox(height: 16),
              const NewArrivalsCard(),
            ],
          ),
        ),
      ),
    );
  }
}

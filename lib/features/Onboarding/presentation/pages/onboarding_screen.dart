import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';
import 'package:kicksvibe/features/Onboarding/presentation/models/onboarding_model.dart';
import 'package:kicksvibe/features/Onboarding/presentation/widgets/onboarding_background.dart';
import '../cubit/onboarding_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(); // تهيئة
  }

  final List<OnboardingModel> screens = [
    OnboardingModel(
      image: 'assets/images/onBoarding_1.png', // تأكد من إضافة مسار صورك
      title: 'Start Journey\nWith Nike',
      body: 'Smart, Gorgeous & Fashionable\nCollection',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding_2.png',
      title: 'Follow Latest\nStyle Shoes',
      body: 'There Are Many Beautiful And\nAttractive Plants To Your Room',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding_3.png',
      title: 'Summer Shoes\nNike 2022',
      body: 'Amet Minim Lit Nodeseru Saku\nNandu sit Alique Dolor',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Scaffold(
        backgroundColor: Colors
            .white, // تم تغيير لون الخلفية للأبيض لأن الخلفية الأساسية موجودة في الـ Stack
        body: OnboardingBackground(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocBuilder<OnboardingCubit, int>(
              builder: (context, currentIndex) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: screens.length,
                        onPageChanged: (index) {
                          context.read<OnboardingCubit>().updatePage(index);
                        },
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              Center(
                                child: Image.asset(
                                  screens[index].image,
                                  height: 220,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                screens[index].title,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E2832),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                screens[index].body,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: List.generate(
                            screens.length,
                            (index) => _buildDot(index, currentIndex),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (currentIndex == screens.length - 1) {
                              await context
                                  .read<OnboardingCubit>()
                                  .finishOnboarding();
                              if (!context.mounted) return;
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.login,
                              ); // Replace with your login route
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A9AE5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          child: Text(
                            currentIndex == screens.length - 1
                                ? 'Get Started'
                                : 'Next',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildDot(int index, int currentIndex) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: currentIndex == index ? 24 : 8,
      decoration: BoxDecoration(
        color: currentIndex == index
            ? const Color(0xFF5A9AE5)
            : const Color(0xFFD3E0F2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

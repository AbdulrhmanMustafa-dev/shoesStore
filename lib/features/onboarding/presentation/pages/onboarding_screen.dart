import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/localization/app_localizations.dart';
import 'package:kicksvibe/core/di/injection.dart';
import 'package:kicksvibe/core/routes/app_routes.dart';
import 'package:kicksvibe/features/onboarding/presentation/models/onboarding_model.dart';
import 'package:kicksvibe/features/onboarding/presentation/widgets/onboarding_background.dart';
import 'package:kicksvibe/features/onboarding/presentation/widgets/onboarding_page_indicator.dart';
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

  List<OnboardingModel> _screens(BuildContext context) => [
    OnboardingModel(
      image: 'assets/images/onBoarding_1.png', // تأكد من إضافة مسار صورك
      title: context.l10n.onboardingTitle1,
      body: context.l10n.onboardingBody1,
    ),
    OnboardingModel(
      image: 'assets/images/onboarding_2.png',
      title: context.l10n.onboardingTitle2,
      body: context.l10n.onboardingBody2,
    ),
    OnboardingModel(
      image: 'assets/images/onboarding_3.png',
      title: context.l10n.onboardingTitle3,
      body: context.l10n.onboardingBody3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OnboardingCubit>(),
      child: Scaffold(
        backgroundColor: Colors
            .white, // تم تغيير لون الخلفية للأبيض لأن الخلفية الأساسية موجودة في الـ Stack
        body: OnboardingBackground(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocBuilder<OnboardingCubit, int>(
              builder: (context, currentIndex) {
                final screens = _screens(context);
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
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                screens[index].body,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
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
                            (index) => OnboardingPageIndicator(
                              index: index,
                              currentIndex: currentIndex,
                            ),
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
                            minimumSize: const Size(0, 54),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
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
                                ? context.l10n.getStarted
                                : context.l10n.next,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
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
}

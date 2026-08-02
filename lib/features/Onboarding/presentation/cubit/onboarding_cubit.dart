import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kicksvibe/core/utils/CacheHelper.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  void updatePage(int index) {
    emit(index);
  }

  Future<void> finishOnboarding() async {
    await CacheHelper.saveGetStartedPressed(value: true);
  }
}

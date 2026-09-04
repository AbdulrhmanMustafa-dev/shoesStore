import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/core/utils/cache_helper.dart';

@injectable
class OnboardingCubit extends Cubit<int> {
  final CacheHelper _cacheHelper;

  OnboardingCubit(this._cacheHelper) : super(0);

  void updatePage(int index) {
    emit(index);
  }

  Future<void> finishOnboarding() async {
    await _cacheHelper.saveGetStartedPressed(value: true);
  }
}

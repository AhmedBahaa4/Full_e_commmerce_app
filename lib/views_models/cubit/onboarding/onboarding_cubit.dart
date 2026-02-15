import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  int currentPage = 0;
  OnboardingCubit() : super(OnboardingInitial());

  /// Change page
  void changePage(int index) {
    currentPage = index;
    emit(OnboardingPageChanged(index));
  }

  /// Complete onboarding and save to SharedPreferences
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    emit(OnboardingCompleted());
  }

  /// Check if user has seen onboarding
  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seenOnboarding') ?? false;
  }
}

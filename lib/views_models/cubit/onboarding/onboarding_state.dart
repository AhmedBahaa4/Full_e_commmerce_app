part of 'onboarding_cubit.dart';


sealed class OnboardingState {}

//intial state
final class OnboardingInitial extends OnboardingState {}

/// When page changes
 class OnboardingPageChanged extends OnboardingState {
  final int pageIndex;
  OnboardingPageChanged(this.pageIndex);
}

/// When onboarding is completed
 final class OnboardingCompleted extends OnboardingState {}
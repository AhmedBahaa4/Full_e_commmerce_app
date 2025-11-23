part of 'password_cubit_cubit.dart';

sealed class PasswordState {
  const PasswordState();
}

final class PasswordVisibilityChanged extends PasswordState {
  final bool isVisible;
  const PasswordVisibilityChanged(this.isVisible);
}

final class PasswordError extends PasswordState {
  final String message;
  const PasswordError(this.message);
}

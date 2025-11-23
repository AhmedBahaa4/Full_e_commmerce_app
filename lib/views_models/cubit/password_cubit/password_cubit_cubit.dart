import 'package:flutter_bloc/flutter_bloc.dart';
part 'password_cubit_state.dart';

class PasswordCubit extends Cubit<PasswordState> {
  PasswordCubit() : super(const PasswordVisibilityChanged(false));

  void toggleVisibility() {
    final currentVisibility = state is PasswordVisibilityChanged
        ? (state as PasswordVisibilityChanged).isVisible
        : false;

    emit(PasswordVisibilityChanged(!currentVisibility));
  }

  void showPassword() => emit(const PasswordVisibilityChanged(true));

  void hidePassword() => emit(const PasswordVisibilityChanged(false));

  void setError(String message) => emit(PasswordError(message));
}

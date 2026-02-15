import 'package:e_commerc_app/models/user_data.dart';
import 'package:e_commerc_app/services/auth_services.dart';
import 'package:e_commerc_app/services/firestore_services.dart';
import 'package:e_commerc_app/utils/api_paths.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthServices authServices = AuthServicesImpl();
  final firestoreServices = FirestoreServices.instance;

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(AuthLoading());

    try {
      final result = await authServices.loginWithEmailAndPassword(
        email,
        password,
      );

      if (result) {
        emit(AuthDone());
      } else {
        emit(AuthError(message: 'Invalid email or password'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String username,
  ) async {
    emit(AuthLoading());

    try {
      final result = await authServices.registerWithEmailAndPassword(
        email,
        password,
      );

      if (result) {
        await _saveUserData(email, username);
        emit(AuthDone());
      } else {
        emit(AuthError(message: 'Register failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _saveUserData(String email, String username) async {
    final currentUser = authServices.currentUser();
    final userData = UserData(
      uid: currentUser!.uid,
      email: email,
      name: username,
      createdAt: DateTime.now().toIso8601String(),
    );
    await firestoreServices.setData(
      path: ApiPaths.users(currentUser.uid),
      data: userData.toMap(),
    );
  }

  void checkAuth() {
    final user = authServices.currentUser();

    if (user != null) {
      emit(AuthDone());
    }
  }

  Future<void> logout() async {
    emit(AuthloggingOut());
    try {
      await authServices.logout();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthLoggedOutError(message: e.toString()));
    }
  }

  Future<void> authWithGoogle() async {
    emit(GoogleAuthenticating());
    try {
      final result = await authServices.authWithGoogle();
      if (result) {
        emit(GoogleAuthDone());
      } else {
        emit(GoogleAuthError(message: 'Google authentication failed'));
      }
    } catch (e) {
      emit(GoogleAuthError(message: e.toString()));
    }
  }

  Future<void> authWithFacebook() async {
    emit(FacebookAuthenticating());
    try {
      final result = await authServices.authWithFacebook();
      if (result) {
        emit(FacebookAuthDone());
      } else {
        emit(FacebookAuthError(message: 'Facebook authentication failed'));
      }
    } catch (e) {
      emit(FacebookAuthError(message: e.toString()));
    }
  }
}

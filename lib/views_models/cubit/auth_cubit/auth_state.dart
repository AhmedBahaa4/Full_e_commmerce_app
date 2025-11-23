part of 'auth_cubit.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}

final class AuthDone extends AuthState {
  
}
 // login
final class AuthloggingOut extends  AuthState {}
final class AuthLoggedOut extends AuthState {}
final class AuthLoggedOutError extends AuthState {
  final String message;
  AuthLoggedOutError({required this.message});
}

// google

final class   GoogleAuthenticating extends AuthState {}

final class GoogleAuthError extends AuthState {
  final String message;
  GoogleAuthError({required this.message});
}

final class GoogleAuthDone extends AuthState {}

 

 // facebook  
final class  FacebookAuthenticating extends AuthState {}

final class FacebookAuthError extends AuthState {
  final String message;
 FacebookAuthError({required this.message});
}

final class FacebookAuthDone extends AuthState {}




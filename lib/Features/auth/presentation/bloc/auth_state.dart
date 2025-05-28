abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

//login
class AuthLoginSuccess extends AuthState {
  final String token;
  final int userId;

  AuthLoginSuccess({required this.token, required this.userId});
}

class AuthLogoutSuccess extends AuthState {}

//changePassword
class ChangePasswordSuccess extends AuthState {}

class AuthFail extends AuthState {
  final String error;

  AuthFail({required this.error});
}

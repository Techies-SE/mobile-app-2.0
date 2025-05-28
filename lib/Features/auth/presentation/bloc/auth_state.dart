import 'package:mobile_app_2/Features/auth/domain/entities/auth_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

//login
class AuthLoginSuccess extends AuthState {
  final AuthEntity authEntity;

  AuthLoginSuccess({required this.authEntity});
}

class AuthLogoutSuccess extends AuthState {}

//changePassword
class ChangePasswordSuccess extends AuthState {}

class AuthFail extends AuthState {
  final String error;

  AuthFail({required this.error});
}

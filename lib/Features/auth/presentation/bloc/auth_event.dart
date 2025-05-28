// ignore_for_file: non_constant_identifier_names

abstract class AuthEvent {}

class LoginRequest extends AuthEvent {
  final String phone_no;
  final String password;

  LoginRequest({required this.phone_no, required this.password});
}

class LogoutRequest extends AuthEvent {}

class ChangePasswordEvent extends AuthEvent {
  final String password;

  ChangePasswordEvent({required this.password});
}

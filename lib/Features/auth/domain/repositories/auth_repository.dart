// ignore_for_file: non_constant_identifier_names

import 'package:mobile_app_2/Features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> logIn(
    String phone_no,
    String password,
  );

  Future<void> logOut();

  Future<void> ChangePassword(String password);
}

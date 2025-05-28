// ignore_for_file: non_constant_identifier_names

import 'package:mobile_app_2/Features/auth/domain/entities/auth_entity.dart';
import 'package:mobile_app_2/Features/auth/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<AuthEntity> call(String phone_no, String password) async {
    return await repository.logIn(phone_no, password);
  }
}

// ignore_for_file: non_constant_identifier_names

abstract class AuthRemoteDataSource {
  Future<dynamic> logIn(String phone_no, String password);

  Future<void> ChangePassword(String password);
}

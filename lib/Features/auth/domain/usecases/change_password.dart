import 'package:mobile_app_2/Features/auth/domain/repositories/auth_repository.dart';

class Changepassword {
  final AuthRepository repo;
  Changepassword(this.repo);

  Future<void> call(String password) async {
    await repo.ChangePassword(password);
  }
}

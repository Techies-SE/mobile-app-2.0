import 'package:mobile_app_2/Features/auth/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Future<void> call() async{
    await repository.logOut();
  }
}

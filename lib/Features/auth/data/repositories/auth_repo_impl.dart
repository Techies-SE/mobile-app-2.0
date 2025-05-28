// ignore_for_file: non_constant_identifier_names

import 'package:mobile_app_2/Features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:mobile_app_2/Features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:mobile_app_2/Features/auth/data/models/auth_model.dart';
import 'package:mobile_app_2/Features/auth/domain/entities/auth_entity.dart';
import 'package:mobile_app_2/Features/auth/domain/repositories/auth_repository.dart';

class AuthRepoImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepoImpl(this.authLocalDataSource, this.authRemoteDataSource);

  @override
  Future<AuthEntity> logIn(String phone_no, String password) async {
    final json = await authRemoteDataSource.logIn(phone_no, password);
    final authModel = AuthModel.fromJson(json);
    final authEntity = authModel.toEntity();

    //to save token
    authLocalDataSource.saveToken(authEntity.token);
    authLocalDataSource.saveUserId(authEntity.userId);
    return authEntity;
  }

  @override
  Future<void> logOut() async {
    authLocalDataSource.deleteToken();
  }

  @override
  Future<void> ChangePassword(String password) async{
    await authRemoteDataSource.ChangePassword(password);
  }
}

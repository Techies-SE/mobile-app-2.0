import 'package:mobile_app_2/Features/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  AuthModel({required super.token, required super.userId, required super.firstTimeLogin});

  factory AuthModel.fromJson(dynamic json) {
    return AuthModel(token: json['token'], userId: json['id'], firstTimeLogin:  json['firstTimeLogin']);
  }

  AuthEntity toEntity() => AuthEntity(token: token,userId: userId, firstTimeLogin:  firstTimeLogin);
}

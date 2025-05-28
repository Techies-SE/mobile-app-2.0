class AuthEntity {
  String token;
  int userId;
  bool firstTimeLogin;
  AuthEntity({
    required this.token,
    required this.userId,
    required this.firstTimeLogin,
  });
}

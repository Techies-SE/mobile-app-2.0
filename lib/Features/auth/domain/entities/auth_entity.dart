class AuthEntity {
  String token;
  int userId;
  bool firstTimeLogin;
  String hnNumber;
  AuthEntity({
    required this.token,
    required this.userId,
    required this.firstTimeLogin,
    required this.hnNumber,
  });
}

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();

  Future<void> saveHnNumber(String hnNumber);
  Future<String?> getHnNumber();

  Future<void> saveUserId(int userId);
  Future<int?> getUserId();
  Future<void> deleteUserId();
}

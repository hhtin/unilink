abstract class IAuthenRepository {
  Future<void> loginByEmail(String email, String deviceToken);
}

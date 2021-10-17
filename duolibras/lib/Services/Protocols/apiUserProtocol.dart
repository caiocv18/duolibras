import 'package:duolibras/Services/Models/user.dart';

abstract class APIUserProtocol {
  Future<User> getUser();
  Future<User> postUser(User user, bool isNewUser);
  Future<List<User>> getUsersRanking();
}

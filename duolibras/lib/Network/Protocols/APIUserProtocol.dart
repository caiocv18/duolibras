import 'package:duolibras/Network/Models/User.dart';

abstract class APIUserProtocol {
  Future<User> getUser();
  Future<User> postUser(User user);
  Future<List<User>> getUsersRanking();
}

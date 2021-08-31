import 'package:duolibras/Network/Models/User.dart';

abstract class APIUserProtocol {
  Future<User> getUser();
  Future<User> postUser(User user);
}

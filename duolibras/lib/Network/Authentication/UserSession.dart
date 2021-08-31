import 'package:duolibras/Network/Models/User.dart';

class UserSession {
  late User? user;
  static UserSession instance = UserSession._();

  UserSession._() {}
}

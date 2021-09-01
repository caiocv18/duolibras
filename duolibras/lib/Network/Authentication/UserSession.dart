import 'package:duolibras/Network/Models/User.dart';

class UserSession {
  late User? user = null;
  static UserSession instance = UserSession._();

  UserSession._() {}
}

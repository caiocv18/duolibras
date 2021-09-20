import 'package:duolibras/Network/Models/Provaiders/userProvider.dart';
import 'package:duolibras/Network/Models/User.dart';

class UserSession {
  late UserProvider userProvider = UserProvider();
  static UserSession instance = UserSession._();

  UserSession._() {}
}

import 'package:duolibras/Network/Authentication/AuthenticationModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticatorProtocol {
  Future<User> signIn(AuthenticationModel? model);
  Future<User> signUp(AuthenticationModel? model);
  Future<void> signOut();
}

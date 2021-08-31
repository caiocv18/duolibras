import 'package:duolibras/Network/Authentication/AuthenticationModel.dart';
import 'package:duolibras/Network/Authentication/AuthenticatorProtocol.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireUser;
import 'package:duolibras/Network/Models/User.dart' as myUser;
import 'package:flutter/services.dart';

abstract class SignUpViewModelProtocol {
  Future<bool> signUp(AuthenticationModel? model);
  String? validateEmailInput(String? email);
  String? validatePasswordInput(String? password);
}

class SignUpViewModel extends SignUpViewModelProtocol {
  final AuthenticatorProtocol authenticator;
  SignUpViewModel(this.authenticator);

  @override
  Future<bool> signUp(AuthenticationModel? model) async {
    final user = await authenticator.signUp(model);
    return _updateUserInDatabase(user);
  }

  String? validateEmailInput(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  @override
  String? validatePasswordInput(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  Future<bool> _updateUserInDatabase(fireUser.User? user) async {
    if (user != null) {
      final userModel =
          myUser.User(id: user.uid, name: user.displayName ?? user.email ?? "");

      final userUpdated = await Service.instance.postUser(userModel);

      UserSession.instance.user = userUpdated;
      return true;
    } else {
      throw PlatformException(code: "code");
    }
  }
}

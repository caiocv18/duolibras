import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Network/Authentication/AuthenticationModel.dart';
import 'package:duolibras/Network/Authentication/AuthenticatorProtocol.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Models/User.dart' as myUser;
import 'package:duolibras/Network/Service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireUser;
import 'package:flutter/services.dart';

abstract class SignInViewModelProtocol {
  Future<bool> signIn(AuthenticationModel? model);
}

class SignInViewModel extends SignInViewModelProtocol {
  final AuthenticatorProtocol authenticator;
  SignInViewModel(this.authenticator);

  @override
  Future<bool> signIn(AuthenticationModel? model) async {
    fireUser.User? user = await authenticator.signIn(model);
    return _updateUserInDatabase(user);
  }

  Future<bool> _updateUserInDatabase(fireUser.User? user) async {
    if (user != null) {
      final userModel =
          myUser.User(id: user.uid, name: user.displayName ?? user.email ?? "");

      var userUpdated = await Service.instance.postUser(userModel);
      userUpdated.modulesProgress = await Service.instance.getModulesProgress();

      UserSession.instance.user = userUpdated;
      SharedFeatures.instance.isLoggedIn = true;
      return true;
    } else {
      throw PlatformException(code: "code");
    }
  }
}

import 'package:duolibras/Network/Authentication/Apple/AppleAuthenticator.dart';
import 'package:duolibras/Network/Authentication/Firebase/FirebaseAuthenticator.dart';
import 'package:duolibras/Network/Authentication/Google/GoogleAuthenticator.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Models/User.dart' as myUser;
import 'package:duolibras/Network/Service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireUser;
import 'package:flutter/services.dart';

abstract class SignInViewModelProtocol {
  Future<bool> signInWithGoogle();
  Future<bool> signInWithApple();
  Future<bool> signInWithFirebase(String email, String password);
}

class SignInViewModel extends SignInViewModelProtocol {
  @override
  Future<bool> signInWithApple() async {
    fireUser.User? user = await AppleAuthenticator.signInWithApple();
    return _updateUserInDatabase(user);
  }

  @override
  Future<bool> signInWithFirebase(String email, String password) async {
    fireUser.User user =
        await FirebaseAuthenticator.handleSignInEmail(email, password);
    return _updateUserInDatabase(user);
  }

  @override
  Future<bool> signInWithGoogle() async {
    fireUser.User? user = await GoogleAuthenticator.signInWithGoogle();
    return _updateUserInDatabase(user);
  }

  Future<bool> _updateUserInDatabase(fireUser.User? user) {
    if (user != null) {
      final userModel =
          myUser.User(id: user.uid, name: user.displayName ?? user.email ?? "");

      return Service.instance.postUser(userModel).then((userUpdated) {
        UserSession.instance.user = userUpdated;
        return true;
      });
    } else {
      throw PlatformException(code: "code");
    }
  }
}

import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Network/Authentication/Apple/AppleAuthenticator.dart';
import 'package:duolibras/Network/Authentication/Firebase/FirebaseAuthenticator.dart';
import 'package:duolibras/Network/Authentication/Google/GoogleAuthenticator.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Firebase/FirebaseErrors.dart';
import 'package:duolibras/Network/Models/User.dart' as myUser;
import 'package:duolibras/Network/Service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireUser;
import 'package:flutter/services.dart';

abstract class SignOutProtocol {
  Future<void> signOut();
}

abstract class GoogleSignInProtocol with SignOutProtocol {
  Future<void> googleSignIn();
}

abstract class AppleSignInProtocol with SignOutProtocol {
  Future<void> appleSignIn();
}

abstract class InputValidator {
  String? validateEmailInput(String? email);
  String? validatePasswordInput(String? password);
}

abstract class FirebaseAuthenticatorProtocol
    with SignOutProtocol, InputValidator {
  Future<void> firebaseSignIn(String email);
  Future<void> handleFirebaseLink(Uri link, String email);
}

class AutheticationViewModel
    implements
        GoogleSignInProtocol,
        AppleSignInProtocol,
        FirebaseAuthenticatorProtocol {
  final _appleAuthenticator = AppleAuthenticator();
  final _googleAuthenticator = GoogleAuthenticator();
  final _firebaseAuthenticator = FirebaseAuthenticator();

  @override
  Future<void> appleSignIn() async {
    fireUser.User? user = await _appleAuthenticator.signIn(null);
    return _updateUserInDatabase(user);
  }

  Future<void> googleSignIn() async {
    fireUser.User? user = await _googleAuthenticator.signIn(null);
    return _updateUserInDatabase(user);
  }

  @override
  Future<void> firebaseSignIn(String email) async {
    return _firebaseAuthenticator.signInWithEmail(email);
  }

  @override
  Future<void> signOut() {
    return _firebaseAuthenticator.signOut();
  }

  Future<void> _updateUserInDatabase(fireUser.User? user) async {
    if (user != null) {
      SharedFeatures.instance.isLoggedIn = true;

      final userModel = myUser.User(
          id: user.uid,
          name: user.displayName ?? user.email ?? "",
          currentProgress: 0);

      var userUpdated = await Service.instance.postUser(userModel);
      userUpdated.modulesProgress = await Service.instance.getModulesProgress();

      UserSession.instance.user = userUpdated;
      return;
    } else {
      throw PlatformException(code: "code");
    }
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

  Future<void> handleFirebaseLink(Uri link, String email) async {
    try {
      final user = await _firebaseAuthenticator.signInWithEmailLink(
          email, link.toString());
      return _updateUserInDatabase(user);
    } on FirebaseErrors catch (e) {
      print(e);
    }
  }
}

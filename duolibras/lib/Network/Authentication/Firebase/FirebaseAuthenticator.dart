import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Network/Authentication/AuthenticationModel.dart';
import 'package:duolibras/Network/Authentication/AuthenticatorProtocol.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../UserSession.dart';

class FirebaseAuthenticator extends AuthenticatorProtocol {
  static final _auth = FirebaseAuth.instance;

  Future<User> _handleSignInEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user!;

      return user;
    } on FirebaseAuthException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<User> _handleSignUp(email, password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user!;

      return user;
    } on FirebaseAuthException catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Future<User> signIn(AuthenticationModel? model) {
    if (model == null) {
      throw PlatformException(code: "code");
    }
    return _handleSignInEmail(model.email, model.password);
  }

  @override
  Future<User> signUp(AuthenticationModel? model) {
    if (model == null) {
      throw PlatformException(code: "code");
    }
    return _handleSignUp(model.email, model.password);
  }

  @override
  Future<void> signOut() {
    return _auth.signOut().then((value) async {
      SharedFeatures.instance.isLoggedIn = false;
      UserSession.instance.user = await Service.instance.getUser();
    });
  }
}

import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Network/Authentication/AuthenticationModel.dart';
import 'package:duolibras/Network/Authentication/AuthenticatorProtocol.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../UserSession.dart';

class FirebaseAuthenticator extends AuthenticatorProtocol {
  static final _auth = FirebaseAuth.instance;

  Future<User> _signInWithEmailAndLink(String userEmail) async {
    try {
      if (!_auth.isSignInWithEmailLink("https://duolibras.page.link/")) {
        throw PlatformException(code: "url error");
      }

      UserCredential result = await _auth.signInWithEmailLink(
          email: userEmail, emailLink: "https://duolibras.page.link/");
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
    return _signInWithEmailAndLink(model.email);
  }

  @override
  Future<User> signUp(AuthenticationModel? model) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    return _auth.signOut().then((value) async {
      SharedFeatures.instance.isLoggedIn = false;
      UserSession.instance.user = await Service.instance.getUser();
    });
  }
}

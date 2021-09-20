import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Network/Authentication/AuthenticationModel.dart';
import 'package:duolibras/Network/Authentication/AuthenticatorProtocol.dart';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Service.dart';
import '../UserSession.dart';

class AppleAuthenticator extends AuthenticatorProtocol {
  static final _auth = FirebaseAuth.instance;

  static Future<User> _signInWithApple() async {
    final scopes = [
      AppleIDAuthorizationScopes.fullName,
      AppleIDAuthorizationScopes.email
    ];

    final appleIdCredential =
        await SignInWithApple.getAppleIDCredential(scopes: scopes);

    final oAuthProvider = OAuthProvider('apple.com');

    final credential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode);

    final firebaseUser = (await _auth.signInWithCredential(credential)).user;

    if (firebaseUser == null) {
      throw PlatformException(code: "code");
    }

    if (scopes.contains(AppleIDAuthorizationScopes.fullName)) {
      final displayName =
          '${appleIdCredential.givenName} ${appleIdCredential.familyName}';
      await firebaseUser.updateDisplayName(displayName);
    }
    return firebaseUser;
  }

  @override
  Future<User> signIn(AuthenticationModel? model) {
    return _signInWithApple();
  }

  @override
  Future<void> signOut() {
    return _auth.signOut().then((value) async {
      SharedFeatures.instance.isLoggedIn = false;
      UserSession.instance.userProvider
          .setNewUser(await Service.instance.getUser());
    });
  }

  @override
  Future<User> signUp(AuthenticationModel? model) {
    throw UnimplementedError();
  }
}

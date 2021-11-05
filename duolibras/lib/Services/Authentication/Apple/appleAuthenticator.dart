import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Services/Authentication/AuthenticationErrors.dart';
import 'package:duolibras/Services/Models/Providers/userViewModel.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../service.dart';

class AppleAuthenticator {
  static final _auth = FirebaseAuth.instance;

  Future<User> signInWithApple() async {
    try {
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
        return Future.error(AuthenticationErrors.LoginFailed);
      }

      if (scopes.contains(AppleIDAuthorizationScopes.fullName)) {
        final displayName =
            '${appleIdCredential.givenName} ${appleIdCredential.familyName}';
        await firebaseUser.updateDisplayName(displayName);
      }
      return firebaseUser;
    } catch (e) {
      return Future.error(AuthenticationErrors.LoginFailed);
    }
  }

  Future<void> signOut() {
    return _auth.signOut().then((value) async {
      SharedFeatures.instance.isLoggedIn = false;
      locator<UserViewModel>().setNewUser(await Service.instance.getUser());
    }).catchError((error, stackTrace) {
      Future.error(AuthenticationErrors.LogoutFailed);
    });
  }
}

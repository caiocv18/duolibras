import 'dart:async';

import 'package:duolibras/Commons/Utils/Constants.dart';
import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Services/Models/Providers/userViewModel.dart';
import 'package:duolibras/Services/service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../AuthenticationErrors.dart';

class FirebaseAuthenticator {
  static final _auth = FirebaseAuth.instance;

  Future<User> signInWithEmailMock(String email) async {
    UserCredential result = await _auth
        .signInWithEmailAndPassword(email: email.trim(), password: "123456")
        .onError((error, stackTrace) {
      return Future.error(AuthenticationErrors.LoginFailed);
    });

    if (result.user == null) {
      return Future.error(AuthenticationErrors.LoginFailed);
    }

    final User user = result.user!;
    return user;
  }

  Future<void> signInWithEmail(String userEmail) async {
    final settings = ActionCodeSettings(
        url: Constants.firebaseService.url,
        handleCodeInApp: true,
        iOSBundleId: Constants.firebaseService.iosBundleId,
        androidPackageName: Constants.firebaseService.androidPackageName,
        androidMinimumVersion: Constants.firebaseService.androidMinimumVersion,
        androidInstallApp: true);

    return await _auth
        .sendSignInLinkToEmail(email: userEmail, actionCodeSettings: settings)
        .onError((error, stackTrace) {
      return Future.error(AuthenticationErrors.LoginFailed);
    });
  }

  Future<User> signInWithEmailLink(String email, String emailLink) async {
    UserCredential result = await _auth
        .signInWithEmailLink(email: email, emailLink: emailLink)
        .onError((error, stackTrace) {
      return Future.error(AuthenticationErrors.LoginFailed);
    });

    if (result.user == null) {
      return Future.error(AuthenticationErrors.LoginFailed);
    }

    final User user = result.user!;
    return user;
  }

  Future<void> signOut() {
    return _auth.signOut().then((value) async {
      SharedFeatures.instance.isLoggedIn = false;
      locator<UserViewModel>().setNewUser(await Service.instance.getUser());
    }).catchError((error, stackTrace) {
      Future.error(AuthenticationErrors.LoginFailed);
    });
  }
}

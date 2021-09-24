import 'package:duolibras/Commons/Utils/Constants.dart';
import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Network/Authentication/AuthenticationModel.dart';
import 'package:duolibras/Network/Authentication/AuthenticatorProtocol.dart';
import 'package:duolibras/Network/Firebase/FirebaseErrors.dart';
import 'package:duolibras/Network/Models/Provaiders/userProvider.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../UserSession.dart';

class FirebaseAuthenticator extends AuthenticatorProtocol {
  static final _auth = FirebaseAuth.instance;

  Future<void> signInWithEmail(String userEmail) async {
    final settings = ActionCodeSettings(
        url: FirebaseAuthenticatorConstants().url,
        handleCodeInApp: true,
        iOSBundleId: FirebaseAuthenticatorConstants().iosBundleId,
        androidPackageName: FirebaseAuthenticatorConstants().androidPackageName,
        androidMinimumVersion:
            FirebaseAuthenticatorConstants().androidMinimumVersion,
        androidInstallApp: true);

    return await _auth.sendSignInLinkToEmail(
        email: userEmail, actionCodeSettings: settings);
  }

  Future<User> signInWithEmailLink(String email, String emailLink) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailLink(email: email, emailLink: emailLink);

      if (result.user == null) {
        throw FirebaseErrors.UserNotFound;
      }

      final User user = result.user!;
      return user;
    } on FirebaseAuthException catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Future<User> signIn(AuthenticationModel? model) {
    throw UnimplementedError();
  }

  @override
  Future<User> signUp(AuthenticationModel? model) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    return _auth.signOut().then((value) async {
      SharedFeatures.instance.isLoggedIn = false;
      locator<UserModel>().setNewUser(await Service.instance.getUser());
    });
  }
}

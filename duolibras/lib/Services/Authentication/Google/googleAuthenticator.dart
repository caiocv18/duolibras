import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Services/Authentication/AuthenticationErrors.dart';
import 'package:duolibras/Services/Models/Providers/userViewModel.dart';
import 'package:duolibras/Services/service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthenticator {
  static final _auth = FirebaseAuth.instance;

  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        if (userCredential.user == null) {
          return Future.error(AuthenticationErrors.LoginFailed);
        }
        return userCredential.user!;
      }
      return Future.error(AuthenticationErrors.LoginFailed);
    } catch (e) {
      return Future.error(AuthenticationErrors.LoginFailed);
    }
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

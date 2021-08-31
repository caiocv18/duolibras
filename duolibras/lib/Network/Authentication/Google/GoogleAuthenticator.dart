import 'package:duolibras/Network/Authentication/AuthenticationModel.dart';
import 'package:duolibras/Network/Authentication/AuthenticatorProtocol.dart';
import 'package:duolibras/Network/Firebase/FirebaseErrors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthenticator extends AuthenticatorProtocol {
  static final _auth = FirebaseAuth.instance;

  Future<User> _signInWithGoogle() async {
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

      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        if (userCredential.user == null) {
          throw FirebaseErrors.UserNotFound;
        }

        return userCredential.user!;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          throw e;
        } else if (e.code == 'invalid-credential') {
          throw e;
        }
      } catch (e) {
        throw e;
      }
    }

    throw PlatformException(code: "code");
  }

  @override
  Future<User> signIn(AuthenticationModel? model) {
    return _signInWithGoogle();
  }

  @override
  Future<User> signUp(AuthenticationModel? model) {
    return _signInWithGoogle();
  }
}

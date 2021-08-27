import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticator {
  static final _auth = FirebaseAuth.instance;

  static Future<User> handleSignInEmail(String email, String password) async {
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

  static Future<User> handleSignUp(email, password) async {
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
}

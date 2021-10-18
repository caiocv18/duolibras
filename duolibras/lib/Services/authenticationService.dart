import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Services/Authentication/Apple/appleAuthenticator.dart';
import 'package:duolibras/Services/Authentication/AuthenticationErrors.dart';
import 'package:duolibras/Services/Authentication/Firebase/firebaseAuthenticator.dart';
import 'package:duolibras/Services/Authentication/Google/googleAuthenticator.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/Models/appError.dart';
import 'package:duolibras/Services/Models/user.dart' as myUser;
import 'package:duolibras/Services/service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireUser;
import 'package:flutter/services.dart';

class AuthenticationService {
  final _appleAuthenticator = AppleAuthenticator();
  final _googleAuthenticator = GoogleAuthenticator();
  final _firebaseAuthenticator = FirebaseAuthenticator();

  static AuthenticationService sharedInstance = AuthenticationService._();

  AuthenticationService._();

  Future<void> appleSignIn() async {
<<<<<<< HEAD
    return _appleAuthenticator.signInWithApple()
    .then((user) => _updateUserInDatabase(user))
    .catchError(_handleAuthenticationException, test: (e) => e is AuthenticationErrors);
  }

  Future<void> googleSignIn() async {
    return _googleAuthenticator.signInWithGoogle()
    .then((user) => _updateUserInDatabase(user))
    .catchError(_handleAuthenticationException, test: (e) => e is AuthenticationErrors);
=======
    return await _appleAuthenticator
        .signInWithApple()
        .then((user) => _updateUserInDatabase(user))
        .catchError(_handleAuthenticationException,
            test: (e) => e is AuthenticationErrors);
  }

  Future<void> googleSignIn() async {
    return await _googleAuthenticator
        .signInWithGoogle()
        .then((user) => _updateUserInDatabase(user))
        .catchError(_handleAuthenticationException,
            test: (e) => e is AuthenticationErrors);
>>>>>>> 5e9019efc0dc1991851067e89026733c7c05eae7
  }

  Future<void> firebaseSignIn(String email) async {
    return _firebaseAuthenticator.signInWithEmail(email).onError(
        _handleAuthenticationException,
        test: (e) => e is AuthenticationErrors);
  }

  Future<void> signOut() {
    return _firebaseAuthenticator.signOut().onError(
        _handleAuthenticationException,
        test: (e) => e is AuthenticationErrors);
  }

  Future<void> handleFirebaseLink(Uri link, String email) async {
<<<<<<< HEAD
    return _firebaseAuthenticator.signInWithEmailLink(email, link.toString())
    .then((user) => _updateUserInDatabase(user))
    .catchError(_handleAuthenticationException, test: (e) => e is AuthenticationErrors);
=======
    return await _firebaseAuthenticator
        .signInWithEmailLink(email, link.toString())
        .then((user) => _updateUserInDatabase(user))
        .catchError(_handleAuthenticationException,
            test: (e) => e is AuthenticationErrors);
>>>>>>> 5e9019efc0dc1991851067e89026733c7c05eae7
  }

  Future<void> _updateUserInDatabase(fireUser.User? user) async {
    if (user != null) {
      final oldUser = await Service.instance.getUser();
      final isNewUser = oldUser.id.isEmpty;
      myUser.User userModel;

      if (isNewUser) {
        userModel = myUser.User(
            id: user.uid,
            name: user.displayName ?? user.email ?? "",
            currentProgress: 0,
            email: user.email ?? "",
            imageUrl: null);

        SharedFeatures.instance.isLoggedIn = false;
        userModel.sectionsProgress = await Service.instance
            .getSectionsProgress()
            .onError((error, stackTrace) {
          return [];
        });
      } else {
        userModel = oldUser;
      }

      var userUpdated = await Service.instance.postUser(userModel, isNewUser);
      userUpdated.sectionsProgress = await Service.instance
          .getSectionsProgress()
          .onError((error, stackTrace) {
        return [];
      });

      //Resetando dados locais
      locator<Service>().cleanDatabase();

      locator<UserModel>().setNewUser(userUpdated);
      return;
    } else {
      throw PlatformException(code: "code");
    }
  }

  //Error handling
  Future<dynamic> _handleAuthenticationException(
      Object error, StackTrace stackTrace) {
    final AuthenticationErrors firebaseError =
        Utils.tryCast(error, fallback: AuthenticationErrors.Unknown);
    return Future.error(
        AppError(firebaseError.type, firebaseError.errorDescription));
  }
}

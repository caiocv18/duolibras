
import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Commons/ViewModel/baseViewModel.dart';
import 'package:duolibras/Modules/ErrorsModule/errorHandler.dart';
import 'package:duolibras/Services/Authentication/authenticationModel.dart';
import 'package:duolibras/Services/authenticationService.dart';
import 'package:flutter/material.dart';

enum LoginType {
  Google,
  Apple,
  Firebase
}

class LoginViewModel extends BaseViewModel {
  final _authenticationService = AuthenticationService.sharedInstance;
  final _errorHandler = ErrorHandler();

  Future<void> login(BuildContext ctx, LoginType method, {AuthenticationModel? loginModel = null, Function? exitClosure = null}) {
    Future<void> future;
    switch (method) {
      case LoginType.Google:
        future = _authenticationService.googleSignIn();
        break;
      case LoginType.Apple:
        future = _authenticationService.appleSignIn();
        break;
      case LoginType.Firebase:
        future = _authenticationService.firebaseSignIn(loginModel?.email ?? "");
        break;
    }

    future.onError((error, stackTrace)  {
      Utils.logAppError(error);
    });

    return future;
  }

  Future<void> handleFirebaseEmailLinkSignIn(String email, Uri link) {
    return _authenticationService.handleFirebaseLink(link, email);
  }
}

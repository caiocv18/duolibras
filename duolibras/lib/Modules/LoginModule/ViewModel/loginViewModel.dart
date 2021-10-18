
import 'dart:async';

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
    Completer<void> completer = Completer();
    switch (method) {
      case LoginType.Google:
        completer.complete(_authenticationService.googleSignIn());
        break;
      case LoginType.Apple:
        completer.complete(_authenticationService.appleSignIn());
        break;
      case LoginType.Firebase:
        completer.complete(_authenticationService.firebaseSignIn(loginModel?.email ?? ""));
        break;
    }

    completer.future.onError((error, stackTrace)  {
      Utils.logAppError(error);
      completer.complete();
    });

    return completer.future;
  }

  Future<void> handleFirebaseEmailLinkSignIn(String email, Uri link) {
    return _authenticationService.handleFirebaseLink(link, email);
  }
}

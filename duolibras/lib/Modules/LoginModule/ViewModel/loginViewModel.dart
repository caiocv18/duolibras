
import 'dart:async';

import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Commons/ViewModel/baseViewModel.dart';
import 'package:duolibras/Commons/ViewModel/screenState.dart';
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
  

  Future<bool> login(BuildContext ctx, LoginType method, {AuthenticationModel? loginModel = null}) {
    setState(ScreenState.Loading);

    Future <void> loginFuture;
    switch (method) {
      case LoginType.Google:
        loginFuture = _authenticationService.googleSignIn();
        break;
      case LoginType.Apple:
        loginFuture = _authenticationService.appleSignIn();
        break;
      case LoginType.Firebase:
        loginFuture = _authenticationService.firebaseSignIn(loginModel?.email ?? "");
        break;
    }

    return loginFuture
    .then((value) {
      setState(ScreenState.Normal);
      return true;
    })
    .onError((error, stackTrace) {
      Utils.logAppError(error);
      setState(ScreenState.Error);
      return false;
    });
  }

  Future<void> handleFirebaseEmailLinkSignIn(String email, Uri link) {
    return _authenticationService.handleFirebaseLink(link, email);
  }
}

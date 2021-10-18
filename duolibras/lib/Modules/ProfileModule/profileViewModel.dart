import 'dart:async';

import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Modules/ErrorsModule/errorHandler.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:duolibras/Services/authenticationService.dart';
import 'package:duolibras/Services/service.dart';
import 'package:flutter/material.dart';

class ProfileViewModel {
  final _errorHandler = ErrorHandler();

  Future<User> updateUser(User user) {
    return Service.instance.postUser(user, false);
  }

  Future<void> signOut() {
    return AuthenticationService.sharedInstance.signOut()
    .onError((error, stackTrace)  {
      Utils.logAppError(error);
    });
  }

  Future uploadImage(FileImage image, BuildContext context, {Function? exitClosure = null}) {
    return Service.instance.uploadImage(image)
    .onError((error, stackTrace) {
      final appError = Utils.logAppError(error);
      Completer<dynamic> completer = Completer<dynamic>();

      _errorHandler.showModal(appError, context, 
        tryAgainClosure: () => _errorHandler.tryAgainClosure(() => Service.instance.uploadImage(image), context, completer),
        exitClosure: () => completer.complete());
      return completer.future;
    });
  }
}
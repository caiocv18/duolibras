import 'dart:async';

import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Modules/ErrorsModule/errorHandler.dart';
import 'package:duolibras/Services/Models/appError.dart';
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
      final AppError appError = Utils.tryCast(error, fallback: AppError(AppErrorType.Unknown, "Erro desconhecido"));
      debugPrint("Error Profile View Model: $appError.description");
      // _errorHandler.showModal(appError, ctx, exitClosure: exitClosure);
    });
  }

  Future uploadImage(FileImage image, BuildContext context, {Function? exitClosure = null}) {
    return Service.instance.uploadImage(image)
    .onError((error, stackTrace) {
      final AppError appError = Utils.tryCast(error, fallback: AppError(AppErrorType.Unknown, "Erro desconhecido"));
      debugPrint("Error Profile View Model: $appError.description");

      Completer<dynamic> completer = Completer<dynamic>();
      _errorHandler.showModal(appError, context, tryAgainClosure: () {
        return Service.instance.uploadImage(image).then((value) => completer.complete(value))
        .onError((error, stackTrace) {
          _errorHandler.showModal(appError, context, exitClosure: () {
            if (exitClosure != null)
              exitClosure();
            completer.complete();
          });
        });
      }, exitClosure: () {
        if (exitClosure != null)
          exitClosure();
        completer.complete();
      });
      return completer.future;
    });
  }
}
import 'dart:async';

import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Modules/ErrorsModule/errorHandler.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:duolibras/Services/authenticationService.dart';
import 'package:duolibras/Services/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Future<void> uploadImage(FileImage image, BuildContext context, {Function? exitClosure = null}) {
    return Service.instance.uploadImage(image)
    .then((url) async {
      final newUser = Provider.of<UserModel>(context, listen: false);
      newUser.setImageUrl(url);

      return Service.instance.postUser(newUser.user, false)
      .catchError((error, stackTrace) {
        final appError = Utils.logAppError(error);
        Completer completer = Completer();

        _errorHandler.showModal(appError, context, 
          tryAgainClosure: () => _errorHandler.tryAgainClosure(() => Service.instance.postUser(newUser.user, false), context, completer),
          exitClosure: () => completer.complete());
        return completer.future;
      });
    })
    .catchError((error, stackTrace) {
      final appError = Utils.logAppError(error);
      Completer completer = Completer();

      _errorHandler.showModal(appError, context, 
        tryAgainClosure: () => _errorHandler.tryAgainClosure(() => Service.instance.uploadImage(image), context, completer),
        exitClosure: () => completer.complete());
      return completer.future;
    });
  }
}
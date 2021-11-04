import 'dart:async';

import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Modules/ErrorsModule/errorHandler.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:duolibras/Services/authenticationService.dart';
import 'package:duolibras/Services/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel {
  final _errorHandler = ErrorHandler();
  final newUserDefault = SharedPreferences.getInstance();

  Future<User> updateUser(User user) {
    return Service.instance.postUser(user, false);
  }

  Future<void> signOut(BuildContext context) async {
    final userProvider = Provider.of<UserModel>(context, listen: false);
    userProvider.trailSectionIndex(userProvider.user.trailSectionIndex);
    await Future.delayed(Duration(seconds: 1));
    return AuthenticationService.sharedInstance
        .signOut()
        .onError((error, stackTrace) {
      Utils.logAppError(error);
    });
  }

  Future<void> uploadImage(FileImage image, BuildContext context,
      {Function? exitClosure = null}) {
    return Service.instance.uploadImage(image).then((url) async {
      final newUser = Provider.of<UserModel>(context, listen: false);
      newUser.setImageUrl(url);

      return Service.instance
          .postUser(newUser.user, false)
          .catchError((error, stackTrace) {
        final appError = Utils.logAppError(error);
        Completer completer = Completer();

        _errorHandler.showModal(appError, context,
            tryAgainClosure: () => _errorHandler.tryAgainClosure(
                () => Service.instance.postUser(newUser.user, false),
                context,
                completer),
            exitClosure: () => completer.complete());
        return completer.future;
      });
    }).catchError((error, stackTrace) {
      final appError = Utils.logAppError(error);
      Completer completer = Completer();

      _errorHandler.showModal(appError, context,
          tryAgainClosure: () => _errorHandler.tryAgainClosure(
              () => Service.instance.uploadImage(image), context, completer),
          exitClosure: () => completer.complete());
      return completer.future;
    });
  }

  Future<HandDirection?> getHandDirection() async {
    final index =
        await newUserDefault.then((value) => value.getInt("handDirection"));

    final handDirection = index != null
        ? (index == 1 ? HandDirection.RIGHT : HandDirection.LEFT)
        : null;

    return handDirection;
  }

  Future setHandDirection(HandDirection direction) async {
    await newUserDefault
        .then((value) => value.setInt("handDirection", direction.index));
  }
}

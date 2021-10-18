import 'dart:async';

import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Modules/ErrorsModule/errorScreen.dart';
import 'package:duolibras/Services/Models/appError.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ErrorHandler {
  ErrorHandler();
  ErrorScreen? errorScreen;

  void showModal(AppError error, BuildContext context, {bool enableDrag = true, Function? tryAgainClosure = null, Function? exitClosure = null}) {
      errorScreen = ErrorScreen(error, tryAgainClosure, exitClosure);

      showCustomModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        builder: (context) => Container(),
        useRootNavigator: true,
        isDismissible: false,
        enableDrag: enableDrag, 
        containerWidget: 
        (context, animation, widget) => 
          WillPopScope(
            onWillPop: () async {  
                  if (exitClosure != null)
                    exitClosure();
                  return true;
                },
            child: SafeArea(child: errorScreen!, bottom: false)
          ),
      );
  }

  void changeScreenState({bool isLoading = false}) {
    if (errorScreen != null){
      if (errorScreen!.changeScreenState != null){
        errorScreen!.changeScreenState!(isLoading ? ErrorScreenState.Loading: ErrorScreenState.Normal);
      }
    }
  }

  Future<T?>tryAgainClosure<T>(Future<T> Function() request, BuildContext context, Completer<T> completer) {
    changeScreenState(isLoading: true);
    return request.call()
    .then((value) {
      Navigator.of(context).pop();
      completer.complete(value);
    })
    .onError((error, stackTrace) {
      Future.delayed(Duration(seconds: 2), () {})
      .then((_) {
        changeScreenState(isLoading: false);
        Utils.logAppError(error);
      });
    });
  }

}


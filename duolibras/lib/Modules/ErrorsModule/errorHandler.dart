import 'package:duolibras/Modules/ErrorsModule/errorScreen.dart';
import 'package:duolibras/Services/Models/appError.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class ErrorHandler {
  ErrorHandler();

  void showModal(AppError error, BuildContext context, {Function? tryAgainClosure = null, Function? exitClosure = null}) {
      showCustomModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        builder: (context) => Container(),
        useRootNavigator: true,
        isDismissible: false,
        enableDrag: true, 
        containerWidget: 
        (context, animation, widget) => 
          WillPopScope(
            onWillPop: () async {  
                  if (exitClosure != null)
                    exitClosure();
                  return true;
                },
            child: SafeArea(child: ErrorScreen(error, tryAgainClosure, exitClosure), bottom: false)
          ),
      );

  }

}


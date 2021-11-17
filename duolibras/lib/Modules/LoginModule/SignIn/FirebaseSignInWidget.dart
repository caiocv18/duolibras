import 'dart:ui';

import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/Constants.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/inputAnswerWidget.dart';
import 'package:duolibras/Modules/LoginModule/ViewModel/loginViewModel.dart';
import 'package:duolibras/Services/Authentication/authenticationModel.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseSignInWidget extends StatefulWidget {
  final LoginViewModel _viewModel;
  FirebaseSignInWidget(this._viewModel);

  @override
  _FirebaseSignInWidget createState() => _FirebaseSignInWidget();
}

class _FirebaseSignInWidget extends State<FirebaseSignInWidget>
    with WidgetsBindingObserver {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final emailTextfieldController = TextEditingController();
  var _isSigningIn = false;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final paddingTop = MediaQueryData.fromWindow(window).padding.top;
    final containerHeight = mediaQuery.size.height - (paddingTop);
    final containerSize = Size(mediaQuery.size.width, containerHeight);

    return Center(
        child: _isSigningIn
            ? Column(
                children: [
                  SizedBox(height: containerSize.height * 0.1),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        HexColor.fromHex("93CAFA")),
                  ),
                ],
              )
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 45.0),
                    Container(
                        child: emailTextfield(),
                        height: containerSize.height * 0.08,
                        width: containerSize.width * 0.8),
                    SizedBox(height: 35.0),
                    Container(
                        child: loginButton(context),
                        height: 50,
                        width: containerSize.width * 0.8)
                  ],
                ),
              ));
  }

  Widget emailTextfield() {
    return InputAnswerWidget(emailTextfieldController, true, "Email");
  }

  Widget loginButton(BuildContext ctx) {
    return ExerciseButton(
        child: Center(
          child: Text("Entrar",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center),
        ),
        size: 20,
        color: HexColor.fromHex("93CAFA"),
        onPressed: () => signIn(ctx));
  }

  @override
  void dispose() {
    emailTextfieldController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      if (data != null) {
        widget._viewModel
            .handleFirebaseEmailLinkSignIn(
                emailTextfieldController.text, data.link)
            .then((value) => {Navigator.of(context).pop(true)})
            .catchError((error, stackTrace) {
          print(error);
        });
      }

      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        if (dynamicLink != null) {
          final Uri deepLink = dynamicLink.link;
          widget._viewModel
              .handleFirebaseEmailLinkSignIn(
                  emailTextfieldController.text, deepLink)
              .then((value) => {Navigator.of(context).pop(true)})
              .catchError((error, stackTrace) {
            print(error);
          });
        } else {
          Navigator.of(context).pop(true);
        }
      }, onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      });
    }
  }

  void signIn(BuildContext ctx) async {
    setState(() {
      _isSigningIn = true;
    });
    await widget._viewModel
        .login(ctx, LoginType.Firebase,
            loginModel:
                AuthenticationModel(email: emailTextfieldController.text))
        .then((value) {
      setState(() {
        _isSigningIn = false;
      });
      if (emailTextfieldController.text.trim() ==
          Constants.firebaseService.emailMock) {
        Navigator.of(context).pop(true);
      }
    }).onError((error, stackTrace) {
      print(stackTrace);
    });
  }
}

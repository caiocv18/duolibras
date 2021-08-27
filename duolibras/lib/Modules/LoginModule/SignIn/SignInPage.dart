import 'package:duolibras/Modules/LoginModule/SignIn/AppleSignInWidget.dart';
import 'package:duolibras/Modules/LoginModule/SignIn/FirebaseSignInWidget.dart';
import 'package:duolibras/Modules/LoginModule/SignIn/GoogleSignInButton.dart';
import 'package:duolibras/Modules/LoginModule/ViewModel/SignInViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final signInViewModel = SignInViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FirebaseSignInWidget(signInViewModel),
              AppleSignInWidget(signInViewModel),
              GoogleSignInButton(signInViewModel)
            ],
          ),
        ));
  }
}

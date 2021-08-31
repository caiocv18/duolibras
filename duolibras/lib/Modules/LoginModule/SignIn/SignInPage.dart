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
        appBar: AppBar(title: Text("Login")),
        backgroundColor: Colors.lightBlue,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FirebaseSignInWidget(signInViewModel),
              Container(child: AppleSignInWidget(signInViewModel), width: 300),
              SizedBox(height: 15.0),
              Container(child: GoogleSignInButton(signInViewModel), width: 300)
            ],
          ),
        ));
  }
}

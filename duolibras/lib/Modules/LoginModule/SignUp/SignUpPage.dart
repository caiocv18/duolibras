import 'package:duolibras/Modules/LoginModule/SignUp/FirebaseSignUpWidget.dart';
import 'package:duolibras/Modules/LoginModule/ViewModel/SignUpViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final signUpViewModel = SignUpViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: Container(child: FirebaseSignUpWidget(signUpViewModel)));
  }
}

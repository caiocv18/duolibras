
import 'package:duolibras/Modules/LoginModule/ViewModel/autheticationViewModel.dart';
import 'package:flutter/material.dart';

import 'GoogleSignInButton.dart';
import 'appleSignInWidget.dart';
import 'firebaseSignInWidget.dart';

class SignInPage extends StatelessWidget {
  final _viewModel = AutheticationViewModel();

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 100,
      child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              FirebaseSignInWidget(_viewModel),
              Container(child: AppleSignInWidget(_viewModel), width: 300),
              SizedBox(height: 15.0),
              Container(child: GoogleSignInButton(_viewModel), width: 300)
            ],
          ),
    );
  }

}
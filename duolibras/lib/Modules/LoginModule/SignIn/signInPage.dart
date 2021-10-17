import 'package:duolibras/Commons/Components/baseScreen.dart';
import 'package:duolibras/Modules/LoginModule/ViewModel/loginViewModel.dart';
import 'package:flutter/material.dart';

import 'GoogleSignInButton.dart';
import 'appleSignInWidget.dart';
import 'firebaseSignInWidget.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen<LoginViewModel>(
        builder: (_, viewModel, __) => Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  FirebaseSignInWidget(viewModel),
                  Container(child: AppleSignInWidget(viewModel), width: 300),
                  SizedBox(height: 15.0),
                  Container(child: GoogleSignInButton(viewModel), width: 300)
                ],
              ),
            ));
  }
}

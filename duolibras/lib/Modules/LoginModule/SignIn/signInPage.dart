import 'dart:ui';

import 'package:duolibras/Commons/Components/appBarWidget.dart';
import 'package:duolibras/Commons/Components/baseScreen.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/questionWidget.dart';
import 'package:duolibras/Modules/LoginModule/ViewModel/loginViewModel.dart';
import 'package:flutter/material.dart';

import 'googleSignInButton.dart';
import 'appleSignInWidget.dart';
import 'firebaseSignInWidget.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final paddingTop = MediaQueryData.fromWindow(window).padding.top;
    final containerHeight = mediaQuery.size.height - (paddingTop);
    final containerSize = Size(mediaQuery.size.width, containerHeight);
    return Scaffold(
      appBar: AppBarWidget("Perfil", null),
      body: Stack(
        children: [
          Image.asset(
            Constants.imageAssets.background_login,
            height: containerSize.height,
            width: double.infinity,
          ),
          BaseScreen<LoginViewModel>(builder: (_, viewModel, __) {
            return Container(
              height: containerSize.height,
              color: Color.fromRGBO(234, 234, 234, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: containerHeight * 0.08),
                  Container(
                      height: containerSize.height * 0.10,
                      child: QuestionWidget(
                          "Bem-vindo ao Duolibras! \bVamos começar? ")),
                  SizedBox(height: containerHeight * 0.12),
                  Container(
                      child: FirebaseSignInWidget(viewModel),
                      width: containerSize.width * 0.8),
                  SizedBox(height: containerHeight * 0.08),
                  Container(
                    child: AppleSignInWidget(viewModel),
                    width: containerSize.width * 0.8,
                    height: containerSize.height * 0.05,
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    child: GoogleSignInButton(viewModel),
                    width: containerSize.width * 0.8,
                    height: containerSize.height * 0.07,
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

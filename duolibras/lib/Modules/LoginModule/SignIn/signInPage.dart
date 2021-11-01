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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(234, 234, 234, 1),
      appBar: AppBarWidget("Cadastro", longpressHandler: null, backButtonPressed: () {
        Navigator.of(context).pop();
      }),
      body:
          BaseScreen<LoginViewModel>(builder: (_, viewModel, __) {
            return SafeArea(
              bottom: false,
              child: 
              LayoutBuilder(builder: (ctx, constraint) {
                return Stack(
                  children: 
                    [
                      Container(
                        height: constraint.maxHeight,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                Constants.imageAssets.background_home),
                            fit: BoxFit.none,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: constraint.maxHeight * 0.08),
                          Container(
                              height: constraint.maxHeight * 0.10,
                              child: QuestionWidget(
                                  "Bem-vindo ao Duolibras! \bVamos começar? ")),
                          SizedBox(height: constraint.maxHeight * 0.12),
                          Container(
                              child: FirebaseSignInWidget(viewModel),
                              width: constraint.maxWidth * 0.8),
                          SizedBox(height: constraint.maxHeight * 0.08),
                          Container(
                            child: AppleSignInWidget(viewModel),
                            width: constraint.maxWidth * 0.8,
                            height: 40,
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            child: GoogleSignInButton(viewModel),
                            width: constraint.maxWidth * 0.8,
                            height: 60,
                          )
                        ],
                      ),
                    ),
                  ]
                );
              })
            );
          }),
    );
  }
}

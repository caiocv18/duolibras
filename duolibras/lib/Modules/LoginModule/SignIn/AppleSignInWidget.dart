import 'package:duolibras/Modules/LoginModule/ViewModel/loginViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInWidget extends StatefulWidget {
  final LoginViewModel _viewModel;
  AppleSignInWidget(this._viewModel);

  @override
  _AppleSignInWidgetState createState() => _AppleSignInWidgetState();
}

class _AppleSignInWidgetState extends State<AppleSignInWidget> {

  @override
  Widget build(BuildContext context) {
    return SignInWithAppleButton(onPressed: () => signInWithApple(context));
  }

  void signInWithApple(BuildContext ctx) async {
    widget._viewModel.login(ctx, LoginType.Apple).then((value) {
      Navigator.of(context).pop(true);
    });
  }
}

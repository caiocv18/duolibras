import 'package:duolibras/Commons/Extensions/color_extension.dart';
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
  var _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return _isSigningIn ?
        Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(HexColor.fromHex("93CAFA")),
            ),
          ) :
      SignInWithAppleButton(text: "Entrar com Apple", onPressed: () => signInWithApple(context));
  }

  void signInWithApple(BuildContext ctx) async {
    setState(() {
      _isSigningIn = true;
    });
    widget._viewModel.login(ctx, LoginType.Apple)
    .then((value) {
      setState(() {
        _isSigningIn = false;
      });
      if (value) {
          Navigator.of(context).pop(true);
      }
    });
  }
}

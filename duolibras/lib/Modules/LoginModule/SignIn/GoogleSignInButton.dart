import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Modules/LoginModule/ViewModel/loginViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatefulWidget {
  final LoginViewModel _viewModel;
  GoogleSignInButton(this._viewModel);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return _isSigningIn
        ? 
        Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(HexColor.fromHex("93CAFA")),
          ),
        )
        : OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            onPressed: () async {
              loginWithGoogle(context);
            },
            child: Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Constants.imageAssets.googleIcon),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      'Entrar com o Google',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  void loginWithGoogle(BuildContext context) async {
    setState(() {
      _isSigningIn = true;
    });
    widget._viewModel
      .login(context, LoginType.Google)
      .then((value) {
        if (value) {
            Navigator.of(context).pop(true);
        }
        setState(() {
        _isSigningIn = false;
        });
    });
  }
}

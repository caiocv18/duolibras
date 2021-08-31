import 'package:duolibras/Modules/LoginModule/ViewModel/SignInViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/learningWidget.dart';
import 'package:duolibras/Modules/LearningModule/ViewModel/learningViewModel.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInWidget extends StatefulWidget {
  final SignInViewModelProtocol _viewModel;
  AppleSignInWidget(this._viewModel);

  @override
  _AppleSignInWidgetState createState() => _AppleSignInWidgetState();
}

class _AppleSignInWidgetState extends State<AppleSignInWidget> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return SignInWithAppleButton(onPressed: () => signInWithApple());
  }

  LearningViewModelProtocol _createViewModel() {
    final LearningViewModelProtocol viewModel = LearningViewModel();
    return viewModel;
  }

  void signInWithApple() async {
    setState(() {
      _isSigningIn = true;
    });
    widget._viewModel.signInWithApple().then((value) => {
          if (value)
            {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => LearningWidget(_createViewModel())),
              )
            }
        });
    setState(() {
      _isSigningIn = false;
    });
  }
}

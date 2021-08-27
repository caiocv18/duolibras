import 'package:duolibras/Modules/LearningModule/ViewModel/learningViewModel.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/learningWidget.dart';
import 'package:duolibras/Modules/LoginModule/ViewModel/SignInViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseSignInWidget extends StatefulWidget {
  final SignInViewModelProtocol _viewModel;

  FirebaseSignInWidget(this._viewModel);

  @override
  _FirebaseSignInWidget createState() => _FirebaseSignInWidget();
}

class _FirebaseSignInWidget extends State<FirebaseSignInWidget> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final emailTextfieldController = TextEditingController();
  final passwordTextfieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 45.0),
              emailTextfield(),
              SizedBox(height: 25.0),
              passwordTextfield(),
              SizedBox(
                height: 35.0,
              ),
              loginButton(),
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailTextfieldController.dispose();
    passwordTextfieldController.dispose();
    super.dispose();
  }

  void signIn() async {
    await widget._viewModel
        .signInWithFirebase(
            emailTextfieldController.text, passwordTextfieldController.text)
        .then((value) => {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => LearningWidget(_createViewModel())),
              )
            });
  }

  LearningViewModelProtocol _createViewModel() {
    final LearningViewModelProtocol viewModel = LearningViewModel();
    return viewModel;
  }

  Widget emailTextfield() {
    return TextField(
      controller: emailTextfieldController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Widget passwordTextfield() {
    return TextField(
      controller: passwordTextfieldController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Widget loginButton() {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          signIn();
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

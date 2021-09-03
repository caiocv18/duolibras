import 'package:duolibras/Modules/LoginModule/ViewModel/autheticationViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseSignInWidget extends StatefulWidget {
  final FirebaseAuthenticatorProtocol _viewModel;

  FirebaseSignInWidget(this._viewModel);

  @override
  _FirebaseSignInWidget createState() => _FirebaseSignInWidget();
}

class _FirebaseSignInWidget extends State<FirebaseSignInWidget> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final emailTextfieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 45.0),
              emailTextfield(),
              SizedBox(height: 35.0),
              loginButton()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailTextfieldController.dispose();
    super.dispose();
  }

  void signIn() async {
    await widget._viewModel
        .firebaseSignIn(emailTextfieldController.text)
        .then((value) => {Navigator.of(context).pop(true)});
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

import 'package:duolibras/Modules/LoginModule/SignIn/AppleSignInWidget.dart';
import 'package:duolibras/Modules/LoginModule/SignIn/FirebaseSignInWidget.dart';
import 'package:duolibras/Modules/LoginModule/SignIn/GoogleSignInButton.dart';
import 'package:duolibras/Modules/LoginModule/ViewModel/SignInViewModel.dart';
import 'package:duolibras/Network/Authentication/Apple/AppleAuthenticator.dart';
import 'package:duolibras/Network/Authentication/Firebase/FirebaseAuthenticator.dart';
import 'package:duolibras/Network/Authentication/Google/GoogleAuthenticator.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Widget _buildLoggedProfile() {
    return Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Current User: ${UserSession.instance.user!.name}",
                style: TextStyle(fontSize: 22)),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Log out"),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  setState(() {
                    UserSession.instance.user = null;
                  });
                });
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.blue)))),
            )
          ],
        )));
  }

  Widget _buildUnllogedBody() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FirebaseSignInWidget(SignInViewModel(FirebaseAuthenticator())),
          Container(
              child: AppleSignInWidget(SignInViewModel(AppleAuthenticator())),
              width: 300),
          SizedBox(height: 15.0),
          Container(
              child: GoogleSignInButton(SignInViewModel(GoogleAuthenticator())),
              width: 300)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Login")),
        backgroundColor: Colors.lightBlue,
        body: UserSession.instance.user == null
            ? _buildUnllogedBody()
            : _buildLoggedProfile());
  }
}

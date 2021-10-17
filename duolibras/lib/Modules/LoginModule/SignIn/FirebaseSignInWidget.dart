import 'package:duolibras/Modules/LoginModule/ViewModel/loginViewModel.dart';
import 'package:duolibras/Services/Authentication/authenticationModel.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseSignInWidget extends StatefulWidget {
  final LoginViewModel _viewModel;
  FirebaseSignInWidget(this._viewModel);

  @override
  _FirebaseSignInWidget createState() => _FirebaseSignInWidget();
}

class _FirebaseSignInWidget extends State<FirebaseSignInWidget>
    with WidgetsBindingObserver {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final emailTextfieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

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
              loginButton(context)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailTextfieldController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      if (data != null) {
        widget._viewModel
            .handleFirebaseEmailLinkSignIn(emailTextfieldController.text, data.link)
            .then((value) => {Navigator.of(context).pop(true)});
      }

      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        if (dynamicLink != null) {
          final Uri deepLink = dynamicLink.link;
          widget._viewModel
            .handleFirebaseEmailLinkSignIn(emailTextfieldController.text, deepLink)
              .then((value) => {Navigator.of(context).pop(true)});
        }
      }, onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      });
    }
  }

  void signIn(BuildContext ctx) async {
    await widget._viewModel.login(ctx, LoginType.Firebase, loginModel: AuthenticationModel(email: emailTextfieldController.text));
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

  Widget loginButton(BuildContext ctx) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          signIn(ctx);
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Modules/LoginModule/SignIn/AppleSignInWidget.dart';
import 'package:duolibras/Modules/LoginModule/SignIn/FirebaseSignInWidget.dart';
import 'package:duolibras/Modules/LoginModule/SignIn/GoogleSignInButton.dart';
import 'package:duolibras/Modules/LoginModule/ViewModel/autheticationViewModel.dart';
import 'package:duolibras/Commons/Components/customTextfield.dart';
import 'package:duolibras/Modules/ProfileModule/profileImageButton.dart';
import 'package:duolibras/Modules/ProfileModule/progressWidget.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameTextfieldController = TextEditingController();

  final _viewModel = AutheticationViewModel();
  var _userHasChanged = false;

  Widget _buildUnllogedBody() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FirebaseSignInWidget(_viewModel),
            Container(child: AppleSignInWidget(_viewModel), width: 300),
            SizedBox(height: 15.0),
            Container(child: GoogleSignInButton(_viewModel), width: 300)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_userHasChanged);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(title: Text("Perfil")),
          backgroundColor: Colors.lightBlue,
          body: 
            Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                ProfileImageButton(),
                SizedBox(height: 40),
                Container(child: CustomTextfield(nameTextfieldController, "Rangel Dias"), width: 200),
                SizedBox(height: 60),
                Container(child: ProgressWidget(0.25)),
                SizedBox(height: 200),
                if (SharedFeatures.instance.isLoggedIn)
                ElevatedButton(
                  child: Text("Log out"),
                  onPressed: () {
                    _viewModel.signOut().then((_) {
                      setState(() {
                        _userHasChanged = true;
                      });
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.blue)))),
                )
                else 
                _buildUnllogedBody()
              ],
            )))
    ));
  }

  
}

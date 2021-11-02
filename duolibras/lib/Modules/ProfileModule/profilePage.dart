import 'dart:ui';

import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Modules/LoginModule/SignIn/signInPage.dart';
import 'package:duolibras/Commons/Components/customTextfield.dart';
import 'package:duolibras/Modules/ProfileModule/profileImageButton.dart';
import 'package:duolibras/Modules/ProfileModule/profileViewModel.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final _viewModel = ProfileViewModel();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var isLoading = false;
  final nameTextfieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, UserModel userProvider, _) {
      return SafeArea(
          bottom: false,
          child: LayoutBuilder(builder: (ctx, constraint) {
            return Stack(children: [
              Container(
                height: constraint.maxHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Constants.imageAssets.background_home),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Center(
                          child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        ProfileImageButton(
                            SharedFeatures.instance.isLoggedIn,
                            widget._viewModel,
                            userProvider.user.imageUrl,
                            () => {_onPressedLoginButton()}),
                        SizedBox(height: 60),
                        Container(
                            // height: 60,
                            child: CustomTextfield(
                                nameTextfieldController,
                                userProvider.user.name,
                                SharedFeatures.instance.isLoggedIn,
                                _handleSubmitNewName),
                            width: constraint.maxWidth * 0.8),
                        SizedBox(height: 60),
                        _createProgressWidget(userProvider.user),
                        SizedBox(height: 80),
                        Container(
                            width: constraint.maxWidth * 0.4,
                            height: 45,
                            child: ExerciseButton(
                              child: Center(
                                child: Text(SharedFeatures.instance.isLoggedIn
                                    ? "Sair"
                                    : "Entrar"),
                              ),
                              size: 20,
                              color: HexColor.fromHex("4982F6"),
                              onPressed: () => _onPressedLoginButton(),
                            )),
                        SizedBox(height: 30),
                      ],
                    ))),
            ]);
          }));
    });
  }

  Widget _createProgressWidget(User user) {
    return Stack(alignment: Alignment.center, children: [
      CircularProgressIndicator(
        backgroundColor: HexColor.fromHex("D2D7E4"),
        valueColor: AlwaysStoppedAnimation<Color>(HexColor.fromHex("4982F6")),
        value:
            (user.currentProgress / SharedFeatures.instance.numberMaxOfPoints),
        strokeWidth: 160,
      ),
      CircleAvatar(
        backgroundColor: Color.fromRGBO(234, 234, 234, 1),
        radius: 80,
      ),
      Consumer(builder: (ctx, UserModel userProvider, _) {
        return _createProgressTextWidget(userProvider.user.currentProgress /
            SharedFeatures.instance.numberMaxOfPoints);
      })
    ]);
  }

  Widget _createProgressTextWidget(double progress) {
    return Column(children: [
      Text(_getLevelTextByProgress(progress / 100),
          style: TextStyle(
              fontSize: 24,
              fontFamily: "Nunito",
              fontWeight: FontWeight.w600,
              color: Colors.black)),
      SizedBox(
        height: 4,
      ),
      Text("${(progress * 100).toStringAsFixed(2)}%",
          style: TextStyle(
              fontSize: 14,
              fontFamily: "Nunito",
              fontWeight: FontWeight.w500,
              color: Colors.black)),
    ]);
  }

  void _handleSubmitNewName(String newName) {
    if (newName.isEmpty) {
      return;
    }
    final userModel = locator<UserModel>().user;

    var user = User(
        name: nameTextfieldController.value.text,
        email: userModel.email,
        id: userModel.id,
        currentProgress: userModel.currentProgress,
        imageUrl: userModel.imageUrl);

    user.sectionsProgress = userModel.sectionsProgress;

    widget._viewModel.updateUser(user);

    final userProvider = Provider.of<UserModel>(context, listen: false);
    userProvider.setUserName(nameTextfieldController.value.text);

    // setState(() {
    //   userProvider.setUserName(newName) ;
    // });
  }

  String _getLevelTextByProgress(double progress) {
    if (progress < 0.4) {
      return "Iniciante";
    } else if (progress < 0.8) {
      return "Intermediário";
    } else {
      return "Avançado";
    }
  }

  void _onPressedLoginButton() {
    if (SharedFeatures.instance.isLoggedIn) {
      setState(() {
        isLoading = true;
      });
      widget._viewModel.signOut(context).then((value) => isLoading = false);
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignInPage()));
    }
  }
}

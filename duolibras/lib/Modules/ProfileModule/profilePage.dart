import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/LoginModule/SignIn/signInPage.dart';
import 'package:duolibras/Commons/Components/customTextfield.dart';
import 'package:duolibras/Modules/ProfileModule/profileImageButton.dart';
import 'package:duolibras/Modules/ProfileModule/profileViewModel.dart';
import 'package:duolibras/Services/Models/Providers/userViewModel.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final _viewModel = ProfileViewModel();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var isLoading = false;
  final nameTextfieldController = TextEditingController();
  late HandDirection? _handDirection;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, UserViewModel userProvider, _) {
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
                        SizedBox(height: constraint.maxHeight * 0.03),
                        ProfileImageButton(
                            SharedFeatures.instance.isLoggedIn,
                            widget._viewModel,
                            userProvider.user.imageUrl,
                            () => {_onPressedLoginButton()}),
                        SizedBox(height: constraint.maxHeight * 0.1),
                        Container(
                            height: constraint.maxHeight * 0.09,
                            child: CustomTextfield(
                                nameTextfieldController,
                                userProvider.user.name,
                                SharedFeatures.instance.isLoggedIn,
                                _handleSubmitNewName),
                            width: constraint.maxWidth * 0.75),
                        SizedBox(height: constraint.maxHeight * 0.1),
                        _createProgressWidget(userProvider.user,
                            Size(constraint.maxHeight, constraint.maxWidth)),
                        SizedBox(height: constraint.maxHeight * 0.1),
                        FutureBuilder(
                            future: _createSelectHandWidget(constraint),
                            builder: (context, snapshot) {
                              Widget? widget =
                                  Utils.tryCast(snapshot.data, fallback: null);
                              return widget ?? SizedBox.shrink();
                            }),
                        SizedBox(height: constraint.maxHeight * 0.1),
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

  Widget _createProgressWidget(User user, Size screenSize) {
    // return Container(decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: HexColor.fromHex("D2D7E4")), color: Colors.transparent));
    return Stack(alignment: Alignment.center, children: [
      Container(
        height: screenSize.width * 0.25,
        width: screenSize.width * 0.25,
        child: CircularProgressIndicator(
          backgroundColor: HexColor.fromHex("D2D7E4"),
          valueColor: AlwaysStoppedAnimation<Color>(HexColor.fromHex("4982F6")),
          value: (user.currentProgress /
              SharedFeatures.instance.numberMaxOfPoints),
          strokeWidth: screenSize.width * 0.02,
        ),
      ),
      Consumer(builder: (ctx, UserViewModel userProvider, _) {
        return _createProgressTextWidget(userProvider.user.currentProgress /
            SharedFeatures.instance.numberMaxOfPoints);
      })
    ]);
  }

  Widget _createProgressTextWidget(double progress) {
    final totalProgress = progress < 1 ? progress : 1;
    final double percentageProgress = totalProgress.toDouble();
    return Column(children: [
      AutoSizeText(_getLevelTextByProgress(percentageProgress),
          maxFontSize: 24,
          minFontSize: 20,
          maxLines: 1,
          style: TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.w600,
              color: Colors.black)),
      SizedBox(
        height: 4,
      ),
      AutoSizeText("${(percentageProgress * 100).toStringAsFixed(0)}%",
          maxFontSize: 14,
          minFontSize: 12,
          maxLines: 1,
          style: TextStyle(
              fontSize: 14,
              fontFamily: "Nunito",
              fontWeight: FontWeight.w500,
              color: Colors.black)),
    ]);
  }

  Future<Widget> _createSelectHandWidget(BoxConstraints constraints) async {
    _handDirection = await widget._viewModel.getHandDirection();

    return Container(
      width: constraints.maxWidth * 0.75,
      child: Column(
        children: <Widget>[
          AutoSizeText("Mão utilizada para fazer os gestos:",
              maxFontSize: 21,
              minFontSize: 18,
              maxLines: 2,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w700)),
          SizedBox(height: 10),
          ListTile(
            title: const AutoSizeText('Esquerda',
                maxFontSize: 20,
                minFontSize: 17,
                maxLines: 1,
                style: TextStyle(
                    fontFamily: "Nunito", fontWeight: FontWeight.w500)),
            leading: Radio<HandDirection>(
              value: HandDirection.LEFT,
              groupValue: _handDirection,
              onChanged: (HandDirection? value) {
                setState(() {
                  _handDirection = value;
                });
                widget._viewModel.setHandDirection(value!);
              },
            ),
          ),
          ListTile(
            title: const AutoSizeText('Direita',
                maxFontSize: 20,
                minFontSize: 17,
                maxLines: 1,
                style: TextStyle(
                    fontFamily: "Nunito", fontWeight: FontWeight.w500)),
            leading: Radio<HandDirection>(
              value: HandDirection.RIGHT,
              groupValue: _handDirection,
              onChanged: (HandDirection? value) {
                setState(() {
                  _handDirection = value;
                });
                widget._viewModel.setHandDirection(value!);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmitNewName(String newName) {
    if (newName.isEmpty) {
      return;
    }
    final userModel = locator<UserViewModel>().user;

    var user = User(
        name: nameTextfieldController.value.text,
        email: userModel.email,
        id: userModel.id,
        trailSectionIndex: userModel.trailSectionIndex,
        currentProgress: userModel.currentProgress,
        xpProgress: userModel.xpProgress,
        imageUrl: userModel.imageUrl);

    user.sectionsProgress = userModel.sectionsProgress;

    widget._viewModel.updateUser(user);

    final userProvider = Provider.of<UserViewModel>(context, listen: false);
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

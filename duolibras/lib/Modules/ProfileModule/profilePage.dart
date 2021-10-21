import 'dart:ui';

import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Modules/LoginModule/SignIn/signInPage.dart';
import 'package:duolibras/Commons/Components/customTextfield.dart';
import 'package:duolibras/Modules/ProfileModule/profileImageButton.dart';
import 'package:duolibras/Modules/ProfileModule/profileViewModel.dart';
import 'package:duolibras/Modules/ProfileModule/progressWidget.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileFlow extends StatefulWidget {
  static const routeProfile = '/profile';
  static const routeSignIn = '/profile/signIn';
  static const routeSettings = '/profile/settings';
  final String setupPageRoute;

  ProfileFlow({
    Key? key,
    required this.setupPageRoute,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileFlowState();
}

class _ProfileFlowState extends State<ProfileFlow> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  Route _onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case ProfileFlow.routeProfile:
        page = ProfilePage();
        break;
      case ProfileFlow.routeSignIn:
        page = SignInPage();
        break;
      case ProfileFlow.routeSettings:
        page = SignInPage();
        break;
      default:
        page = SignInPage();
    }

    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        body: Navigator(
          key: _navigatorKey,
          initialRoute: widget.setupPageRoute,
          onGenerateRoute: _onGenerateRoute,
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameTextfieldController = TextEditingController();
  final isLogged = SharedFeatures.instance.isLoggedIn;
  final _viewModel = ProfileViewModel();
  var _userHasChanged = false;
  var _userName = locator<UserModel>().user.name;

  @override
  void initState() {
    super.initState();
  }

  void _handleSubmitNewName(String newName) {
    final userModel = locator<UserModel>().user;
    var user = User(
        name: nameTextfieldController.value.text,
        email: userModel.email,
        id: userModel.id,
        currentProgress: userModel.currentProgress,
        imageUrl: userModel.imageUrl);

    user.sectionsProgress = userModel.sectionsProgress;

    _viewModel.updateUser(user);

    final userProvider = Provider.of<UserModel>(context, listen: false);
    userProvider.setUserName(nameTextfieldController.value.text);

    setState(() {
      _userName = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final paddingTop = MediaQueryData.fromWindow(window).padding.top;
    final containerHeight =
        mediaQuery.size.height - (AppBar().preferredSize.height + paddingTop);
    final containerSize = Size(mediaQuery.size.width, containerHeight);

    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(_userHasChanged);
          return true;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                height: containerHeight,
                alignment: Alignment.center,
                color: Color.fromRGBO(234, 234, 234, 1),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    ProfileImageButton(isLogged, _viewModel),
                    SizedBox(height: 60),
                    Container(
                        child: CustomTextfield(nameTextfieldController,
                            _userName, isLogged, _handleSubmitNewName),
                        width: containerSize.width * 0.8),
                    SizedBox(height: 60),
                    _createProgressWidget(),
                    SizedBox(height: containerHeight * 0.1),
                    Container(
                        width: containerSize.width * 0.4,
                        height: containerHeight * 0.05,
                        child: ExerciseButton(
                          child: Center(
                            child: Text("Log In"),
                          ),
                          size: 20,
                          color: HexColor.fromHex("4982F6"),
                          onPressed: () {
                            if (isLogged) {
                              _viewModel.signOut().then((_) {
                                setState(() {
                                  _userHasChanged = true;
                                });
                              });
                            } else {
                              Navigator.of(context)
                                  .pushNamed(ProfileFlow.routeSignIn);
                            }
                          },
                        )),
                  ],
                ))),
          ),
        ));
  }

  Widget _createProgressWidget() {
    return Stack(alignment: Alignment.center, children: [
      Consumer(builder: (ctx, UserModel userProvider, _) {
        return CircularProgressIndicator(
          backgroundColor: HexColor.fromHex("D2D7E4"),
          valueColor: AlwaysStoppedAnimation<Color>(HexColor.fromHex("4982F6")),
          value: userProvider.user.currentProgress / 100,
          strokeWidth: 150,
        );
      }),
      CircleAvatar(
        backgroundColor: Color.fromRGBO(234, 234, 234, 1),
        radius: 80,
      ),
      Consumer(builder: (ctx, UserModel userProvider, _) {
        return _createProgressTextWidget(
            userProvider.user.currentProgress / 100);
      })
    ]);
  }

  Widget _createProgressTextWidget(double progress) {
    return Column(children: [
      Text(_getLevelTextByProgress(progress),
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black)),
      SizedBox(
        height: 4,
      ),
      Text("${progress * 100} %",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black)),
    ]);
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
}

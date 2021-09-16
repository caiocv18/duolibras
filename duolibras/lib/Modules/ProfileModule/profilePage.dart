import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Modules/LoginModule/SignIn/signInPage.dart';
import 'package:duolibras/Modules/LoginModule/ViewModel/autheticationViewModel.dart';
import 'package:duolibras/Commons/Components/customTextfield.dart';
import 'package:duolibras/Modules/ProfileModule/profileImageButton.dart';
import 'package:duolibras/Modules/ProfileModule/profileViewModel.dart';
import 'package:duolibras/Modules/ProfileModule/progressWidget.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Models/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    late Widget page;
    switch (settings.name) {
      case ProfileFlow.routeProfile:
        page = ProfilePage();
        break;
      case ProfileFlow.routeSignIn:
        page = SignInPage();
        break;
      case ProfileFlow.routeSettings:
        page = SignInPage();
        ;
        break;
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

  @override
  void initState() {
    super.initState();

    nameTextfieldController.addListener(() {
      var user = User(
          name: nameTextfieldController.value.text,
          email: UserSession.instance.user.email,
          id: UserSession.instance.user.id,
          currentProgress: UserSession.instance.user.currentProgress,
          imageUrl: UserSession.instance.user.imageUrl);

      _viewModel.updateUser(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(_userHasChanged);
          return true;
        },
        child: Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                ProfileImageButton(isLogged, _viewModel),
                SizedBox(height: 40),
                Container(
                    child: CustomTextfield(nameTextfieldController,
                        "${UserSession.instance.user.name}", isLogged),
                    width: 200),
                SizedBox(height: 60),
                Container(
                    child: ProgressWidget(
                        UserSession.instance.user.currentProgress / 100)),
                SizedBox(height: 200),
                ElevatedButton(
                  child: Text(isLogged ? "Log out" : "Login"),
                  onPressed: () {
                    if (isLogged) {
                      _viewModel.signOut().then((_) {
                        setState(() {
                          _userHasChanged = true;
                        });
                      });
                    } else {
                      Navigator.of(context).pushNamed(ProfileFlow.routeSignIn);
                    }
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.blue)))),
                ),
              ],
            ))));
  }
}

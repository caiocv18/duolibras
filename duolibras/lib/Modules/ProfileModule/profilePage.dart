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
                    child: CustomTextfield(nameTextfieldController, _userName,
                        isLogged, _handleSubmitNewName),
                    width: 200),
                SizedBox(height: 60),
                Container(
                    child: ProgressWidget(
                        locator<UserModel>().user.currentProgress / 100)),
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

  void _handleSubmitNewName(String newName) {
    final userModel = locator<UserModel>().user;
    var user = User(
        name: nameTextfieldController.value.text,
        email: userModel.email,
        id: userModel.id,
        currentProgress: userModel.currentProgress,
        imageUrl: userModel.imageUrl);

    user.modulesProgress = userModel.modulesProgress;

    _viewModel.updateUser(user);

    final userProvider = Provider.of<UserModel>(context, listen: false);
    userProvider.setUserName(nameTextfieldController.value.text);

    setState(() {
      _userName = newName;
    });
  }
}

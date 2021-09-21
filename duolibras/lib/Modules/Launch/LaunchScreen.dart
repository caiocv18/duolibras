import 'package:duolibras/Modules/LearningModule/mainRouter.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Models/Provaiders/userProvider.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LaunchScreen extends StatefulWidget {
  final Function _loadCompleted;

  const LaunchScreen(this._loadCompleted);

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  var animated = false;

  var isGettingUser = false;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() {
    // final provider = Provider.of<UserProvider>(context, listen: false);
    Service.instance.getUser().then((user) {
      print("Colocou o user");
      UserSession.instance.userProvider.setNewUser(user);
      widget._loadCompleted();
      // provider.setNewUser(user);
      // Service.instance.getModulesProgress().then((progresses) {
      //   //   user.modulesProgress = progresses;

      //   print("Colocou o user2");
      //   UserSession.instance.userProvider.setNewUser(user);
      //   widget._loadCompleted();
      // }).onError((error, stackTrace) {
      //   widget._loadCompleted();
      // });
    }).onError((error, stackTrace) {
      print("error: ${error}: stackTrace ${stackTrace}");
      widget._loadCompleted();
    });
  }

  void _goHome() {
    _navigatorKey.currentState!.pushReplacementNamed(MainRouter.routeHome);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Center(
          child: AnimatedDefaultTextStyle(
        child: Text('Initializing...'),
        style: animated
            ? TextStyle(
                color: Colors.blue,
                fontSize: 26,
              )
            : TextStyle(
                color: Colors.deepOrange,
                fontSize: 14,
              ),
        duration: Duration(milliseconds: 200),
        onEnd: () {
          setState(() {
            animated = !animated;
          });
        },
      )),
    );
  }
}

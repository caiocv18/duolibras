import 'package:duolibras/Modules/LearningModule/mainRouter.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:flutter/material.dart';

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

  void getUser() async {
    Service.instance.getUser().then((user) {
      UserSession.instance.user = user;
      Service.instance.getModulesProgress().then((progresses) {
        UserSession.instance.user!.modulesProgress = progresses;
        widget._loadCompleted();
      }).onError((error, stackTrace) {
        widget._loadCompleted();
      });
    }).onError((error, stackTrace) {
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

import 'package:duolibras/Modules/ExercisesModule/exerciseFlow.dart';
import 'package:duolibras/Modules/HomeModule/homeScreen.dart';
import 'package:duolibras/Modules/Launch/launchScreen.dart';
import 'package:duolibras/Modules/ProfileModule/profilePage.dart';
import 'package:duolibras/Services/Models/exercise.dart';
import 'package:duolibras/Services/Models/module.dart';
import 'package:flutter/material.dart';

class MainRouter {
  static const routeHome = '/learningScreen';
  static const routeSignIn = '/singIn';
  static const routeLaunch = '/launchScreen';

  MainRouter._() {}

  static final instance = MainRouter._();

  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  void initialLoadCompleted() {
    navigatorKey.currentState!.pushReplacementNamed(routeHome);
  }

  Route onGenerateRoute(RouteSettings settings) {
    late Widget page;
    if (settings.name == routeHome) {
      page = HomeScreen();
    } else if (settings.name == routeSignIn) {
      page = ProfilePage();
    } else if (settings.name == routeLaunch) {
      page = LaunchScreen(initialLoadCompleted);
    } else if (settings.name!
        .startsWith(ExerciseFlow.routePrefixExerciseFlow)) {
      final arg = settings.arguments as Map<String, Object>;
      final exercises = arg["exercises"] as List<Exercise>;
      final module = arg["module"] as Module;
      final sectionID = arg["sectionID"] as String;

      exercises.sort((a,b){
        return a.order.compareTo(b.order);
      });

      page = ExerciseFlow(exercises,module,sectionID);
      
    } else {
      throw Exception('Unknown route: ${settings.name}');
    }

    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }
}

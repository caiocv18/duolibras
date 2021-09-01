import 'package:duolibras/Modules/ExercisesModule/exerciseFlow.dart';
import 'package:duolibras/Modules/Launch/LaunchScreen.dart';
import 'package:duolibras/Modules/LoginModule/SignIn/SignInPage.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:flutter/material.dart';

import 'ViewModel/learningViewModel.dart';
import 'Widgets/learningScreen.dart';

class MainRouter {
  static const routeHome = '/learningScreen';
  static const routeSignIn = '/singIn';
  static const routeLaunch = '/launchScreen';

  MainRouter._();

  static final instance = MainRouter._();

  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  void initialLoadCompleted() {
    navigatorKey.currentState!.pushReplacementNamed(routeHome);
  }

  Route onGenerateRoute(RouteSettings settings) {
    late Widget page;
    if (settings.name == routeHome) {
      page = LearningScreen(LearningViewModel());
    } else if (settings.name == routeSignIn) {
      page = SignInPage();
    } else if (settings.name == routeSignIn) {
      page = LaunchScreen(initialLoadCompleted);
    } else if (settings.name!
        .startsWith(ExerciseFlow.routePrefixExerciseFlow)) {
      final subRoute =
          settings.name!.substring(ExerciseFlow.routePrefixExerciseFlow.length);

      final arg = settings.arguments as Map<String, Object>;
      final exercises = arg["exercises"] as List<Exercise>;
      final moduleID = arg["moduleID"] as String;
      page = ExerciseFlow(
          exercises: exercises, moduleID: moduleID, setupPageRoute: subRoute);
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

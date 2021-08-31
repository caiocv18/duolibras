import 'package:duolibras/Modules/ExercisesModule/exerciseFlow.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:flutter/material.dart';

import 'ViewModel/learningViewModel.dart';
import 'Widgets/learningScreen.dart';

class MainRouter {
  static const routeHome = '/';

  MainRouter._();

  static final instance = MainRouter._();

  Route onGenerateRoute(RouteSettings settings) {
    late Widget page;
    if (settings.name == routeHome) {
      page = LearningScreen(LearningViewModel());
    } else if (settings.name!
        .startsWith(ExerciseFlow.routePrefixExerciseFlow)) {
      final subRoute =
          settings.name!.substring(ExerciseFlow.routePrefixExerciseFlow.length);

      final arg = settings.arguments as Map<String, Object>;
      final exercises = arg["exercises"] as List<Exercise>;
      page = ExerciseFlow(exercises: exercises, setupPageRoute: subRoute);
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

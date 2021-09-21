import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Modules/ExercisesModule/mlExerciseWidget.dart';

import 'package:duolibras/Modules/Launch/LaunchScreen.dart';
import 'package:duolibras/Modules/LearningModule/mainRouter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedFeatures.instance.isLoggedIn = false;
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: (settings) =>
            MainRouter.instance.onGenerateRoute(settings),
        navigatorKey: MainRouter.instance.navigatorKey,
        home: LaunchScreen(MainRouter.instance.initialLoadCompleted)

        // MLExerciseWidget()
        );
  }
}

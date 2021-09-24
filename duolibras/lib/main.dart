import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Modules/ExercisesModule/mlExerciseWidget.dart';

import 'package:duolibras/Modules/Launch/LaunchScreen.dart';
import 'package:duolibras/Modules/LearningModule/mainRouter.dart';
import 'package:duolibras/Network/Models/Provaiders/userProvider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  // Service.instance.getUser().then((user) {
  //   print(user.name);
  // });
  SharedFeatures.instance.isLoggedIn = false;
  // Service.instance.getTrail().then((trail) {
  //   print(trail.title);
  //   Service.instance.getSectionsFromTrail().then((sections) {
  //     print(sections.first.title);
  //     Service.instance
  //         .getModulesFromSectionId(sections.first.id)
  //         .then((modules) {
  //       print(modules.first.title);
  //       Service.instance
  //           .getExercisesFromModuleId(sections.first.id, modules.first.id)
  //           .then((modules) {
  //         print(modules.first.question);
  //       });
  //     });
  //   });
  // });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => locator<UserModel>(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          onGenerateRoute: (settings) =>
              MainRouter.instance.onGenerateRoute(settings),
          navigatorKey: MainRouter.instance.navigatorKey,
          home: LaunchScreen(MainRouter.instance.initialLoadCompleted)

          // MLExerciseWidget()
          ),
    );
  }
}

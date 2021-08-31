import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/exerciseWritingScreen.dart';
import 'package:duolibras/Modules/ExercisesModule/MLExerciseWidget.dart';
import 'package:duolibras/Modules/LearningModule/ViewModel/learningViewModel.dart';
import 'package:duolibras/Modules/LearningModule/mainRouter.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:duolibras/Modules/LoginModule/SignIn/SignInPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/learningScreen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'Commons/router.dart';
import 'Modules/ExercisesModule/exerciseMultiChoiceScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Service.instance.getUser().then((user) {
  //   print(user.name);
  // });
  SharedFeatures.instance.isLoggedIn = true;
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

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  LearningViewModelProtocol _createViewModel() {
    final LearningViewModelProtocol viewModel = LearningViewModel();
    return viewModel;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // routes: _routes,
        onGenerateRoute: (settings) =>
            MainRouter.instance.onGenerateRoute(settings),
        home: LearningScreen(
            LearningViewModel())); //ExerciseMultiChoiceWidget(Exercise())); //
  }
}

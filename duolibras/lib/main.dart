import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';

import 'package:duolibras/Modules/Launch/launchScreen.dart';
import 'package:duolibras/Modules/LearningModule/mainRouter.dart';
import 'package:duolibras/Services/Models/Providers/userViewModel.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();

  SharedFeatures.instance.isLoggedIn = false;
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => locator<UserViewModel>(),
      child: MaterialApp(
          title: 'Bilibras',
          theme: ThemeData(primarySwatch: Colors.blue),
          onGenerateRoute: (settings) =>
              MainRouter.instance.onGenerateRoute(settings),
          navigatorKey: MainRouter.instance.navigatorKey,
          home: LaunchScreen(MainRouter.instance.initialLoadCompleted)),
    );
  }
}

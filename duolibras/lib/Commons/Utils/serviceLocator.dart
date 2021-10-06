import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/exerciseFlow.dart';
import 'package:duolibras/Modules/LoginModule/ViewModel/autheticationViewModel.dart';
import 'package:duolibras/Network/Authentication/Apple/AppleAuthenticator.dart';
import 'package:duolibras/Network/Authentication/Firebase/FirebaseAuthenticator.dart';
import 'package:duolibras/Network/Authentication/Google/GoogleAuthenticator.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:duolibras/Network/Models/Provaiders/userProvider.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tuple/tuple.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  //Authetication
  locator.registerFactory<AppleAuthenticator>(() => AppleAuthenticator());
  locator.registerFactory<GoogleAuthenticator>(() => GoogleAuthenticator());
  locator.registerFactory<FirebaseAuthenticator>(() => FirebaseAuthenticator());
  locator
      .registerFactory<AutheticationViewModel>(() => AutheticationViewModel());

  //user
  locator.registerSingleton(UserModel());

  //Exercises
  locator.registerFactoryParam<ExerciseViewModel,
          Tuple2<List<Exercise>, Module>, ExerciseFlowDelegate>(
      (exercisesAndModule, delegate) =>
          ExerciseViewModel(exercisesAndModule, delegate));

  //service
  locator.registerSingleton(Service.instance);
}

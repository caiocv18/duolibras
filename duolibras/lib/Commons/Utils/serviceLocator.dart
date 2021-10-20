import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/exerciseFlow.dart';
import 'package:duolibras/Modules/Launch/launchViewModel.dart';
import 'package:duolibras/Modules/LoginModule/ViewModel/loginViewModel.dart';
import 'package:duolibras/Services/Models/exercise.dart';
import 'package:duolibras/Services/Models/module.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/service.dart';
import 'package:get_it/get_it.dart';
import 'package:tuple/tuple.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  //Authetication
  locator.registerFactory<LoginViewModel>(() => LoginViewModel());

//Launch
  locator.registerSingleton(LaunchViewModel());

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

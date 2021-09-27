import 'package:duolibras/Modules/LoginModule/ViewModel/autheticationViewModel.dart';
import 'package:duolibras/Network/Authentication/Apple/AppleAuthenticator.dart';
import 'package:duolibras/Network/Authentication/Firebase/FirebaseAuthenticator.dart';
import 'package:duolibras/Network/Authentication/Google/GoogleAuthenticator.dart';
import 'package:duolibras/Network/Models/Provaiders/userProvider.dart';
import 'package:get_it/get_it.dart';

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
}

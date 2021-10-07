library duolibras.globals;

enum AppEnvironment {
  PROD,
  DEV
}

class SharedFeatures {
  static SharedFeatures instance = SharedFeatures._();

  bool isLoggedIn = false;
  bool isMocked = false;
  AppEnvironment enviroment = AppEnvironment.DEV;

  var userProgress = 20;

  SharedFeatures._();
}

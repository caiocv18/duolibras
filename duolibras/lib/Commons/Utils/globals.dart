library duolibras.globals;

enum AppEnvironment { PROD, DEV }

class SharedFeatures {
  static SharedFeatures instance = SharedFeatures._();

  bool isLoggedIn = false;
  bool isMocked = false;
  AppEnvironment enviroment = AppEnvironment.PROD;
  int _numberMaxOfPoints = 0;

  int get numberMaxOfPoints => _numberMaxOfPoints;

  void setNumberMaxOfModules(int num) {
    _numberMaxOfPoints = num * 10;
  }

  SharedFeatures._();
}

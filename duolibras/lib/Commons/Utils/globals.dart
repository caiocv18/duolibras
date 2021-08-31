library duolibras.globals;

class SharedFeatures {
  static SharedFeatures instance = SharedFeatures._();

  bool isLoggedIn = false;
  bool isMocked = false;

  var userProgress = 20;

  SharedFeatures._();
}

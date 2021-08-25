library duolibras.globals;

class SharedFeatures {
  static SharedFeatures instance = SharedFeatures._();

  bool isLoggedIn = false;

  var userProgress = 20;

  SharedFeatures._();
}

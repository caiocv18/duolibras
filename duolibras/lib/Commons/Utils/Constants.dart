class Constants {
  static DatabaseConstants database = const DatabaseConstants();
  static FirebaseServiceConstants firebaseService =
      const FirebaseServiceConstants();
}

class DatabaseConstants {
  const DatabaseConstants();

  String get databaseName => "duolibras_database.db";
  String get userTable => "users";
  String get trailTable => "trails";
  String get sectionTable => "sections";
  String get moduleProgressTable => "moduleProgress";
}

class FirebaseServiceConstants {
  const FirebaseServiceConstants();

  String get usersCollection => "users";
  String get exercisesCollection => "exercises";
  String get modulesCollecion => "modules";
  String get sectionsCollection => "sections";
  String get trailsCollection => "trails";
  String get moduleProgressCollection => "moduleProgress";
}

class FirebaseAuthenticatorConstants {
  const FirebaseAuthenticatorConstants();
  String get url => "https://duolibras.page.link/naxz";
  String get iosBundleId => "com.example.duolibras";
  String get androidPackageName => "com.example.duolibras";
  String get androidMinimumVersion => "12";
}

class Constants {
  static DatabaseConstants database = const DatabaseConstants();
  static FirebaseServiceConstants firebaseService =
      const FirebaseServiceConstants();
  static ImageAssets imageAssets = const ImageAssets();
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
  String get sectionProgressCollection => "sectionProgress";
}

class FirebaseAuthenticatorConstants {
  const FirebaseAuthenticatorConstants();
  String get url => "https://duolibras.page.link/naxz";
  String get iosBundleId => "com.example.duolibras";
  String get androidPackageName => "com.example.duolibras";
  String get androidMinimumVersion => "12";
}

class ImageAssets {
  const ImageAssets();
  final _basicPath = "assets/images/";

  String get nextExerciseArrow => "${_basicPath}nextExerciseArrow/nextExerciseArrow.png";
  String get lifeIcon => "${_basicPath}tabBar/lifeIcon.png";
  String get lifeIconEmpty => "${_basicPath}tabBar/lifeIconEmpty.png";
  String get sadFace => "${_basicPath}/sadFace.png";
  String get happyFace => "${_basicPath}/happyFace.png";

}

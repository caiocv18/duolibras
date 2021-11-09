import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:flutter/material.dart';

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
  String get sectionProgressTable => "sectionProgress";
  String get modulesProgressTable => "modulesProgress";
}

class FirebaseServiceConstants {
  const FirebaseServiceConstants();

  String get usersCollection => "users";
  String get exercisesCollection => "exercises";
  String get modulesCollecion => "modules";
  String get sectionsCollection => "sections";
  String get trailsCollection => "trails";
  String get sectionProgressCollection => "sectionProgress";
  String get dynamicAssetsCollection => "dynamicAssets";
}

class FirebaseAuthenticatorConstants {
  const FirebaseAuthenticatorConstants();
  String get url => "https://duolibras.page.link/naxz";
  String get iosBundleId => "com.br.bilibras";
  String get androidPackageName => "com.br.bilibras";
  String get androidMinimumVersion => "12";
}

class ImageAssets {
  const ImageAssets();
  final _basicPath = "assets/images/";

  String get nextExerciseArrow =>
      "${_basicPath}nextExerciseArrow/nextExerciseArrow.png";
  String get lifeIcon => "${_basicPath}navBar/heartFilled.png";
  String get lifeIconEmpty => "${_basicPath}navBar/heartEmpty.png";
  String get backArrow => "${_basicPath}navBar/backArrow.png";
  String get sadFace => "${_basicPath}feedbackScreen/sadFace.png";
  String get happyFace => "${_basicPath}happyFace.png";
  String get happyFeedback => "${_basicPath}feedbackScreen/happyFeedback.png";
  String get profileEmpty => "${_basicPath}tabBar/profileEmpty.png";
  String get profileGradient => "${_basicPath}tabBar/profileGradient.png";
  String get trophyGradient => "${_basicPath}tabBar/trophyGradient.png";
  String get trophyEmpty => "${_basicPath}tabBar/trophyEmpty.png";
  String get trailEmpty => "${_basicPath}tabBar/trailEmpty.png";
  String get trailGradient => "${_basicPath}tabBar/trailGradient.png";
  String get googleIcon => "${_basicPath}google_icon.png";
  String get edit_button => "${_basicPath}profileScreen/edit_button.png";
  String get background_login =>
      "${_basicPath}background_login/background_login.png";
  String get background_home => "${_basicPath}background_home/camada_azul.png";
  String get profileCameraButton =>
      "${_basicPath}profileScreen/camera_button.png";
  String get profileEmptyPhoto => "${_basicPath}profileScreen/empty_photo.png";
}

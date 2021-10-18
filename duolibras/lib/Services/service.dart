import 'dart:async';

import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Services/Database/databaseProtocol.dart';
import 'package:duolibras/Services/Database/SQLite/sqliteDatabase.dart';
import 'package:duolibras/Services/Firebase/firebaseErrors.dart';
import 'package:duolibras/Services/Firebase/firebaseService.dart';
import 'package:duolibras/Services/Mock/mockService.dart';
import 'package:duolibras/Services/Models/appError.dart';
import 'package:duolibras/Services/Models/module.dart';
import 'package:duolibras/Services/Models/moduleProgress.dart';
import 'package:duolibras/Services/Models/section.dart';
import 'package:duolibras/Services/Models/trail.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:duolibras/Services/Models/exercise.dart';
import 'package:duolibras/Services/Protocols/servicesProtocol.dart';
import 'package:flutter/material.dart';
import 'package:username_gen/username_gen.dart';

import 'Database/databaseErrors.dart';

class Service {
  late ServicesProtocol _service;
  late DatabaseProtocol _database;
  static Service instance = Service._();

  Service._() {
    if (SharedFeatures.instance.isMocked) {
      _service = MockService();
    } else {
      _service = FirebaseService();
    }
    _database = SQLiteDatabase();
  }

  Future<List<Exercise>> getExercisesFromModuleId(String sectionId, String moduleId, int level) {
    return _service.getExercisesFromModuleId(sectionId, moduleId, level)
    .onError(_handleFirebaseException, test: (e) => e is FirebaseErrors);
  }

  Future<List<Module>> getModulesFromSectionId(String sectionId) {
    return _service.getModulesFromSectionId(sectionId)
    .onError(_handleFirebaseException, test: (e) => e is FirebaseErrors);
  }

  Future<List<Section>> getSectionsFromTrail() {
    return _service.getSectionsFromTrail()
    .onError(_handleFirebaseException, test: (e) => e is FirebaseErrors);
  }

  Future<Trail> getTrail() {
    return _service.getTrail()
    .onError(_handleFirebaseException, test: (e) => e is FirebaseErrors);
  }

  Future<User> getUser() async {
    return _service.getUser().onError((error, stackTrace) async {
      SharedFeatures.instance.isLoggedIn = false;

      return await _database.getUser()
        .onError((error, stackTrace) async {
          final randomUsername = UsernameGen().generate();
          final newUser = User(
              name: randomUsername,
              id: "",
              email: "",
              currentProgress: 0,
              imageUrl: null);
          return _database.saveUser(newUser).then((_) => newUser)
          .onError(_handleDatabaseException, test: (e) => e is DatabaseErrors);
        });
      }).then((user) async {
        user.modulesProgress = await Service.instance
            .getModulesProgress()
            .onError((error, stackTrace) {
              return [];
            });

        return user;
      });
  }

  Future<User> postUser(User user, bool isNewUser) {
    return _service.postUser(user, isNewUser)
    .onError(_handleFirebaseException, test: (e) => e is FirebaseErrors);
  }

  Future<List<ModuleProgress>> getModulesProgress() {
    if (SharedFeatures.instance.isLoggedIn) {
      return _service.getModulesProgress()
      .onError(_handleFirebaseException, test: (e) => e is FirebaseErrors);
    } else {
      return _database.getModulesProgress()
      .onError(_handleDatabaseException, test: (e) => e is DatabaseErrors);
    }
  }

  Future<bool> postModuleProgress(ModuleProgress moduleProgress) async {
    if (SharedFeatures.instance.isLoggedIn) {
      return _service.postModuleProgress(moduleProgress)
      .onError(_handleFirebaseException, test: (e) => e is FirebaseErrors);
    } else {
      return _database.saveModuleProgress(moduleProgress).then((_) => true)
      .onError(_handleDatabaseException, test: (e) => e is DatabaseErrors);
    }
  }

  Future<List<User>> getUsersRanking() {
    return _service.getUsersRanking()
    .onError(_handleFirebaseException, test: (e) => e is FirebaseErrors);
  }

  Future uploadImage(FileImage image) {
    return _service.uploadImage(image)
    .onError(_handleFirebaseException, test: (e) => e is FirebaseErrors);
  }

  Future<List<Exercise>> getANumberOfExercisesFromModuleId(String sectionId, String moduleId, int quantity) {
    return _service.getANumberOfExercisesFromModuleId(sectionId, moduleId, quantity)
    .onError(_handleFirebaseException, test: (e) => e is FirebaseErrors);
  }

  Future<void> cleanDatabase() {
    return _database.cleanDatabase()
    .onError(_handleDatabaseException, test: (e) => e is DatabaseErrors);
  }

//Error handling
  Future<T> _handleFirebaseException<T>(Object? error, StackTrace stackTrace) {
    final FirebaseErrors firebaseError = Utils.tryCast(error, fallback: FirebaseErrors.Unknown);
    return Future.error(AppError(firebaseError.type, firebaseError.errorDescription));
  }

  Future<T> _handleDatabaseException<T>(Object? error, StackTrace stackTrace) {
    final DatabaseErrors databaseError = Utils.tryCast(error, fallback: DatabaseErrors.Unknown);
    return Future.error(AppError(databaseError.type, databaseError.errorDescription));
  }

}

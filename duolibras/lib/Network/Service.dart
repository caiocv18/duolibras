import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Database/DatabaseProtocol.dart';
import 'package:duolibras/Database/SQLite/SQLiteDatabase.dart';
import 'package:duolibras/Network/Firebase/FirebaseService.dart';
import 'package:duolibras/Network/Mock/MockService.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:duolibras/Network/Models/ModuleProgress.dart';
import 'package:duolibras/Network/Models/Section.dart';
import 'package:duolibras/Network/Models/Trail.dart';
import 'package:duolibras/Network/Models/User.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Protocols/ServicesProtocol.dart';
import 'package:flutter/material.dart';
import 'package:username_gen/username_gen.dart';

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

  Future<List<Exercise>> getExercisesFromModuleId(
      String? sectionId, String moduleId, int level) {
    return _service.getExercisesFromModuleId(sectionId, moduleId, level);
  }

  Future<List<Module>> getModulesFromSectionId(String sectionId) {
    return _service.getModulesFromSectionId(sectionId);
  }

  Future<List<Section>> getSectionsFromTrail() {
    return _service.getSectionsFromTrail();
  }

  Future<Trail> getTrail() {
    return _service.getTrail();
  }

  Future<User> getUser() async {
    return _service.getUser().onError((error, stackTrace) async {
      SharedFeatures.instance.isLoggedIn = false;

      return await _database.getUser().onError((error, stackTrace) async {
        final randomUsername = UsernameGen().generate();
        final newUser = User(
            name: randomUsername,
            id: "",
            email: "",
            currentProgress: 0,
            imageUrl: null);
        return _database.saveUser(newUser).then((_) => newUser);
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
    return _service.postUser(user, isNewUser);
  }

  Future<List<ModuleProgress>> getModulesProgress() {
    if (SharedFeatures.instance.isLoggedIn) {
      return _service.getModulesProgress();
    } else {
      return _database.getModulesProgress();
    }
  }

  Future<bool> postModuleProgress(ModuleProgress moduleProgress) async {
    if (SharedFeatures.instance.isLoggedIn) {
      return _service.postModuleProgress(moduleProgress);
    } else {
      return _database.saveModuleProgress(moduleProgress).then((_) => true);
    }
  }


  Future<List<User>> getUsersRanking() {
    return _service.getUsersRanking();
  }

  Future uploadImage(FileImage image) {
    return _service.uploadImage(image);
  }

  @override
  Future<List<Exercise>> getANumberOfExercisesFromModuleId(
      String? sectionId, String moduleId, int quantity) {
    return _service.getANumberOfExercisesFromModuleId(
        sectionId, moduleId, quantity);
  }

  Future<void> cleanDatabase() {
    return _database.cleanDatabase();
  }

}

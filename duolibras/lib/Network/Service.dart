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

class Service extends ServicesProtocol {
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

  @override
  Future<List<Exercise>> getExercisesFromModuleId(
      String? sectionId, String moduleId) {
    return _service.getExercisesFromModuleId(sectionId, moduleId);
  }

  @override
  Future<List<Module>> getModulesFromSectionId(String sectionId) {
    return _service.getModulesFromSectionId(sectionId);
  }

  @override
  Future<List<Section>> getSectionsFromTrail() {
    return _service.getSectionsFromTrail();
  }

  @override
  Future<Trail> getTrail() {
    return _service.getTrail();
  }

  @override
  Future<User> getUser() {
    return _service.getUser();
  }

  @override
  Future<User> postUser(User user) {
    return _service.postUser(user);
  }

  @override
  Future<List<ModuleProgress>> getModulesProgress() {
    if (SharedFeatures.instance.isLoggedIn) {
      return _service.getModulesProgress();
    } else {
      return _database.getModulesProgress();
    }
  }

  @override
  Future<bool> postModulesProgress(List<ModuleProgress> modulesProgress) {
    if (SharedFeatures.instance.isLoggedIn) {
      return _service.postModulesProgress(modulesProgress);
    } else {
      return _database.saveModulesProgress(modulesProgress);
    }
  }
}

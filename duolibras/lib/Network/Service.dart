import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Network/Firebase/FirebaseService.dart';
import 'package:duolibras/Network/Mock/MockService.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:duolibras/Network/Models/Section.dart';
import 'package:duolibras/Network/Models/Trail.dart';
import 'package:duolibras/Network/Models/User.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Protocols/ServicesProtocol.dart';

class Service {
  late ServicesProtocol _service;
  static Service instance = Service._();

  Service._() {
    if (isLoggedIn) {
      _service = FirebaseService();
    } else {
      _service = MockService();
    }
  }

  Future<Exercise> getExerciseFromId(String exerciseId) {
    return _service.getExerciseFromId(exerciseId);
  }

  Future<Module> getModuleFromId(String moduleId) {
    return _service.getModuleFromId(moduleId);
  }

  Future<Section> getSectionFromId(String sectionId) {
    return _service.getSectionFromId(sectionId);
  }

  Future<Trail> getTrailFromId(String trailId) {
    return _service.getTrailFromId(trailId);
  }

  Future<User> getUser() {
    return _service.getUser();
  }
}

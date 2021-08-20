import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Network/Firebase/FirebaseService.dart';
import 'package:duolibras/Network/Mock/MockService.dart';
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

  Future<List<Exercise>> getExercises() {
    return _service.getExercises();
  }

  Future<User> getUser() {
    return _service.getUser();
  }
}

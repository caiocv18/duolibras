import 'package:duolibras/Network/Models/ModuleProgress.dart';
import 'package:duolibras/Network/Models/User.dart';

abstract class DatabaseProtocol {
  Future<User> getUser();
  Future<bool> saveUser(User user);
  Future<bool> updateUser(User user);
  Future<List<ModuleProgress>> getModulesProgress();
  Future<bool> saveModuleProgress(ModuleProgress moduleProgress);
}

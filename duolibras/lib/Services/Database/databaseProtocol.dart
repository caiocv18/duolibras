import 'package:duolibras/Services/Models/moduleProgress.dart';
import 'package:duolibras/Services/Models/user.dart';

abstract class DatabaseProtocol {
  Future<User> getUser();
  Future<void> saveUser(User user);
  Future<void> updateUser(User user);
  Future<List<ModuleProgress>> getModulesProgress();
  Future<void> saveModuleProgress(ModuleProgress moduleProgress);
  Future<void> cleanDatabase();
}
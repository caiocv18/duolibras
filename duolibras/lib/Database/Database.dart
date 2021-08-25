import 'package:duolibras/Database/DatabaseProtocol.dart';
import 'package:duolibras/Database/SQLite/SQLiteDatabase.dart';
import 'package:duolibras/Network/Models/ModuleProgress.dart';
import 'package:duolibras/Network/Models/User.dart';

class Database extends DatabaseProtocol {
  late DatabaseProtocol _database;
  static Database instance = Database._();

  Database._() {
    _database = SQLiteDatabase();
  }

  @override
  Future<User> getUser() async {
    return _database.getUser();
  }

  @override
  Future<bool> saveUser(User user) {
    return _database.saveUser(user);
  }

  @override
  Future<bool> updateUser(User user) async {
    return _database.updateUser(user);
  }

  @override
  Future<List<ModuleProgress>> getModuleProgress() {
    return _database.getModuleProgress();
  }

  @override
  Future<bool> saveModuleProgress(ModuleProgress moduleProgress) {
    return _database.saveModuleProgress(moduleProgress);
  }

  @override
  Future<bool> updateModuleProgress(ModuleProgress moduleProgress) {
    return _database.updateModuleProgress(moduleProgress);
  }
}

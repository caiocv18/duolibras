import 'package:duolibras/Database/DatabaseProtocol.dart';
import 'package:duolibras/Database/SQLite/SQLiteDatabase.dart';
import 'package:duolibras/Network/Models/ModuleProgress.dart';
import 'package:duolibras/Network/Models/User.dart';
import 'package:duolibras/Network/Models/sectionProgress.dart';

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
  Future<void> saveUser(User user) {
    return _database.saveUser(user);
  }

  @override
  Future<void> updateUser(User user) async {
    return _database.updateUser(user);
  }

  @override
  Future<List<SectionProgress>> getModulesProgress() {
    return _database.getModulesProgress();
  }

  @override
  Future<void> saveSectionProgress(SectionProgress sectionProgress) {
    return _database.saveSectionProgress(sectionProgress);
  }

  @override
  Future<void> cleanDatabase() {
    return _database.cleanDatabase();
  }
}

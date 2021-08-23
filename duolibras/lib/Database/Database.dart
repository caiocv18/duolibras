import 'package:duolibras/Database/DatabaseProtocol.dart';
import 'package:duolibras/Database/SQLite/SQLiteDatabase.dart';
import 'package:duolibras/Network/Models/Trail.dart';
import 'package:duolibras/Network/Models/Section.dart';
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
  Future<User> getSection() {
    return _database.getSection();
  }

  @override
  Future<User> getTrail() {
    return _database.getTrail();
  }

  @override
  Future<bool> saveSection(Section section) {
    return _database.saveSection(section);
  }

  @override
  Future<bool> saveTrail(Trail trail) {
    return _database.saveTrail(trail);
  }

  @override
  Future<bool> saveUser(User user) {
    return _database.saveUser(user);
  }
}

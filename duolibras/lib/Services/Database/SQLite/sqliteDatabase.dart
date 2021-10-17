import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Services/Database/databaseProtocol.dart';
import 'package:duolibras/Services/Models/moduleProgress.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../databaseErrors.dart';

class SQLiteDatabase extends DatabaseProtocol {
  late Future<Database> database;

  SQLiteDatabase() {
    database = _open();
  }

  Future<Database> _open() async {
    return openDatabase(
      join(await getDatabasesPath(), Constants.database.databaseName),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE ${Constants.database.userTable}(id TEXT PRIMARY KEY, name TEXT NOT NULL, email TEXT NOT NULL, currentProgress INTEGER NOT NULL)').then((_) => {
              db.execute('CREATE TABLE ${Constants.database.moduleProgressTable}(id TEXT PRIMARY KEY, moduleId TEXT, moduleProgress INTEGER)')
            });
      },
      version: 1,
    );
  }

  @override
  Future<User> getUser() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(Constants.database.userTable);

    if (maps.isEmpty){
      return Future.error(DatabaseErrors.GetUserError);
    }

    final firstUserMap = maps.first;

    return User.fromMap(firstUserMap, firstUserMap["id"]);
  }

  @override
  Future<void> saveUser(User user) async {
    final db = await database;

    final id = await db.insert(Constants.database.userTable, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    if (id == 0) {
      return Future.error(DatabaseErrors.SaveUserError);
    }

    return;
  }

  @override
  Future<void> updateUser(User user) async {
    final db = await database;

    final id = await db.update(
      Constants.database.userTable,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );

    if (id == 0) {
      return Future.error(DatabaseErrors.SaveUserError);
    }

    return;
  }

  @override
  Future<List<ModuleProgress>> getModulesProgress() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(Constants.database.moduleProgressTable);

    if (maps.isEmpty){
      return Future.error(DatabaseErrors.GetModulesProgressError);
    }

    return List.generate(maps.length, (i) {
      return ModuleProgress.fromMap(maps[i], maps[i]['id']);
    });
  }

  @override
  Future<void> saveModuleProgress(ModuleProgress moduleProgress) async {
    final db = await database;
    final id = await db
        .insert(Constants.database.moduleProgressTable, moduleProgress.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);

    if (id == 0) {
      return Future.error(DatabaseErrors.SaveModulesProgressError);
    }

    return;
  }

  @override
  Future<void> cleanDatabase() async {
    final db = await database;

    int changesInUserTable = await db.rawDelete('DELETE FROM ${Constants.database.userTable}');
    int changesInModulesTable = await db.rawDelete('DELETE FROM ${Constants.database.moduleProgressTable}');

    if (changesInUserTable == 0 || changesInModulesTable == 0){
      return Future.error(DatabaseErrors.CleanDatabaseError);
    }

    return;
  }
}

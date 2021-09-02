import 'package:duolibras/Commons/Utils/Constants.dart';
import 'package:duolibras/Database/DatabaseProtocol.dart';
import 'package:duolibras/Network/Models/ModuleProgress.dart';
import 'package:duolibras/Network/Models/User.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
            'CREATE TABLE ${Constants.database.moduleProgressTable}(id TEXT PRIMARY KEY, moduleId TEXT, moduleProgress INTEGER)');
      },
      version: 1,
    );
  }

  @override
  Future<User> getUser() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(Constants.database.userTable);

    final firstUserMap = maps.first;

    return User.fromMap(firstUserMap, firstUserMap["id"]);
  }

  @override
  Future<bool> saveUser(User user) async {
    final db = await database;

    final id = await db.insert(Constants.database.userTable, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id != 0;
  }

  @override
  Future<bool> updateUser(User user) async {
    final db = await database;

    final id = await db.update(
      Constants.database.userTable,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );

    return id != 0;
  }

  @override
  Future<List<ModuleProgress>> getModulesProgress() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(Constants.database.moduleProgressTable);

    return List.generate(maps.length, (i) {
      return ModuleProgress.fromMap(maps[i], maps[i]['id']);
    });
  }

  @override
  Future<bool> saveModuleProgress(ModuleProgress moduleProgress) async {
    var completer = Completer<bool>();
    final db = await database;
    await db
        .insert(Constants.database.moduleProgressTable, moduleProgress.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => {completer.complete(true)});
    return completer.future;
  }
}

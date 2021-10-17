import 'package:duolibras/Commons/Utils/Constants.dart';
import 'package:duolibras/Database/DatabaseProtocol.dart';
import 'package:duolibras/Database/SQLite/SQLiteDatabaseErrors.dart';
import 'package:duolibras/Network/Models/ModuleProgress.dart';
import 'package:duolibras/Network/Models/User.dart';
import 'package:duolibras/Network/Models/sectionProgress.dart';
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
        return db
            .execute(
                'CREATE TABLE ${Constants.database.userTable}(id TEXT PRIMARY KEY, name TEXT NOT NULL, email TEXT NOT NULL, currentProgress INTEGER NOT NULL)')
            .then((_) => {
                  db.execute(
                      'CREATE TABLE ${Constants.database.moduleProgressTable}(id TEXT PRIMARY KEY, moduleId TEXT, moduleProgress INTEGER)')
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

    if (maps.isEmpty) {
      throw SQLiteDatabaseErrors.UserError;
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
      throw SQLiteDatabaseErrors.UserError;
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
      throw SQLiteDatabaseErrors.UserError;
    }

    return;
  }

  @override
  Future<List<SectionProgress>> getModulesProgress() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(Constants.database.moduleProgressTable);

    if (maps.isEmpty) {
      throw SQLiteDatabaseErrors.ModuleProgressError;
    }

    return List.generate(maps.length, (i) {
      return SectionProgress.fromMap(maps[i], maps[i]['id']);
    });
  }

  @override
  Future<void> cleanDatabase() async {
    var completer = Completer<void>();
    final db = await database;

    db.rawDelete('DELETE FROM ${Constants.database.userTable}').then((_) => {
          db
              .rawDelete(
                  'DELETE FROM ${Constants.database.moduleProgressTable}')
              .then((_) => {completer.complete()})
        });

    return completer.future;
  }

  @override
  Future<void> saveSectionProgress(SectionProgress sectionProgress) async {
    var completer = Completer<void>();
    final db = await database;
    await db
        .insert(Constants.database.moduleProgressTable, sectionProgress.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => {completer.complete()});
    return completer.future;
  }
}

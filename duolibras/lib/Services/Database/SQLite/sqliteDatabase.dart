import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Services/Models/sectionProgress.dart';
import 'package:duolibras/Services/Database/databaseProtocol.dart';
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
        return db
            .execute(
                'CREATE TABLE ${Constants.database.userTable}(id TEXT PRIMARY KEY, name TEXT NOT NULL, email TEXT NOT NULL, currentProgress INTEGER NOT NULL,trailSectionIndex INTEGER NOT NULL)')
            .then((_) => {
                  db.execute(
                      'CREATE TABLE ${Constants.database.sectionProgressTable}(id TEXT PRIMARY KEY, sectionId TEXT NOT NULL, progress INTEGER)')
                })
            .then((value) => {
                  db.execute(
                      'CREATE TABLE ${Constants.database.modulesProgressTable}(id TEXT PRIMARY KEY, maxModuleProgress INTEGER NOT NULL, moduleId TEXT NOT NULL, moduleProgress INTEGER, sectionId TEXT NOT NULL, FOREIGN KEY (sectionId) REFERENCES ${Constants.database.sectionProgressTable} (sectionId) ON DELETE CASCADE ON UPDATE CASCADE)')
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
  Future<void> saveSectionProgress(SectionProgress sectionProgress) async {
    var completer = Completer<void>();
    final db = await database;
    await db
        .insert(Constants.database.sectionProgressTable,
            sectionProgress.toMapLocal(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((_) => {
              Future.sync(() => sectionProgress
                      .modulesProgressToMap()
                      .forEach((moduleMap) async {
                    await db.insert(
                        Constants.database.modulesProgressTable, moduleMap,
                        conflictAlgorithm: ConflictAlgorithm.replace);
                  })).then((_) => completer.complete())
            });
    return completer.future;
  }

  @override
  Future<void> cleanDatabase() async {
    final db = await database;

    int changesInUserTable =
        await db.rawDelete('DELETE FROM ${Constants.database.userTable}');
    // int changesInModulesTable = await db
    //     .rawDelete('DELETE FROM ${Constants.database.sectionProgressTable}');

    if (changesInUserTable == 0) {
      return Future.error(DatabaseErrors.CleanDatabaseError);
    }

    return;
  }

  @override
  Future<List<SectionProgress>> getSectionProgress() async {
    final db = await database;

    final List<Map<String, dynamic>> sectionsMaps =
        await db.query(Constants.database.sectionProgressTable);

    final List<Map<String, dynamic>> modulesMaps =
        await db.query(Constants.database.modulesProgressTable);

    if (sectionsMaps.isEmpty || modulesMaps.isEmpty) {
      return Future.error(DatabaseErrors.GetModulesProgressError);
    }

    return List.generate(sectionsMaps.length, (i) {
      final moduleProgressMapList = modulesMaps.where(
          (element) => element["sectionId"] == sectionsMaps[i]["sectionId"]);

      return SectionProgress.fromMapLocal(sectionsMaps[i],
          moduleProgressMapList.toList(), sectionsMaps[i]['id']);
    });
  }
}

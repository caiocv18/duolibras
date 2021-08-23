import 'package:duolibras/Commons/Utils/Constants.dart';
import 'package:duolibras/Database/DatabaseProtocol.dart';
import 'package:duolibras/Network/Models/Trail.dart';
import 'package:duolibras/Network/Models/Section.dart';
import 'package:duolibras/Network/Models/User.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDatabase extends DatabaseProtocol {
  late Future<Database> database;

  SQLiteDatabase() {
    _open();
  }

  void _open() async {
    database = openDatabase(
      join(await getDatabasesPath(), Constants.database.databaseName),
      onCreate: (db, version) {
        return db
            .execute(
                'CREATE TABLE ${Constants.database.userTable}(id TEXT PRIMARY KEY, name TEXT)')
            .then((value) {
          db
              .execute(
                  'CREATE TABLE ${Constants.database.trailTable}(id TEXT PRIMARY KEY, title TEXT, userId NOT NULL REFERENCES users(id))')
              .then((value) {
            db.execute(
                'CREATE TABLE ${Constants.database.sectionTable}(id TEXT PRIMARY KEY, title TEXT, trailId NOT NULL REFERENCES trails(id))');
          });
        });
      },
      version: 1,
    );
  }

  @override
  Future<User> getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<User> getSection() {
    // TODO: implement getSection
    throw UnimplementedError();
  }

  @override
  Future<User> getTrail() {
    // TODO: implement getTrail
    throw UnimplementedError();
  }

  @override
  Future<bool> saveUser(User user) async {
    var completer = Completer<bool>();

    database.then((database) => {
          completer.complete(database.insert(
                  Constants.database.userTable, user.toMap(),
                  conflictAlgorithm: ConflictAlgorithm.replace) !=
              0)
        });

    return completer.future;
  }

  @override
  Future<bool> saveSection(Section section) async {
    final db = await database;

    final id = await db.insert(Constants.database.userTable, section.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id != 0;
  }

  @override
  Future<bool> saveTrail(Trail trail) async {
    final db = await database;

    final id = await db.insert(Constants.database.userTable, trail.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id != 0;
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// This class will hold all SQL Lite related methods
class Sql {
  String table;
  int version;

  // Creating constructor
  Sql({required this.table, required this.version});

  // Declaring database object
  static Database? _db;

  // Defining database object
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  // Initializing database object
  initialDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'leo.db');
    Database database = await openDatabase(path,
        onCreate: createDataBase, version: version, onUpgrade: upgradeDataBase);
    return database;
  }

  // Method used for Creating database
  createDataBase(Database db, int version) async {
    await db.execute(
        'CREATE TABLE "notes" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"title" TEXT NOT NULL,"subtitle" TEXT NOT NULL, "clock" TEXT NOT NULL)');
    version = 1;
  }

  // Method used for Updating Database
  upgradeDataBase(Database db, int oldVersion, int newVersion) async {
    await db.execute(
        'CREATE TABLE "todo" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"title" TEXT NOT NULL,"subtitle" TEXT NOT NULL, "clock" TEXT NOT NULL)');
    oldVersion = 1;
    newVersion = 2;
  }

  // Method used for Inserting values in database
  insertDatabase(String title, String subtitle, String clock) async {
    Database? mydb = await db;
    int id1 = await mydb!.rawInsert(
      '''
        INSERT INTO "$table" ("title", "subtitle", "clock") VALUES("$title", "$subtitle", "$clock")''',
    );
    return id1;
  }

// Method used for Fetching data from database or Reading database
  Future<List<Map>> getRecords() async {
    Database? mydb = await db;
    List<Map> list = await mydb!.rawQuery("SELECT * FROM $table");
    return list;
  }

// Method used for Deleting a column
  deleteColumn(String id) async {
    Database? mydb = await db;
    int response = await mydb!.delete("$table WHERE id = $id");
    return response;
  }

  // Method used for Deleting database
  deleteDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'leo.db');
    await deleteDatabase(path);
  }
}

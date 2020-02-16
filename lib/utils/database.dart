import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/Cleaner.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String nameTable = 'cleaner_table';
  String colId = 'id';
  String colName = 'name';
  String colDescription = 'cleaningCompletion';


  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $nameTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, '
        '$colDescription TEXT)');
  }

  Future<List<Map<String, dynamic>>> getCleanerMapList() async {
    Database db = await this.database;
    var result = await db.query(nameTable);
    return result;
  }

  Future<int> insertCleaning(Cleaner cleaning) async {
    Database db = await this.database;
    var result = await db.insert(nameTable, cleaning.toMap());
    return result;
  }

//  Future<int> updateCleaning(Cleaner cleaning) async {
//    var db = await this.database;
//    var result = await db.update(nameTable, cleaning.toMap(),  whereArgs: [cleaning.id]);
//    return result;
//  }

  Future<int> deleteCleaning(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $nameTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $nameTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Cleaner>> getCleanerList() async {
    var noteMapList = await getCleanerMapList();
    int count = noteMapList.length;

    List<Cleaner> noteList = List<Cleaner>();
    for (int i = 0; i < count; i++) {
      noteList.add(Cleaner.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }

}
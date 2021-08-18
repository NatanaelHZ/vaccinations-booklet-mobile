import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../models/Vaccine.dart';
import 'dart:io';
import 'dart:async';


class VaccineDbProvider {
  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "vaccines_development.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("""
          CREATE TABLE vaccines(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            scheduled_at DATETIME)"""
        );
      }
    );
  }

  Future<int> addItem(Vaccine item) async{ //returns number of items inserted as an integer
    final db = await init(); //open database
    return db.insert("vaccines", item.toMap(), //toMap() function from Vaccine
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<List<Vaccine>> fetchVaccines() async{ //returns the memos as a list (array)
    final db = await init();
    final maps = await db.query("vaccines"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) { //create a list of memos
      return Vaccine(              
        id: maps[i]['id'],
        title: maps[i]['title'],
        // scheduledAt: maps[i]['scheduled_at'],
      );
    });
  }

  Future<int> deleteVaccine(int id) async{ //returns number of items deleted
    final db = await init();
  
    int result = await db.delete(
      "vaccines", //table name
      where: "id = ?",
      whereArgs: [id] // use whereArgs to avoid SQL injection
    );

    return result;
  }

  Future<int> updateVaccine(int id, Vaccine item) async{ // returns the number of rows updated
    final db = await init();
    int result = await db.update(
      "vaccines", 
      item.toMap(),
      where: "id = ?",
      whereArgs: [id]
    );
    return result;
 }
}
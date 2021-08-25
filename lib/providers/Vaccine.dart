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
            title TEXT
          )"""
        );
      }
    );
  }

  Future<int> addItem(Vaccine item) async{ //
    final db = await init();
    return db.insert("vaccines", item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Vaccine>> fetchVaccines() async{
    final db = await init();
    final maps = await db.query("vaccines");

    return List.generate(maps.length, (i) {
      return Vaccine(              
        id: maps[i]['id'],
        title: maps[i]['title'],
       
      );
    });
  }

  Future<int> deleteVaccine(int id) async{
    final db = await init();
  
    int result = await db.delete(
      "vaccines",
      where: "id = ?",
      whereArgs: [id]
    );

    return result;
  }

  Future<int> updateVaccine(int id, Vaccine item) async{
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
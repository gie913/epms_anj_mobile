import 'package:epms/database/entity/team_inspection_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/team_inspection_model.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseTeamInspection {
  void createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $teamInspectionTable(
       ${TeamInspectionEntity.id} TEXT,
       ${TeamInspectionEntity.name} TEXT,
       ${TeamInspectionEntity.code} TEXT)
    ''');
  }

  static Future<void> insetData(List<TeamInspectionModel> data) async {
    Database db = await DatabaseHelper().database;
    final batch = db.batch();

    for (final item in data) {
      batch.insert(teamInspectionTable, item.toDatabase());
    }
    await batch.commit();
  }

  static Future<List<TeamInspectionModel>> selectData() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(teamInspectionTable);
    var data = List<TeamInspectionModel>.from(mapList.map((e) {
      return TeamInspectionModel.fromDatabase(e);
    }));
    return data;
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(teamInspectionTable);
  }
}

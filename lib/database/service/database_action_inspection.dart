import 'package:epms/database/entity/action_inspection_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/action_inspection_model.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseActionInspection {
  void createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $actionInspectionTable(
       ${ActionInspectionEntity.name} TEXT,
       ${ActionInspectionEntity.options} TEXT)
    ''');
  }

  static Future<void> insetData(List<ActionInspectionModel> data) async {
    Database db = await DatabaseHelper().database;
    final batch = db.batch();

    for (final item in data) {
      batch.insert(actionInspectionTable, item.toDatabase());
    }
    await batch.commit();
  }

  static Future<ActionInspectionModel> selectDataByStatus(String status) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(
      actionInspectionTable,
      where: "${ActionInspectionEntity.name}=?",
      whereArgs: [status],
    );
    ActionInspectionModel data =
        ActionInspectionModel.fromDatabase(mapList.first);
    return data;
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(actionInspectionTable);
  }
}

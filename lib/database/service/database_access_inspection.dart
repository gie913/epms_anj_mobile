import 'package:epms/database/entity/access_inspection_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/inspection_access_model.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseAccessInspection {
  void createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $accessInspectionTable(
       ${AccessInspectionEntity.id} TEXT,
       ${AccessInspectionEntity.mModuleId} TEXT,
       ${AccessInspectionEntity.mRoleId} TEXT,
       ${AccessInspectionEntity.canCreate} INTEGER,
       ${AccessInspectionEntity.canUpdate} INTEGER,
       ${AccessInspectionEntity.canDelete} INTEGER,
       ${AccessInspectionEntity.isActive} INTEGER)
    ''');
  }

  static Future<void> insetData(List<InspectionAccessModel> data) async {
    Database db = await DatabaseHelper().database;
    final batch = db.batch();

    for (final item in data) {
      batch.insert(accessInspectionTable, item.toJson());
    }
    await batch.commit();
  }

  static Future<InspectionAccessModel> selectData() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(accessInspectionTable);
    InspectionAccessModel data = InspectionAccessModel.fromJson(mapList.first);
    return data;
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(accessInspectionTable);
  }
}

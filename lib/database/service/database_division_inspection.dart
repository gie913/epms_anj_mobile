import 'package:epms/database/entity/division_inspection_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/division_inspection_model.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseDivisionInspection {
  void createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $divisionInspectionTable(
       ${DivisionInspectionEntity.id} TEXT,
       ${DivisionInspectionEntity.name} TEXT,
       ${DivisionInspectionEntity.code} TEXT,
       ${DivisionInspectionEntity.estateCode} TEXT,
       ${DivisionInspectionEntity.mCompanyId} TEXT)
    ''');
  }

  static Future<void> insetData(List<DivisionInspectionModel> data) async {
    Database db = await DatabaseHelper().database;
    final batch = db.batch();

    for (final item in data) {
      batch.insert(divisionInspectionTable, item.toJson());
    }
    await batch.commit();
  }

  static Future<List<DivisionInspectionModel>> selectDataByCompanyId(
      {required String companyId, required String estateCode}) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(
      divisionInspectionTable,
      where:
          '${DivisionInspectionEntity.mCompanyId}=? AND ${DivisionInspectionEntity.estateCode}=?',
      whereArgs: [companyId, estateCode],
    );
    List<DivisionInspectionModel> data =
        List<DivisionInspectionModel>.from(mapList.map((e) {
      return DivisionInspectionModel.fromJson(e);
    }));
    return data;
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(divisionInspectionTable);
  }
}

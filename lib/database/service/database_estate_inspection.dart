import 'package:epms/database/entity/estate_inspection_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/estate_inspection_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseEstateInspection {
  void createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $estateInspectionTable(
       ${EstateInspectionEntity.id} TEXT,
       ${EstateInspectionEntity.name} TEXT,
       ${EstateInspectionEntity.code} TEXT,
       ${EstateInspectionEntity.mCompanyId} TEXT)
    ''');
  }

  static Future<void> insetData(List<EstateInspectionModel> data) async {
    Database db = await DatabaseHelper().database;

    for (var i = 0; i < data.length; i++) {
      await db.insert(estateInspectionTable, data[i].toJson());
    }
  }

  static Future<List<EstateInspectionModel>> selectData(
    String companyId,
  ) async {
    Database db = await DatabaseHelper().database;

    var mapList = await db.query(
      estateInspectionTable,
      where: '${EstateInspectionEntity.mCompanyId}=?',
      whereArgs: [companyId],
    );
    var data = List<EstateInspectionModel>.from(mapList.map((e) {
      return EstateInspectionModel.fromJson(e);
    }));
    return data;
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(estateInspectionTable);
  }
}

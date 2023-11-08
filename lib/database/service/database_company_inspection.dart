import 'package:epms/database/entity/company_inspection_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/company_inspection_model.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseCompanyInspection {
  void createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $companyInspectionTable(
       ${CompanyInspectionEntity.id} TEXT,
       ${CompanyInspectionEntity.name} TEXT,
       ${CompanyInspectionEntity.code} TEXT,
       ${CompanyInspectionEntity.alias} TEXT)
    ''');
  }

  static Future<void> insetData(List<CompanyInspectionModel> data) async {
    Database db = await DatabaseHelper().database;
    final batch = db.batch();

    for (final item in data) {
      batch.insert(companyInspectionTable, item.toJson());
    }
    await batch.commit();
  }

  static Future<List<CompanyInspectionModel>> selectData() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(companyInspectionTable);
    List<CompanyInspectionModel> data =
        List<CompanyInspectionModel>.from(mapList.map((e) {
      return CompanyInspectionModel.fromJson(e);
    }));
    return data;
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(companyInspectionTable);
  }
}

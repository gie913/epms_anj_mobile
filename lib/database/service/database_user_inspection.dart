import 'package:epms/database/entity/user_inspection_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/user_inspection_model.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseUserInspection {
  void createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $userInspectionTable(
       ${UserInspectionEntity.id} TEXT,
       ${UserInspectionEntity.name} TEXT,
       ${UserInspectionEntity.employeeCode} TEXT,
       ${UserInspectionEntity.employeeNumber} TEXT)
    ''');
  }

  static Future<void> insetData(List<UserInspectionModel> data) async {
    Database db = await DatabaseHelper().database;
    final batch = db.batch();

    for (final item in data) {
      batch.insert(userInspectionTable, item.toJson());
    }
    await batch.commit();
  }

  static Future<List<UserInspectionModel>> selectData() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(userInspectionTable);
    var data = List<UserInspectionModel>.from(mapList.map((e) {
      return UserInspectionModel.fromJson(e);
    }));
    return data;
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(userInspectionTable);
  }
}

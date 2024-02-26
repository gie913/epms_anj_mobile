import 'package:epms/database/entity/user_inspection_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/database/service/database_user_inspection_config.dart';
import 'package:epms/model/user_inspection_model.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseUserInspection {
  void createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $userInspectionTable(
       ${UserInspectionEntity.id} TEXT,
       ${UserInspectionEntity.code} TEXT,
       ${UserInspectionEntity.name} TEXT,
       ${UserInspectionEntity.employeeCode} TEXT,
       ${UserInspectionEntity.employeeNumber} TEXT,
       ${UserInspectionEntity.userEstate} TEXT,
       ${UserInspectionEntity.userDivision} TEXT,
       ${UserInspectionEntity.mCompanyId} TEXT,
       ${UserInspectionEntity.mOccupationName} TEXT)
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

  static Future<List<UserInspectionModel>> selectData(
      String userId, String companyId) async {
    Database db = await DatabaseHelper().database;

    // Hide User Login From User Assign List
    final dataUser = await DatabaseUserInspectionConfig.selectData();

    if (userId.isNotEmpty) {
      var mapList = await db.query(
        userInspectionTable,
        where: '${UserInspectionEntity.id}=?',
        whereArgs: [userId],
      );

      var data = List<UserInspectionModel>.from(mapList.map((e) {
        return UserInspectionModel.fromJson(e);
      }));

      // Hide User Login From User Assign List
      // final userInspection = data.where((element) => element.id == dataUser.id);
      // if (userInspection.isNotEmpty) {
      //   data.remove(userInspection.first);
      // }

      return data;
    } else if (companyId.isNotEmpty) {
      var mapList = await db.query(
        userInspectionTable,
        where: '${UserInspectionEntity.mCompanyId}=?',
        whereArgs: [companyId],
      );

      var data = List<UserInspectionModel>.from(mapList.map((e) {
        return UserInspectionModel.fromJson(e);
      }));

      // Hide User Login From User Assign List
      // final userInspection = data.where((element) => element.id == dataUser.id);
      // if (userInspection.isNotEmpty) {
      //   data.remove(userInspection.first);
      // }

      return data;
    } else {
      var mapList = await db.query(userInspectionTable);

      var data = List<UserInspectionModel>.from(mapList.map((e) {
        return UserInspectionModel.fromJson(e);
      }));

      // Hide User Login From User Assign List
      final userInspection = data.where((element) => element.id == dataUser.id);
      if (userInspection.isNotEmpty) {
        data.remove(userInspection.first);
      }

      return data;
    }
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(userInspectionTable);
  }
}

import 'package:epms/database/entity/user_inspection_config_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/user_inspection_config_model.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseUserInspectionConfig {
  void createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $userInspectionConfigTable(
       ${UserInspectionConfigEntity.id} TEXT,
       ${UserInspectionConfigEntity.code} TEXT,
       ${UserInspectionConfigEntity.name} TEXT,
       ${UserInspectionConfigEntity.email} TEXT,
       ${UserInspectionConfigEntity.emailVerifiedAt} TEXT,
       ${UserInspectionConfigEntity.mRoleId} TEXT,
       ${UserInspectionConfigEntity.username} TEXT,
       ${UserInspectionConfigEntity.address} TEXT,
       ${UserInspectionConfigEntity.gender} TEXT,
       ${UserInspectionConfigEntity.rememberToken} TEXT,
       ${UserInspectionConfigEntity.mCompanyId} TEXT,
       ${UserInspectionConfigEntity.mEmployeeHrisId} TEXT,
       ${UserInspectionConfigEntity.phoneNumber} TEXT,
       ${UserInspectionConfigEntity.lastLogin} TEXT,
       ${UserInspectionConfigEntity.loginStatus} TEXT,
       ${UserInspectionConfigEntity.lastConnected} TEXT,
       ${UserInspectionConfigEntity.mOccupationId} TEXT,
       ${UserInspectionConfigEntity.mDepartmentId} TEXT,
       ${UserInspectionConfigEntity.mMillId} TEXT,
       ${UserInspectionConfigEntity.groupName} TEXT,
       ${UserInspectionConfigEntity.level} INTEGER,
       ${UserInspectionConfigEntity.employeeCode} TEXT,
       ${UserInspectionConfigEntity.employeeNumber} TEXT,
       ${UserInspectionConfigEntity.supervisorEmployeeCode} TEXT,
       ${UserInspectionConfigEntity.isActive} INTEGER,
       ${UserInspectionConfigEntity.createdAt} TEXT,
       ${UserInspectionConfigEntity.createdBy} TEXT,
       ${UserInspectionConfigEntity.updatedAt} TEXT,
       ${UserInspectionConfigEntity.updatedBy} TEXT)
    ''');
  }

  static Future<void> insetData(UserInspectionConfigModel data) async {
    Database db = await DatabaseHelper().database;
    await db.insert(userInspectionConfigTable, data.toJson());
  }

  static Future<UserInspectionConfigModel> selectData() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(userInspectionConfigTable);
    UserInspectionConfigModel data =
        UserInspectionConfigModel.fromJson(mapList.first);
    return data;
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(userInspectionConfigTable);
  }
}

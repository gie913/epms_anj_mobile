
import 'package:epms/database/entity/m_config_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/login_response.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseMConfig {
  void createTableMConfig(Database db) async {
    await db.execute('''
      CREATE TABLE $mConfigSchemaTable(
       ${MConfigEntity.userId} INT NOT NULL,
       ${MConfigEntity.configId} INT NOT NULL,
       ${MConfigEntity.configIdOld} INT,
       ${MConfigEntity.userToken} TEXT,
       ${MConfigEntity.userLogin} TEXT,
       ${MConfigEntity.serverDate} TEXT,
       ${MConfigEntity.serverTime} TEXT,
       ${MConfigEntity.profileName} TEXT,
       ${MConfigEntity.profileCode} TEXT,
       ${MConfigEntity.companyName} TEXT,
       ${MConfigEntity.companyCode} TEXT,
       ${MConfigEntity.estateName} TEXT,
       ${MConfigEntity.estateCode} TEXT,
       ${MConfigEntity.plantCode} TEXT,
       ${MConfigEntity.createdBy} TEXT,
       ${MConfigEntity.createdDate} TEXT,
       ${MConfigEntity.createdTime} TEXT,
       ${MConfigEntity.updatedBy} TEXT,
       ${MConfigEntity.updatedDate} TEXT,
       ${MConfigEntity.updatedTime} TEXT,
       ${MConfigEntity.employeeCode} TEXT,
       ${MConfigEntity.employeeName} TEXT,
       ${MConfigEntity.mCompanyId} TEXT,
       ${MConfigEntity.apiRoot} TEXT,
       ${MConfigEntity.loginDate} TEXT,
       ${MConfigEntity.loginTime} TEXT)
    ''');
  }

  static Future<int> insertMConfig(LoginResponse object) async {
    Database db = await DatabaseHelper().database;
    int count = await db.insert(mConfigSchemaTable, object.toJson());
    return count;
  }

  Future<MConfigSchema> selectMConfig() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mConfigSchemaTable);
    MConfigSchema mConfigSchema =
    MConfigSchema.fromJson(mapList.last);
    return mConfigSchema;
  }

  void deleteMConfig() async {
    Database db = await DatabaseHelper().database;
    db.delete(mConfigSchemaTable);
  }
}

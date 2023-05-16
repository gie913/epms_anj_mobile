import 'package:epms/database/entity/t_user_assignment_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/t_user_assignment_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseTUserAssignment {
  void createTableUserAssignmentSchema(Database db) async {
    await db.execute('''
      CREATE TABLE $tUserAssignmentSchemaTable(
       ${TUserAssignmentEntity.mandorId} INT NOT NULL,
       ${TUserAssignmentEntity.estateCode} TEXT,
       ${TUserAssignmentEntity.mandor1EmployeeCode} TEXT,
       ${TUserAssignmentEntity.mandor1EmployeeName} TEXT,
       ${TUserAssignmentEntity.keraniKirimEmployeeCode} TEXT,
       ${TUserAssignmentEntity.keraniKirimEmployeeName} TEXT,
       ${TUserAssignmentEntity.keraniPanenEmployeeCode} TEXT,
       ${TUserAssignmentEntity.keraniPanenEmployeeName} TEXT,
       ${TUserAssignmentEntity.mandorEmployeeCode} TEXT,
       ${TUserAssignmentEntity.mandorEmployeeName} TEXT,
       ${TUserAssignmentEntity.employeeCode} TEXT,
       ${TUserAssignmentEntity.employeeName} TEXT,
       ${TUserAssignmentEntity.startValidity} TEXT,
       ${TUserAssignmentEntity.endValidity} TEXT,
       ${TUserAssignmentEntity.createdBy} TEXT,
       ${TUserAssignmentEntity.createdDate} TEXT,
       ${TUserAssignmentEntity.createdTime} TEXT,
       ${TUserAssignmentEntity.updatedBy} TEXT,
       ${TUserAssignmentEntity.updatedDate} TEXT,
       ${TUserAssignmentEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertTUserAssignment(List<TUserAssignmentSchema> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    for (int i = 0; i < object.length; i++) {
      int saved =
          await db.insert(tUserAssignmentSchemaTable, object[i].toJson());
      count = count + saved;
    }
    return count;
  }

  Future<List<TUserAssignmentSchema>> selectEmployeeTUserAssignment(
      MConfigSchema mConfigSchema) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.rawQuery(
        "SELECT * FROM $tUserAssignmentSchemaTable WHERE ${TUserAssignmentEntity.keraniPanenEmployeeCode}=?",
        [mConfigSchema.employeeCode]);
    List<TUserAssignmentSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      TUserAssignmentSchema mEmployeeSchema =
          TUserAssignmentSchema.fromJson(mapList[i]);
      list.add(mEmployeeSchema);
    }
    return list;
  }

  Future<List<TUserAssignmentSchema>> selectEmployeeTUserAssignmentSupervisor(
      MConfigSchema mConfigSchema) async {
    Database db = await DatabaseHelper().database;
    var mapListAll =
        await db.rawQuery("SELECT * FROM $tUserAssignmentSchemaTable");
    print(mapListAll);
    var mapList = await db.rawQuery(
        "SELECT * FROM $tUserAssignmentSchemaTable WHERE ${TUserAssignmentEntity.keraniPanenEmployeeCode}=?",
        [mConfigSchema.employeeCode]);
    List<TUserAssignmentSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      TUserAssignmentSchema mEmployeeSchema =
          TUserAssignmentSchema.fromJson(mapList[i]);
      list.add(mEmployeeSchema);
    }
    return list;
  }

  void deleteEmployeeTUserAssignment() async {
    Database db = await DatabaseHelper().database;
    db.delete(tUserAssignmentSchemaTable);
  }
}

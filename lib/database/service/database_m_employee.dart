import 'package:epms/database/entity/m_employee_entity.dart';
import 'package:epms/database/entity/t_user_assignment_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseMEmployeeSchema {
  void createTableMEmployeeSchema(Database db) async {
    // await db.execute('''
    //   CREATE TABLE $mEmployeeSchemaTable(
    //    ${MEmployeeEntity.employeeId} INT NOT NULL,
    //    ${MEmployeeEntity.employeeEstateCode} TEXT NOT NULL,
    //    ${MEmployeeEntity.employeeCode} TEXT,
    //    ${MEmployeeEntity.employeeName} TEXT,
    //    ${MEmployeeEntity.employeeValidFrom} TEXT,
    //    ${MEmployeeEntity.employeeValidTo} TEXT,
    //    ${MEmployeeEntity.employeeSex} TEXT,
    //    ${MEmployeeEntity.employeeJobCode} TEXT,
    //    ${MEmployeeEntity.employeeDivisionCode} TEXT,
    //    ${MEmployeeEntity.createdBy} TEXT,
    //    ${MEmployeeEntity.createdDate} TEXT,
    //    ${MEmployeeEntity.createdTime} TEXT,
    //    ${MEmployeeEntity.updatedBy} TEXT,
    //    ${MEmployeeEntity.updatedDate} TEXT,
    //    ${MEmployeeEntity.updatedTime} TEXT)
    // ''');
    await db.execute('''
      CREATE TABLE $mEmployeeSchemaTable(
       ${MEmployeeEntity.employeeId} INT NOT NULL,
       ${MEmployeeEntity.employeeEstateCode} TEXT NOT NULL,
       ${MEmployeeEntity.employeeCode} TEXT,
       ${MEmployeeEntity.employeeName} TEXT,
       ${MEmployeeEntity.employeeJobCode} TEXT,
       ${MEmployeeEntity.employeeDivisionCode} TEXT)
    ''');
  }

  Future<int> insertMEmployeeSchema(List<MEmployeeSchema> object) async {
    Database db = await DatabaseHelper().database;
    // int count = 0;
    // List<MEmployeeSchema> listEmployee = await selectMEmployeeSchema();
    // for (int i = 0; i < object.length; i++) {
    //   if(!(listEmployee.contains(object[i]))) {
    //     int saved = await db.insert(mEmployeeSchemaTable, object[i].toJson());
    //     count = count + saved;
    //   }
    // }
    // return count;
    Batch batch = db.batch();
    object.forEach((val) {
      MEmployeeSchema mEmployeeSchema =  val;
      batch.insert(mEmployeeSchemaTable, mEmployeeSchema.toJson());
    });
    List<Object?> i = await batch.commit();
    return i.length;
  }

  Future<List<MEmployeeSchema>> selectMEmployeeSchema() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mEmployeeSchemaTable,
        orderBy: MEmployeeEntity.employeeName);
    List<MEmployeeSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MEmployeeSchema mEmployeeSchema = MEmployeeSchema.fromJson(mapList[i]);
      list.add(mEmployeeSchema);
    }
    return list;
  }

  Future<List<MEmployeeSchema>> selectEmployeeTUserAssignmentJOIN(
      MConfigSchema mConfigSchema) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.rawQuery(
        "SELECT $mEmployeeSchemaTable.* FROM $tUserAssignmentSchemaTable INNER JOIN $mEmployeeSchemaTable ON $tUserAssignmentSchemaTable.${TUserAssignmentEntity.employeeCode}=$mEmployeeSchemaTable.${MEmployeeEntity.employeeCode}  WHERE ${TUserAssignmentEntity.keraniPanenEmployeeCode}=? OR ${TUserAssignmentEntity.keraniKirimEmployeeCode}=? ORDER BY ${MEmployeeEntity.employeeName}",
        [mConfigSchema.employeeCode, mConfigSchema.employeeCode]);
    // var mapList = await db.query(tUserAssignmentSchemaTable);
    List<MEmployeeSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MEmployeeSchema mEmployeeSchema =
      MEmployeeSchema.fromJson(mapList[i]);
      list.add(mEmployeeSchema);
    }
    return list;
  }

  Future<List<MEmployeeSchema>> selectMEmployeeSchemaDriver() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.rawQuery("SELECT * FROM $mEmployeeSchemaTable WHERE ${MEmployeeEntity.employeeJobCode} LIKE '%SOPIR%' OR ${MEmployeeEntity.employeeJobCode} LIKE '%SUPIR%' ORDER BY ${MEmployeeEntity.employeeName}");
    List<MEmployeeSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MEmployeeSchema mEmployeeSchema = MEmployeeSchema.fromJson(mapList[i]);
      list.add(mEmployeeSchema);
    }
    return list;
  }

  Future<List<MEmployeeSchema>> selectMEmployeeSchemaByCode(
      String employeeCode) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mEmployeeSchemaTable,
        where: "${MEmployeeEntity.employeeCode} = ?",
        whereArgs: [employeeCode],
        orderBy: MEmployeeEntity.employeeName);
    List<MEmployeeSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MEmployeeSchema mEmployeeSchema = MEmployeeSchema.fromJson(mapList[i]);
      list.add(mEmployeeSchema);
    }
    return list;
  }

  void deleteMEmployeeSchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(mEmployeeSchemaTable);
  }
}

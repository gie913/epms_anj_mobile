import 'package:epms/database/entity/t_attendance_entity.dart';
import 'package:epms/model/t_attendance_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';
import '../helper/database_table.dart';

class DatabaseAttendance {
  void createTableAttendance(Database db) async {
    await db.execute('''
      CREATE TABLE $tAttendanceSchemaTable(
       ${TAttendanceEntity.attendanceMandorEmployeeCode} TEXT NOT NULL,
       ${TAttendanceEntity.attendanceMandorEmployeeName} TEXT NOT NULL,
       ${TAttendanceEntity.attendanceEmployeeCode} TEXT,
       ${TAttendanceEntity.attendanceEmployeeName} TEXT,
       ${TAttendanceEntity.attendanceKeraniEmployeeCode} TEXT,
       ${TAttendanceEntity.attendanceKeraniEmployeeName} TEXT,
       ${TAttendanceEntity.attendanceId} INT NOT NULL,
       ${TAttendanceEntity.attendanceDate} TEXT,
       ${TAttendanceEntity.attendanceCode} TEXT,
       ${TAttendanceEntity.createdBy} TEXT,
       ${TAttendanceEntity.createdDate} TEXT,
       ${TAttendanceEntity.createdTime} TEXT,
       ${TAttendanceEntity.updatedBy} TEXT,
       ${TAttendanceEntity.updatedDate} TEXT,
       ${TAttendanceEntity.updatedTime} TEXT,
       ${TAttendanceEntity.attendanceDesc} TEXT)
    ''');
  }

  Future<int> insertAttendance(List<TAttendanceSchema> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    List<TAttendanceSchema> listTAttendance = await selectEmployeeAttendance();
    for (int i = 0; i < object.length; i++) {
      if (!(listTAttendance.contains(object[i]))) {
        int saved = await db.insert(tAttendanceSchemaTable, object[i].toJson());
        count = count + saved;
      }
    }
    return count;
  }

  Future<int> updateDatabaseAttendance(
      TAttendanceSchema tAttendanceSchema) async {
    Database db = await DatabaseHelper().database;
    int count = await db.update(
        tAttendanceSchemaTable, tAttendanceSchema.toJson(),
        where: '${TAttendanceEntity.attendanceEmployeeCode} = ?',
        whereArgs: [tAttendanceSchema.attendanceEmployeeCode]);
    return count;
  }

  Future<List<TAttendanceSchema>> selectEmployeeAttendance() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tAttendanceSchemaTable);
    List<TAttendanceSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      TAttendanceSchema mEmployeeSchema =
          TAttendanceSchema.fromJson(mapList[i]);
      list.add(mEmployeeSchema);
    }
    return list;
  }

  void deleteEmployeeAttendance() async {
    Database db = await DatabaseHelper().database;
    db.delete(tAttendanceSchemaTable);
  }
}

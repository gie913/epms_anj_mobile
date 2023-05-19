
import 'package:epms/database/entity/m_attendance_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/m_attendance_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseMAttendance {

  void createTableMAttendance(Database db) async {
    await db.execute('''
      CREATE TABLE $mAttendanceSchemaTable(
       ${MAttendanceEntity.attendanceId} INT NOT NULL,
       ${MAttendanceEntity.attendanceCode} TEXT,
       ${MAttendanceEntity.attendanceDesc} TEXT,
       ${MAttendanceEntity.createdBy} TEXT,
       ${MAttendanceEntity.createdDate} TEXT,
       ${MAttendanceEntity.createdTime} TEXT,
       ${MAttendanceEntity.updatedBy} TEXT,
       ${MAttendanceEntity.updatedDate} TEXT,
       ${MAttendanceEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertAttendance(List<MAttendanceSchema> object) async {
    Database db = await DatabaseHelper().database;
    // int count = 0;
    // List<MAttendanceSchema> listAttendance = await selectEmployeeAttendance();
    // for (int i = 0; i < object.length; i++) {
    //     if(!(listAttendance.contains(object[i]))) {
    //       int saved = await db.insert(mAttendanceSchemaTable, object[i].toJson());
    //       count = count + saved;
    //     }
    // }
    Batch batch = db.batch();
    object.forEach((val) {
      MAttendanceSchema mAttendanceSchema =  val;
      batch.insert(mAttendanceSchemaTable, mAttendanceSchema.toJson());
    });
    List<Object?> i = await batch.commit();
    return i.length;
  }

  Future<List<MAttendanceSchema>> selectEmployeeAttendance() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mAttendanceSchemaTable);
    List<MAttendanceSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MAttendanceSchema mEmployeeSchema =
          MAttendanceSchema.fromJson(mapList[i]);
      list.add(mEmployeeSchema);
    }
    return list;
  }

  void deleteEmployeeAttendance() async {
    Database db = await DatabaseHelper().database;
    db.delete(mAttendanceSchemaTable);
  }
}

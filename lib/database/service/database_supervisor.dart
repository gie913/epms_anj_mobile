import 'package:epms/database/entity/t_supervisor_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/supervisor.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseSupervisor {
  void createTableSupervisor(Database db) async {
    await db.execute('''
      CREATE TABLE $tSupervisorTable(
       ${TSupervisorEntity.employeeCode} TEXT,
       ${TSupervisorEntity.mandorName} TEXT,
       ${TSupervisorEntity.mandorCode} TEXT,
       ${TSupervisorEntity.mandor1Name} TEXT,
       ${TSupervisorEntity.mandor1Code} TEXT,
       ${TSupervisorEntity.keraniPanenCode} TEXT,
       ${TSupervisorEntity.keraniPanenName} TEXT,
       ${TSupervisorEntity.keraniKirimName} TEXT,
       ${TSupervisorEntity.keraniKirimCode} TEXT)
    ''');
  }

  Future<int> insertSupervisor(Supervisor object) async {
    Database db = await DatabaseHelper().database;
    int count = await db.insert(tSupervisorTable, object.toJson());
    return count;
  }

  Future<int> updateSupervisor(Supervisor object) async {
    Database db = await DatabaseHelper().database;
    int count = await db.update(tSupervisorTable, object.toJson());
    return count;
  }

  Future<Supervisor?> selectSupervisor() async {
    Supervisor? supervisor;
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tSupervisorTable);
    if (mapList.isNotEmpty) {
      supervisor = Supervisor.fromJson(mapList.last);
    }
    return supervisor;
  }

  Future<Supervisor?> selectSupervisorByEmployeeID(String employeeID) async {
    Supervisor? supervisor;
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tSupervisorTable,
        where: "${TSupervisorEntity.employeeCode} = ?",
        whereArgs: [employeeID]);
    if (mapList.isNotEmpty) {
      supervisor = Supervisor.fromJson(mapList[0]);
    }
    return supervisor;
  }

  void deleteSupervisor() async {
    Database db = await DatabaseHelper().database;
    db.delete(tSupervisorTable);
  }
}

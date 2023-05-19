import 'package:epms/database/entity/m_ancak_employee_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/m_ancak_employee.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseMAncakEmployee {
  void createTableMAncakEmployeeSchema(Database db) async {
    await db.execute('''
      CREATE TABLE $mAncakEmployeeTable(
       ${MAncakEmployeeEntity.userId} INT NOT NULL,
       ${MAncakEmployeeEntity.userName} TEXT)
    ''');
  }

  Future<int> insertMAncakEmployeeSchema(List<MAncakEmployee> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    List<MAncakEmployee> listAncak = await selectMAncakEmployeeSchema();
    for (int i = 0; i < object.length; i++) {
      if(!(listAncak.contains(object[i]))) {
        int saved = await db.insert(mAncakEmployeeTable, object[i].toJson());
        count = count + saved;
      }
    }
    return count;
  }

  Future<List<MAncakEmployee>> selectMAncakEmployeeSchema() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mAncakEmployeeTable,
        orderBy: MAncakEmployeeEntity.userName);
    List<MAncakEmployee> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MAncakEmployee mEmployeeSchema = MAncakEmployee.fromJson(mapList[i]);
      list.add(mEmployeeSchema);
    }
    return list;
  }

  void deleteMAncakEmployeeSchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(mAncakEmployeeTable);
  }
}

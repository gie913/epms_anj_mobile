
import 'package:epms/model/m_activity_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/m_activity_entity.dart';
import '../helper/database_table.dart';
import '../helper/database_helper.dart';

class DatabaseMActivitySchema {
  void createTableMActivity(Database db) async {
    await db.execute('''
      CREATE TABLE $mActivitySchemaTable(
       ${ActivityEntity.activityId} INT NOT NULL,
       ${ActivityEntity.activityCode} TEXT,
       ${ActivityEntity.activityName} TEXT,
       ${ActivityEntity.activityUom} TEXT,
       ${ActivityEntity.createdBy} TEXT,
       ${ActivityEntity.createdDate} TEXT,
       ${ActivityEntity.createdTime} TEXT,
       ${ActivityEntity.updatedBy} TEXT,
       ${ActivityEntity.updatedDate} TEXT,
       ${ActivityEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertMActivitySchema(List<MActivitySchema> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    for (int i = 0; i < object.length; i++) {
        int saved = await db.insert(mActivitySchemaTable, object[i].toJson());
        count = count + saved;
    }
    return count;
  }

  Future<List<MActivitySchema>> selectMActivitySchema() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mActivitySchemaTable);
    List<MActivitySchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MActivitySchema mActivitySchema = MActivitySchema.fromJson(mapList[i]);
      list.add(mActivitySchema);
    }
    return list;
  }

  void deleteMActivitySchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(mActivitySchemaTable);
  }
}

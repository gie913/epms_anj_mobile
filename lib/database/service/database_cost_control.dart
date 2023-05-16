import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/m_cost_control_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/m_cost_control_entity.dart';
import '../helper/database_helper.dart';

class DatabaseMCostControlSchema {
  void createMCostControlSchema(Database db) async {
    await db.execute('''
      CREATE TABLE $mCostControlSchemaTable(
       ${CostControlEntity.costControlId} INT NOT NULL,
       ${CostControlEntity.activityCodeStart} INT,
       ${CostControlEntity.activityCodeEnd} INT,
       ${CostControlEntity.costByBlock} INT,
       ${CostControlEntity.costByAuc} INT,
       ${CostControlEntity.costByOrderNumber} INT,
       ${CostControlEntity.costByCostCenter} INT,
       ${CostControlEntity.createdBy} TEXT,
       ${CostControlEntity.createdDate} TEXT,
       ${CostControlEntity.createdTime} TEXT,
       ${CostControlEntity.updatedBy} TEXT,
       ${CostControlEntity.updatedDate} TEXT,
       ${CostControlEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertMCostControlSchema(List<MCostControlSchema> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    for (int i = 0; i < object.length; i++) {
      int saved =
      await db.insert(mCostControlSchemaTable, object[i].toJson());
      count = count + saved;
    }
    return count;
  }

  Future<List<MCostControlSchema>> selectMCostControlSchema() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mCostControlSchemaTable);
    List<MCostControlSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MCostControlSchema mCostControlSchema =
      MCostControlSchema.fromJson(mapList[i]);
      list.add(mCostControlSchema);
    }
    return list;
  }

  void deleteMCostControlSchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(mCostControlSchemaTable);
  }
}

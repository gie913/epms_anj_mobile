import 'package:epms/database/entity/t_harvesting_plan_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/t_harvesting_plan_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseTHarvestingPlan {
  void createTHarvestingPlan(Database db) async {
    await db.execute('''
      CREATE TABLE $tHarvestingPlanSchemaTable(
       ${THarvestingPlanEntity.harvestingPlanId} INT NOT NULL,
       ${THarvestingPlanEntity.harvestingPlanDate} TEXT,
       ${THarvestingPlanEntity.harvestingPlanEstateCode} TEXT,
       ${THarvestingPlanEntity.harvestingPlanDivisionCode} TEXT,
       ${THarvestingPlanEntity.harvestingPlanBlockCode} TEXT,
       ${THarvestingPlanEntity.harvestingPlanTotalHk} INT,
       ${THarvestingPlanEntity.harvestingPlanHectarage} TEXT,
       ${THarvestingPlanEntity.harvestingPlanAssistantEmployeeCode} TEXT,
       ${THarvestingPlanEntity.harvestingPlanAssistantEmployeeName} TEXT,
       ${THarvestingPlanEntity.isApproved} INT,
       ${THarvestingPlanEntity.harvestingPlanApprovedBy} TEXT,
       ${THarvestingPlanEntity.harvestingPlanApprovedByName} TEXT,
       ${THarvestingPlanEntity.harvestingPlanApprovedDate} TEXT,
       ${THarvestingPlanEntity.harvestingPlanApprovedTime} TEXT,
       ${THarvestingPlanEntity.createdBy} TEXT,
       ${THarvestingPlanEntity.createdDate} TEXT,
       ${THarvestingPlanEntity.createdTime} TEXT,
       ${THarvestingPlanEntity.updatedBy} TEXT,
       ${THarvestingPlanEntity.updatedDate} text,
       ${THarvestingPlanEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertTHarvestingPlan(List<THarvestingPlanSchema> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    for (int i = 0; i < object.length; i++) {
      int saved =
          await db.insert(tHarvestingPlanSchemaTable, object[i].toJson());
      count = count + saved;
    }
    return count;
  }

  Future<List<THarvestingPlanSchema>> selectTHarvestingPlan() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tHarvestingPlanSchemaTable);
    List<THarvestingPlanSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      THarvestingPlanSchema tHarvestingPlanSchema =
          THarvestingPlanSchema.fromJson(mapList[i]);
      list.add(tHarvestingPlanSchema);
    }
    return list;
  }

  void deleteTHarvestingPlan() async {
    Database db = await DatabaseHelper().database;
    db.delete(tHarvestingPlanSchemaTable);
  }
}

import 'package:epms/database/entity/t_workplan_schema_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/database/service/database_material.dart';
import 'package:epms/model/materials.dart';
import 'package:epms/model/t_work_plan_schema.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseTWorkplanSchema {
  void createTWorkPlan(Database db) async {
    await db.execute('''
      CREATE TABLE $tWorkPlanSchemaTable(
           ${TWorkPlanSchemaEntity.workplanId} TEXT NOT NULL,
    ${TWorkPlanSchemaEntity.workplanDate} TEXT,
    ${TWorkPlanSchemaEntity.workplanEstateCode} TEXT,
    ${TWorkPlanSchemaEntity.workplanDivisionCode} TEXT,
    ${TWorkPlanSchemaEntity.workplanActivityCode} TEXT,
    ${TWorkPlanSchemaEntity.workplanActivityName} TEXT,
    ${TWorkPlanSchemaEntity.workplanActivityUom} TEXT,
    ${TWorkPlanSchemaEntity.workplanTarget} DOUBLE,
    ${TWorkPlanSchemaEntity.workplanTotalHk} INT,
    ${TWorkPlanSchemaEntity.workplanRemark} TEXT,
    ${TWorkPlanSchemaEntity.workplanAssistantEmployeeCode} TEXT,
    ${TWorkPlanSchemaEntity.workplanAssistantEmployeeName} TEXT,
    ${TWorkPlanSchemaEntity.workplanBlockCode} TEXT,
    ${TWorkPlanSchemaEntity.workplanOrderNumber} TEXT,
    ${TWorkPlanSchemaEntity.workplanAucNumber} TEXT,
    ${TWorkPlanSchemaEntity.workplanCostCenter} TEXT,
    ${TWorkPlanSchemaEntity.isApproved} TEXT,
    ${TWorkPlanSchemaEntity.workplanApprovedBy} TEXT,
    ${TWorkPlanSchemaEntity.workplanApprovedByName} TEXT,
    ${TWorkPlanSchemaEntity.workplanApprovedDate} TEXT,
    ${TWorkPlanSchemaEntity.workplanApprovedTime} TEXT,
    ${TWorkPlanSchemaEntity.createdBy} TEXT,
    ${TWorkPlanSchemaEntity.createdDate} TEXT,
    ${TWorkPlanSchemaEntity.createdTime} TEXT,
    ${TWorkPlanSchemaEntity.updatedBy} TEXT,
    ${TWorkPlanSchemaEntity.updatedDate} TEXT,
    ${TWorkPlanSchemaEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertTWorkPlan(List<TWorkplanSchema> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    int countMaterial = 0;
    for (int i = 0; i < object.length; i++) {
      TWorkplanSchema tWorkPlanSchema =  TWorkplanSchema();
      List<Materials> listMaterial = object[i].materials ?? [];
      tWorkPlanSchema = object[i];
      tWorkPlanSchema.materials = null;
      int saved = await db.insert(tWorkPlanSchemaTable, tWorkPlanSchema.toJson());
      int savedMaterial = await DatabaseMaterial().insertMaterial(listMaterial);
      count = count + saved;
      countMaterial = countMaterial + savedMaterial;
    }
    return count;
  }

  Future<List<TWorkplanSchema>> selectTWorkPlan() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tWorkPlanSchemaTable);
    List<TWorkplanSchema> list = [];
    for (int i = 0; i < mapList.length-1; i++) {
      TWorkplanSchema tWorkplanSchema = TWorkplanSchema.fromJson(mapList[i]);
      List<Materials> listMaterial = await DatabaseMaterial().selectMaterialByWorkPlan(tWorkplanSchema);
      tWorkplanSchema.materials = listMaterial;
      list.add(tWorkplanSchema);
    }
    return list;
  }

  void deleteTWorkPlan() async {
    Database db = await DatabaseHelper().database;
    db.delete(tWorkPlanSchemaTable);
  }
}

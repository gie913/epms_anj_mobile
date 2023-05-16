import 'package:epms/database/entity/t_material_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/materials.dart';
import 'package:epms/model/t_work_plan_schema.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseMaterial {
  void createMaterial(Database db) async {
    await db.execute('''
      CREATE TABLE $tMaterial(
           ${TMaterialEntity.workplanMaterialId} TEXT NOT NULL,
      ${TMaterialEntity.workplanId} TEXT,
      ${TMaterialEntity.workplanMaterialCode} TEXT,
      ${TMaterialEntity.workplanMaterialName} TEXT,
      ${TMaterialEntity.workplanMaterialUom} TEXT,
      ${TMaterialEntity.workplanMaterialQty} TEXT)
    ''');
  }

  Future<int> insertMaterial(List<Materials> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    for (int i = 0; i < object.length; i++) {
      int saved = await db.insert(tMaterial, object[i].toJson());
      count = count + saved;
    }
    return count;
  }

  Future<List<Materials>> selectMaterialByWorkPlan(TWorkplanSchema tWorkplanSchema) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tMaterial, where: '${TMaterialEntity.workplanId} = ?', whereArgs: [tWorkplanSchema.workplanId]);
    List<Materials> list = [];
    for (int i = 0; i < mapList.length; i++) {
      Materials materials = Materials.fromJson(mapList[i]);
      list.add(materials);
    }
    return list;
  }

  void deleteMaterial() async {
    Database db = await DatabaseHelper().database;
    db.delete(tMaterial);
  }
}

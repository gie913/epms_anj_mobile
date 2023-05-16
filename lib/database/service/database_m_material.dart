import 'package:epms/database/entity/m_material_entity.dart';
import 'package:epms/model/m_material_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_table.dart';
import '../helper/database_helper.dart';

class DatabaseMMaterialSchema {

  void createTableMMaterialSchema(Database db) async {
    await db.execute('''
      CREATE TABLE $mMaterialSchemaTable(
       ${MMaterialEntity.materialId} INT NOT NULL,
       ${MMaterialEntity.materialCode} TEXT,
       ${MMaterialEntity.materialName} TEXT,
       ${MMaterialEntity.materialUom} TEXT,
       ${MMaterialEntity.createdBy} TEXT,
       ${MMaterialEntity.createdDate} TEXT,
       ${MMaterialEntity.createdTime} TEXT,
       ${MMaterialEntity.updatedBy} TEXT,
       ${MMaterialEntity.updatedDate} TEXT,
       ${MMaterialEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertMMaterialSchema(List<MMaterialSchema> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    for (int i = 0; i < object.length; i++) {
        int saved = await db.insert(mMaterialSchemaTable, object[i].toJson());
        count = count + saved;
    }
    return count;
  }

  Future<List<MMaterialSchema>> selectMMaterialSchema() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mMaterialSchemaTable);
    List<MMaterialSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MMaterialSchema mMaterialSchema = MMaterialSchema.fromJson(mapList[i]);
      list.add(mMaterialSchema);
    }
    return list;
  }

  void deleteMMaterialSchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(mMaterialSchemaTable);
  }
}

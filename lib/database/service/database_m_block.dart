import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/m_block_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/block_entity.dart';

class DatabaseMBlockSchema {
  void createTableMBlockSchema(Database db) async {
    await db.execute('''
      CREATE TABLE $mBlockSchemaTable(
       ${BlockEntity.blockId} INT NOT NULL,
       ${BlockEntity.blockCompanyCode} TEXT,
       ${BlockEntity.blockEstateCode} TEXT,
       ${BlockEntity.blockDivisionCode} TEXT,
       ${BlockEntity.blockCode} TEXT,
       ${BlockEntity.blockName} TEXT,
       ${BlockEntity.blockPlantedDate} TEXT,
       ${BlockEntity.blockValidFrom} TEXT,
       ${BlockEntity.blockValidTo} TEXT,
       ${BlockEntity.blockHectarage} TEXT,
       ${BlockEntity.blockKerapatanPokok} TEXT,
       ${BlockEntity.createdBy} TEXT,
       ${BlockEntity.createdDate} TEXT,
       ${BlockEntity.createdTime} TEXT,
       ${BlockEntity.updatedBy} TEXT,
       ${BlockEntity.updatedDate} TEXT,
       ${BlockEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertMBlockSchema(List<MBlockSchema> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    for (int i = 0; i < object.length; i++) {
      int saved = await db.insert(mBlockSchemaTable, object[i].toJson());
      count = count + saved;
    }
    return count;
  }

  Future<List<MBlockSchema>> selectMBlockSchema() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mBlockSchemaTable);
    List<MBlockSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MBlockSchema mBlockSchema = MBlockSchema.fromJson(mapList[i]);
      list.add(mBlockSchema);
    }
    return list;
  }

  Future<MBlockSchema?> selectMBlockSchemaByID(String blockCode, String estateCode) async {
    MBlockSchema? mBlockSchema;
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mBlockSchemaTable,
        where: "${BlockEntity.blockCode} = ? AND ${BlockEntity.blockEstateCode} = ?", whereArgs: [blockCode, estateCode]);
    if(mapList.isNotEmpty) {
      mBlockSchema = MBlockSchema.fromJson(mapList[0]);
    }
    return mBlockSchema;
  }

  void deleteMBlockSchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(mBlockSchemaTable);
  }
}

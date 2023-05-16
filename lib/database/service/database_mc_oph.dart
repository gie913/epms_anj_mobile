import 'package:epms/database/entity/mc_oph_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/m_c_oph_card_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseMCOPHSchema {
  void createTableMCOPHSchema(Database db) async {
    await db.execute('''
      CREATE TABLE $mCOPHCardSchemaTable(
       ${MCOPHEntity.ophCardId} TEXT NOT NULL,
       ${MCOPHEntity.ophCardDivision} TEXT,
       ${MCOPHEntity.ophCardStatus} TEXT,
       ${MCOPHEntity.createdBy} TEXT,
       ${MCOPHEntity.createdDate} TEXT,
       ${MCOPHEntity.createdTime} TEXT,
       ${MCOPHEntity.updatedBy} TEXT,
       ${MCOPHEntity.updatedDate} TEXT,
       ${MCOPHEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertMCOPHSchema(List<MCOPHCardSchema> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    for (int i = 0; i < object.length; i++) {
      int saved = await db.insert(mCOPHCardSchemaTable, object[i].toJson());
      count = count + saved;
    }
    return count;
  }

  Future<List<MCOPHCardSchema>> selectMCOPHSchema() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mCOPHCardSchemaTable);
    List<MCOPHCardSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MCOPHCardSchema mCOPHSchema = MCOPHCardSchema.fromJson(mapList[i]);
      list.add(mCOPHSchema);
    }
    return list;
  }

  Future<MCOPHCardSchema?> selectMCOPHSchemaByID(String ophCardID) async {
    MCOPHCardSchema? mCOPHSchema;
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mCOPHCardSchemaTable,
        where: "${MCOPHEntity.ophCardId} = ?", whereArgs: [ophCardID]);
    if(mapList.isNotEmpty) {
      mCOPHSchema = MCOPHCardSchema.fromJson(mapList[0]);
    }
    return mCOPHSchema;
  }

  void deleteMCOPHSchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(mCOPHCardSchemaTable);
  }
}

import 'package:epms/database/entity/m_division_entity.dart';
import 'package:epms/model/m_division_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_table.dart';
import '../helper/database_helper.dart';

class DatabaseMDivisionSchema {
  void createTableMDivisionSchema(Database db) async {
    await db.execute('''
      CREATE TABLE $mDivisionSchemaTable(
       ${MDivisionEntity.divisionId} INT NOT NULL,
       ${MDivisionEntity.divisionCompanyCode} TEXT,
       ${MDivisionEntity.divisionEstateCode} TEXT,
       ${MDivisionEntity.divisionCode} TEXT,
       ${MDivisionEntity.divisionName} TEXT,
       ${MDivisionEntity.divisionValidFrom} TEXT,
       ${MDivisionEntity.divisionValidTo} TEXT,
       ${MDivisionEntity.createdBy} TEXT,
       ${MDivisionEntity.createdDate} TEXT,
       ${MDivisionEntity.createdTime} TEXT,
       ${MDivisionEntity.updatedBy} TEXT,
       ${MDivisionEntity.updatedDate} TEXT,
       ${MDivisionEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertMDivisionSchema(List<MDivisionSchema> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    for (int i = 0; i < object.length; i++) {
        int saved = await db.insert(mDivisionSchemaTable, object[i].toJson());
        count = count + saved;
    }
    return count;
  }

  Future<List<MDivisionSchema>> selectMDivisionSchema() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mDivisionSchemaTable);
    List<MDivisionSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MDivisionSchema mDivisionSchema = MDivisionSchema.fromJson(mapList[i]);
      list.add(mDivisionSchema);
    }
    return list;
  }

  Future<List<MDivisionSchema>> selectMDivisionSchemaByEstate(String estateCode) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mDivisionSchemaTable,
        where: "${MDivisionEntity.divisionEstateCode}=?",
        whereArgs: [estateCode]);
    List<MDivisionSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MDivisionSchema mDivisionSchema = MDivisionSchema.fromJson(mapList[i]);
      list.add(mDivisionSchema);
    }
    return list;
  }

  void deleteMDivisionSchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(mDivisionSchemaTable);
  }
}

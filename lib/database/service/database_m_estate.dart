import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/m_estate_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/m_estate_entity.dart';

class DatabaseMEstateSchema {
  void createTableMEstateSchema(Database db) async {
    await db.execute('''
      CREATE TABLE $mEstateSchemaTable(
       ${MEstateEntity.estateId} INT NOT NULL,
       ${MEstateEntity.estateCompanyCode} TEXT,
       ${MEstateEntity.estateCode} TEXT,
       ${MEstateEntity.estateName} TEXT,
       ${MEstateEntity.estatePlantCode} TEXT,
       ${MEstateEntity.estateVendorCode} TEXT,
       ${MEstateEntity.createdBy} TEXT,
       ${MEstateEntity.createdDate} TEXT,
       ${MEstateEntity.createdTime} TEXT,
       ${MEstateEntity.updatedBy} TEXT,
       ${MEstateEntity.updatedDate} TEXT,
       ${MEstateEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertMEstateSchema(List<MEstateSchema> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    for (int i = 0; i < object.length; i++) {
      int saved = await db.insert(mEstateSchemaTable, object[i].toJson());
      count = count + saved;
    }
    return count;
  }

  Future<List<MEstateSchema>> selectMEstateSchema() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mEstateSchemaTable);
    List<MEstateSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MEstateSchema mEstateSchema = MEstateSchema.fromJson(mapList[i]);
      list.add(mEstateSchema);
    }
    return list;
  }

  Future<MEstateSchema> selectMEstateSchemaByEstateCode(
      String estateCode) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mEstateSchemaTable,
        where: "${MEstateEntity.estateCode}=?", whereArgs: [estateCode]);
      MEstateSchema mEstateSchema = MEstateSchema.fromJson(mapList[0]);
    return mEstateSchema;
  }

  void deleteMEstateSchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(mEstateSchemaTable);
  }
}

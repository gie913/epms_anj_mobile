import 'package:epms/database/entity/t_abw_schema_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/t_abw_schema.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseTABWSchema {
  void createTableTABWSchema(Database db) async {
    // await db.execute('''
    //   CREATE TABLE $tABWSchemaTable(
    //    ${TABWSchemaEntity.abwId} INT,
    //    ${TABWSchemaEntity.abwCompanyCode} TEXT,
    //    ${TABWSchemaEntity.abwEstateCode} TEXT,
    //    ${TABWSchemaEntity.abwBlockCode} TEXT,
    //    ${TABWSchemaEntity.abwYear} TEXT,
    //    ${TABWSchemaEntity.abwMonth} TEXT,
    //    ${TABWSchemaEntity.bunchWeight} REAL)
    // ''');
    await db.execute('''
      CREATE TABLE $tABWSchemaTable(
       ${TABWSchemaEntity.abwId} INT,
       ${TABWSchemaEntity.abwCompanyCode} TEXT,
       ${TABWSchemaEntity.abwEstateCode} TEXT,
       ${TABWSchemaEntity.abwBlockCode} TEXT,
       ${TABWSchemaEntity.bunchWeight} REAL)
    ''');
  }

  Future<int> insertTABWSchema(List<TABWSchema> object) async {
    Database db = await DatabaseHelper().database;
    // int count = 0;
    // List<TABWSchema> listTABW = await selectTABWAll();
    // for (int i = 0; i < object.length; i++) {
    //   if(!(listTABW.contains(object[i]))) {
    //     int saved = await db.insert(tABWSchemaTable, object[i].toJson());
    //     count = count + saved;
    //   }
    // }
    // return count;
    Batch batch = db.batch();
    object.forEach((val) {
      TABWSchema tabwSchema =  val;
      batch.insert(tABWSchemaTable, tabwSchema.toJson());
    });
    List<Object?> i = await batch.commit();
    return i.length;
  }

  Future<List<TABWSchema>> selectTABWAll() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tABWSchemaTable);
    List<TABWSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      TABWSchema tabwSchema =
      TABWSchema.fromJson(mapList[i]);
      list.add(tabwSchema);
    }
    return list;
  }

  Future<TABWSchema?> selectTABWSchema() async {
    TABWSchema? tABWSchema;
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tABWSchemaTable);
    if (mapList.isNotEmpty) {
      tABWSchema = TABWSchema.fromJson(mapList.last);
    }
    return tABWSchema;
  }

  Future<TABWSchema?> selectTABWSchemaByBlock(
      String blockCode, String estateCode) async {
    TABWSchema? tABWSchema;
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tABWSchemaTable,
        where: "${TABWSchemaEntity.abwBlockCode}=? AND ${TABWSchemaEntity.abwEstateCode}=?",
        whereArgs: [blockCode, estateCode]);
    if (mapList.isNotEmpty) {
      tABWSchema = TABWSchema.fromJson(mapList.last);
    }
    return tABWSchema;
  }

  void deleteTABWSchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(tABWSchemaTable);
  }
}

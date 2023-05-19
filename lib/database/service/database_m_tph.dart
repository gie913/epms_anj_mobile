import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/m_tph_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/m_tph_entity.dart';

class DatabaseMTPHSchema {
  void createTableMTPHSchema(Database db) async {
    // await db.execute('''
    //   CREATE TABLE $mTPHSchemaTable(
    //    ${MTPHEntity.tphId} INT NOT NULL,
    //    ${MTPHEntity.tphCompanyCode} TEXT,
    //    ${MTPHEntity.tphEstateCode} TEXT,
    //    ${MTPHEntity.tphDivisionCode} TEXT,
    //    ${MTPHEntity.tphBlockCode} TEXT,
    //    ${MTPHEntity.tphCode} TEXT,
    //    ${MTPHEntity.tphValidFrom} TEXT,
    //    ${MTPHEntity.tphValidTo} TEXT,
    //    ${MTPHEntity.tphLatitude} TEXT,
    //    ${MTPHEntity.tphLongitude} TEXT,
    //    ${MTPHEntity.createdBy} TEXT,
    //    ${MTPHEntity.createdDate} TEXT,
    //    ${MTPHEntity.createdTime} TEXT,
    //    ${MTPHEntity.updatedBy} TEXT,
    //    ${MTPHEntity.updatedDate} TEXT,
    //    ${MTPHEntity.updatedTime} TEXT)
    // ''');
    await db.execute('''
      CREATE TABLE $mTPHSchemaTable(
       ${MTPHEntity.tphId} INT NOT NULL,
       ${MTPHEntity.tphEstateCode} TEXT,
       ${MTPHEntity.tphBlockCode} TEXT,
       ${MTPHEntity.tphCode} TEXT)
    ''');
  }

  Future<int> insertMTPHSchema(List<MTPHSchema> object) async {
    Database db = await DatabaseHelper().database;

    // int count = 0;
    // List<MTPHSchema> listMTPH = await selectMTPHSchema();
    // for (int i = 0; i < object.length; i++) {
    //   // if(!(listMTPH.contains(object[i]))) {
    //     int saved = await db.insert(mTPHSchemaTable, object[i].toJson());
    //     count = count + saved;
    //   // }
    // }
    Batch batch = db.batch();
    object.forEach((val) {
      MTPHSchema mtphSchema =  val;
      batch.insert(mTPHSchemaTable, mtphSchema.toJson());
    });
    List<Object?> i = await batch.commit();
    return i.length;
  }

  Future<List<MTPHSchema>> selectMTPHSchema() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mTPHSchemaTable);
    List<MTPHSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MTPHSchema mTPHSchema = MTPHSchema.fromJson(mapList[i]);
      list.add(mTPHSchema);
    }
    return list;
  }

  Future<MTPHSchema?> selectMTPHSchemaByID(
      String tphCode, String estateCode, String blocCode) async {
    MTPHSchema? mTPHSchema;
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mTPHSchemaTable,
        where: "${MTPHEntity.tphCode}=? AND ${MTPHEntity.tphEstateCode}=? AND ${MTPHEntity.tphBlockCode}=?",
        whereArgs: [tphCode, estateCode, blocCode]);
    if (mapList.isNotEmpty) {
      mTPHSchema = MTPHSchema.fromJson(mapList[0]);
    }
    return mTPHSchema;
  }

  void deleteMTPHSchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(mTPHSchemaTable);
  }
}

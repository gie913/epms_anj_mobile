import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/m_c_spb_card_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/mc_spb_entity.dart';

class DatabaseMCSPBCardSchema {
  void createTableMCSPBSchema(Database db) async {
    // await db.execute('''
    //   CREATE TABLE $mCSPBCardSchemaTable(
    //    ${MCSPBEntity.spbCardId} TEXT NOT NULL,
    //    ${MCSPBEntity.spbCardDivision} TEXT,
    //    ${MCSPBEntity.spbCardStatus} TEXT,
    //    ${MCSPBEntity.createdBy} TEXT,
    //    ${MCSPBEntity.createdDate} TEXT,
    //    ${MCSPBEntity.createdTime} TEXT,
    //    ${MCSPBEntity.updatedBy} TEXT,
    //    ${MCSPBEntity.updatedDate} TEXT,
    //    ${MCSPBEntity.updatedTime} TEXT)
    // ''');
    await db.execute('''
      CREATE TABLE $mCSPBCardSchemaTable(
       ${MCSPBEntity.spbCardId} TEXT NOT NULL,
       ${MCSPBEntity.spbCardDivision} TEXT)
    ''');
  }

  Future<int> insertMCSPBCardSchema(List<MCSPBCardSchema> object) async {
    Database db = await DatabaseHelper().database;
    // int count = 0;
    // List<MCSPBCardSchema> listMCSPB = await selectMCSPBCard();
    // for (int i = 0; i < object.length; i++) {
    //   if (!(listMCSPB.contains(object[i]))) {
    //     int saved = await db.insert(mCSPBCardSchemaTable, object[i].toJson());
    //     count = count + saved;
    //   }
    // }
    Batch batch = db.batch();
    object.forEach((val) {
      MCSPBCardSchema mcspbCardSchema =  val;
      batch.insert(mCSPBCardSchemaTable, mcspbCardSchema.toJson());
    });
    List<Object?> i = await batch.commit();
    return i.length;
  }

  Future<List<MCSPBCardSchema>> selectMCSPBCard() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mCSPBCardSchemaTable);
    List<MCSPBCardSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MCSPBCardSchema mcspbCardSchema = MCSPBCardSchema.fromJson(mapList[i]);
      list.add(mcspbCardSchema);
    }
    return list;
  }

  Future<MCSPBCardSchema?> selectMCSPBCardSchema(String spbCardID) async {
    MCSPBCardSchema? mcspbCardSchema;
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mCSPBCardSchemaTable,
        where: "${MCSPBEntity.spbCardId}=?", whereArgs: [spbCardID]);
    if (mapList.isNotEmpty) {
      mcspbCardSchema = MCSPBCardSchema.fromJson(mapList[0]);
    }
    return mcspbCardSchema;
  }

  void deleteMCSPBCardSchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(mCSPBCardSchemaTable);
  }
}

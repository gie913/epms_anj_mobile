import 'package:epms/database/entity/spb_detail_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_detail.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseSPBDetail {
  void createTableSPBDetail(Database db) async {
    await db.execute('''
      CREATE TABLE $tSPBDetailSchemaListTable(
       ${SPBDetailEntity.spbId} TEXT NOT NULL,
       ${SPBDetailEntity.ophId} TEXT,
       ${SPBDetailEntity.ophBunchesDelivered} INT,
       ${SPBDetailEntity.ophLooseFruitDelivered} INT,
       ${SPBDetailEntity.ophBlockCode} TEXT,
       ${SPBDetailEntity.ophTphCode} TEXT,
       ${SPBDetailEntity.ophCardId} TEXT)
    ''');
  }

  Future<int> insertSPBDetail(SPBDetail object) async {
    Database db = await DatabaseHelper().database;
    int saved = await db.insert(tSPBDetailSchemaListTable, object.toJson());
    return saved;
  }

  Future<int> updateSPBDetailByID(SPBDetail object) async {
    Database db = await DatabaseHelper().database;
    int count = await db.update(tSPBDetailSchemaListTable, object.toJson(),
        where: '${SPBDetailEntity.spbId}=? AND ${SPBDetailEntity.ophId}=?',
        whereArgs: [object.spbId, object.ophId]);
    return count;
  }

  Future<List<SPBDetail>> selectSPBDetail() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tSPBDetailSchemaListTable);
    List<SPBDetail> list = [];
    for (int i = 0; i < mapList.length; i++) {
      SPBDetail oph = SPBDetail.fromJson(mapList[i]);
      list.add(oph);
    }
    return list;
  }

  Future<List<SPBDetail>> selectSPBDetailBySPBID(SPB spb) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tSPBDetailSchemaListTable,
        where: "${SPBDetailEntity.spbId} = ?", whereArgs: [spb.spbId]);
    List<SPBDetail> list = [];
    for (int i = 0; i < mapList.length; i++) {
      SPBDetail oph = SPBDetail.fromJson(mapList[i]);
      list.add(oph);
    }
    return list;
  }

  Future<SPBDetail?> selectSPBDetailByOPHID(String ophID) async {
    SPBDetail? oph;
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tSPBDetailSchemaListTable,
        where: "${SPBDetailEntity.ophId} = ?", whereArgs: [ophID]);
    if (mapList.isNotEmpty) {
      oph = SPBDetail.fromJson(mapList[0]);
    }
    return oph;
  }

  void deleteSPBDetail() async {
    Database db = await DatabaseHelper().database;
    db.delete(tSPBDetailSchemaListTable);
  }
}

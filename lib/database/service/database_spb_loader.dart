import 'package:epms/database/entity/spb_loader_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_loader.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseSPBLoader {
  void createTableSPBLoader(Database db) async {
    await db.execute('''
      CREATE TABLE $tSPBLoaderSchemaListTable(
       ${SPBLoaderEntity.spbId} TEXT NOT NULL,
       ${SPBLoaderEntity.spbLoaderId} TEXT,
       ${SPBLoaderEntity.loaderType} INT,
       ${SPBLoaderEntity.loaderDestinationType} INT,
       ${SPBLoaderEntity.loaderEmployeeCode} TEXT,
       ${SPBLoaderEntity.loaderEmployeeName} TEXT,
       ${SPBLoaderEntity.loaderPercentage} INT)
    ''');
  }

  Future<int> insertSPBLoader(SPBLoader object) async {
    Database db = await DatabaseHelper().database;
    int saved = await db.insert(tSPBLoaderSchemaListTable, object.toJson());
    return saved;
  }

  Future<int> updateSPBLoaderByID(SPBLoader object) async {
    Database db = await DatabaseHelper().database;
    int count = await db.update(tSPBLoaderSchemaListTable, object.toJson(),
        where: '${SPBLoaderEntity.spbLoaderId}=?',
        whereArgs: [object.spbLoaderId]);
    return count;
  }

  Future<List<SPBLoader>> selectSPBLoader() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tSPBLoaderSchemaListTable);
    List<SPBLoader> list = [];
    for (int i = 0; i < mapList.length; i++) {
      SPBLoader loader = SPBLoader.fromJson(mapList[i]);
      list.add(loader);
    }
    return list;
  }

  Future<List<SPBLoader>> selectSPBLoaderBySPBID(SPB spb) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tSPBLoaderSchemaListTable,
        where: "${SPBLoaderEntity.spbId} = ?", whereArgs: [spb.spbId]);
    List<SPBLoader> list = [];
    for (int i = 0; i < mapList.length; i++) {
      SPBLoader loader = SPBLoader.fromJson(mapList[i]);
      list.add(loader);
    }
    return list;
  }

  void deleterSPBLoaderByID(String spbLoaderId) async {
    Database db = await DatabaseHelper().database;
    db.delete(tSPBLoaderSchemaListTable,
        where: '${SPBLoaderEntity.spbLoaderId}=?',
        whereArgs: [spbLoaderId]);
  }

  void deleteSPBLoader() async {
    Database db = await DatabaseHelper().database;
    db.delete(tSPBLoaderSchemaListTable);
  }
}

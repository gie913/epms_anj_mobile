import 'package:epms/database/entity/spb_supervise_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/spb_supervise.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSPBSupervise {
  void createTableSPB(Database db) async {
    await db.execute('''
      CREATE TABLE $tSPBSuperviseSchemaListTable(
      ${SPBSuperviseEntity.spbSuperviseId} TEXT NOT NULL,
      ${SPBSuperviseEntity.spbId} TEXT NOT NULL,
      ${SPBSuperviseEntity.supervisiEstateCode} TEXT,
      ${SPBSuperviseEntity.supervisiSpbEmployeeCode} TEXT,
      ${SPBSuperviseEntity.supervisiSpbEmployeeName} TEXT,
      ${SPBSuperviseEntity.supervisiSpbLat} TEXT,
      ${SPBSuperviseEntity.supervisiSpbLong} TEXT,
      ${SPBSuperviseEntity.supervisiSpbDriverEmployeeCode} TEXT,
      ${SPBSuperviseEntity.supervisiSpbDriverEmployeeName} TEXT,
      ${SPBSuperviseEntity.supervisiSpbDivisionCode} TEXT,
      ${SPBSuperviseEntity.supervisiSpbLicenseNumber} TEXT,
      ${SPBSuperviseEntity.supervisiSpbType} INT,
      ${SPBSuperviseEntity.supervisiSpbMethod} INT,
      ${SPBSuperviseEntity.supervisiSpbPhoto} TEXT,
      ${SPBSuperviseEntity.bunchesRipe} INT,
      ${SPBSuperviseEntity.bunchesOverripe} INT,
      ${SPBSuperviseEntity.bunchesHalfripe} INT,
      ${SPBSuperviseEntity.bunchesUnripe} INT,
      ${SPBSuperviseEntity.bunchesAbnormal} INT,
      ${SPBSuperviseEntity.bunchesEmpty} INT,
      ${SPBSuperviseEntity.looseFruits} INT,
      ${SPBSuperviseEntity.bunchesTotal} INT,
      ${SPBSuperviseEntity.bunchesTotalNormal} INT,
      ${SPBSuperviseEntity.bunchesTangkaiPanjang} INT,
      ${SPBSuperviseEntity.bunchesSampah} INT,
      ${SPBSuperviseEntity.bunchesBatu} INT,
      ${SPBSuperviseEntity.catatanBunchesTangkaiPanjang} TEXT,
      ${SPBSuperviseEntity.supervisiNotes} TEXT,
      ${SPBSuperviseEntity.createdBy} TEXT,
      ${SPBSuperviseEntity.supervisiSpbDate} TEXT,
      ${SPBSuperviseEntity.createdDate} TEXT,
      ${SPBSuperviseEntity.createdTime} TEXT,
      ${SPBSuperviseEntity.updatedBy} TEXT,
      ${SPBSuperviseEntity.updatedDate} TEXT,
      ${SPBSuperviseEntity.updatedTime} TEXT
      )
    ''');
  }

  Future<int> insertSPBSupervise(SPBSupervise object) async {
    Database db = await DatabaseHelper().database;
    int saved = await db.insert(tSPBSuperviseSchemaListTable, object.toJson());
    return saved;
  }

  Future<List<SPBSupervise>> selectSPBSupervise() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tSPBSuperviseSchemaListTable,
        groupBy: "${SPBSuperviseEntity.spbSuperviseId}");
    List<SPBSupervise> list = [];
    for (int i = 0; i < mapList.length; i++) {
      SPBSupervise spb = SPBSupervise.fromJson(mapList[i]);
      list.add(spb);
    }
    return list.reversed.toList();
  }

  Future<List> selectSPBSuperviseByID(String spbId) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tSPBSuperviseSchemaListTable,
        where: "${SPBSuperviseEntity.spbId} = ?", whereArgs: [spbId]);
    return mapList;
  }

  Future<int> updateSPBSuperviseByID(SPBSupervise object) async {
    Database db = await DatabaseHelper().database;
    int count = await db.update(tSPBSuperviseSchemaListTable, object.toJson(),
        where: '${SPBSuperviseEntity.spbSuperviseId}=?',
        whereArgs: [object.spbSuperviseId]);
    return count;
  }

  void deleteSPBSupervise() async {
    Database db = await DatabaseHelper().database;
    db.delete(tSPBSuperviseSchemaListTable);
  }
}

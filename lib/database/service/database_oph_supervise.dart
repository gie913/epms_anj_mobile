import 'package:epms/database/entity/oph_supervise_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/oph_supervise.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseOPHSupervise {
  void createTableOPHSupervise(Database db) async {
    await db.execute('''
      CREATE TABLE $tOPHSuperviseSchemaListTable(
      ${OPHSuperviseEntity.ophSupervisiId} TEXT NOT NULL,
        ${OPHSuperviseEntity.supervisiEstateCode} TEXT,
        ${OPHSuperviseEntity.supervisiBlockCode} TEXT,
        ${OPHSuperviseEntity.supervisiTphCode} TEXT,
        ${OPHSuperviseEntity.ophId} TEXT,
        ${OPHSuperviseEntity.supervisiEmployeeCode} TEXT,
        ${OPHSuperviseEntity.supervisiEmployeeName} TEXT,
        ${OPHSuperviseEntity.supervisiLat} TEXT,
        ${OPHSuperviseEntity.supervisiLong} TEXT,
        ${OPHSuperviseEntity.supervisiMandorEmployeeCode} TEXT,
        ${OPHSuperviseEntity.supervisiMandorEmployeeName} TEXT,
        ${OPHSuperviseEntity.supervisiKeraniPanenEmployeeCode} TEXT,
        ${OPHSuperviseEntity.supervisiKeraniPanenEmployeeName} TEXT,
        ${OPHSuperviseEntity.supervisiPemanenEmployeeName} TEXT,
         ${OPHSuperviseEntity.supervisiPemanenEmployeeCode} TEXT,
        ${OPHSuperviseEntity.supervisiPhoto} TEXT,
        ${OPHSuperviseEntity.supervisiDivisionCode} TEXT,
        ${OPHSuperviseEntity.bunchesRipe} INT,
        ${OPHSuperviseEntity.bunchesOverripe} INT,
        ${OPHSuperviseEntity.bunchesHalfripe} INT,
        ${OPHSuperviseEntity.bunchesUnripe} INT,
        ${OPHSuperviseEntity.bunchesAbnormal} INT,
        ${OPHSuperviseEntity.bunchesEmpty} INT,
        ${OPHSuperviseEntity.looseFruits} INT,
        ${OPHSuperviseEntity.bunchesTotal} INT,
        ${OPHSuperviseEntity.bunchesNotSent} INT,
        ${OPHSuperviseEntity.supervisiNotes} TEXT,
        ${OPHSuperviseEntity.createdBy} TEXT,
        ${OPHSuperviseEntity.supervisiDate} TEXT,
        ${OPHSuperviseEntity.createdDate} TEXT,
        ${OPHSuperviseEntity.createdTime} TEXT,
        ${OPHSuperviseEntity.updatedBy} TEXT,
        ${OPHSuperviseEntity.updatedDate} TEXT,
        ${OPHSuperviseEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertOPHSupervise(OPHSupervise object) async {
    Database db = await DatabaseHelper().database;
    int saved = await db.insert(tOPHSuperviseSchemaListTable, object.toJson());
    return saved;
  }

  Future<List<OPHSupervise>> selectOPHSupervise() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tOPHSuperviseSchemaListTable,
        groupBy: "${OPHSuperviseEntity.ophSupervisiId}");
    List<OPHSupervise> list = [];
    for (int i = 0; i < mapList.length; i++) {
      OPHSupervise oph = OPHSupervise.fromJson(mapList[i]);
      list.add(oph);
    }
    return list.reversed.toList();
  }

  Future<List> selectOPHSuperviseByID(String ophID) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tOPHSuperviseSchemaListTable,
        where: "${OPHSuperviseEntity.ophId} = ?", whereArgs: [ophID]);
    return mapList;
  }

  Future<int> updateOPHSuperviseByID(OPHSupervise object) async {
    Database db = await DatabaseHelper().database;
    int count = await db.update(tOPHSuperviseSchemaListTable, object.toJson(),
        where: '${OPHSuperviseEntity.ophSupervisiId}=?',
        whereArgs: [object.ophSupervisiId]);
    return count;
  }

  void deleteOPHSupervise() async {
    Database db = await DatabaseHelper().database;
    db.delete(tOPHSuperviseSchemaListTable);
  }
}

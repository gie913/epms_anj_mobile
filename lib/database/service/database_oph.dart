import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/database/entity/oph_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/model/laporan_panen_kemarin.dart';
import 'package:epms/model/oph.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_table.dart';

class DatabaseOPH {
  void createTableOPH(Database db) async {
    await db.execute('''
      CREATE TABLE $tOPHSchemaListTable(
       ${OPHEntity.ophId} TEXT NOT NULL,
       ${OPHEntity.ophCardId} TEXT,
       ${OPHEntity.ophHarvestingMethod} INT,
       ${OPHEntity.ophHarvestingType} INT,
       ${OPHEntity.ophEstateCode} TEXT,
       ${OPHEntity.ophPlantCode} TEXT,
       ${OPHEntity.ophDivisionCode} TEXT,
       ${OPHEntity.ophBlockCode} TEXT,
       ${OPHEntity.ophTphCode} TEXT,
       ${OPHEntity.ophNotes} TEXT,
       ${OPHEntity.ophLat} TEXT,
       ${OPHEntity.ophLong} TEXT,
       ${OPHEntity.ophPhoto} TEXT,
       ${OPHEntity.mandor1EmployeeCode} TEXT,
       ${OPHEntity.mandor1EmployeeName} TEXT,
       ${OPHEntity.keraniKirimEmployeeCode} TEXT,
       ${OPHEntity.keraniKirimEmployeeName} TEXT,
       ${OPHEntity.mandorEmployeeCode} TEXT,
       ${OPHEntity.mandorEmployeeName} TEXT,
       ${OPHEntity.keraniPanenEmployeeCode} TEXT,
       ${OPHEntity.keraniPanenEmployeeName} TEXT,
       ${OPHEntity.employeeCode} TEXT,
       ${OPHEntity.employeeName} TEXT,
       ${OPHEntity.bunchesRipe} INT,
       ${OPHEntity.bunchesOverripe} INT,
       ${OPHEntity.bunchesHalfripe} INT,
       ${OPHEntity.bunchesUnripe} INT,
       ${OPHEntity.bunchesAbnormal} INT,
       ${OPHEntity.bunchesEmpty} INT,
       ${OPHEntity.looseFruits} INT,
       ${OPHEntity.bunchesTotal} INT,
       ${OPHEntity.bunchesNotSent} INT,
       ${OPHEntity.ophEstimateTonnage} REAL,
       ${OPHEntity.isPlanned} INT,
       ${OPHEntity.isApproved} INT,
       ${OPHEntity.isRestantPermanent} INT,
       ${OPHEntity.ophApprovedBy} TEXT,
       ${OPHEntity.ophApprovedByName} TEXT,
       ${OPHEntity.ophApprovedDate} TEXT,
       ${OPHEntity.ophApprovedTime} TEXT,
       ${OPHEntity.ophCustomerCode} TEXT,
       ${OPHEntity.ophPickupDate} TEXT,
       ${OPHEntity.ophPickupTime} TEXT,
       ${OPHEntity.ophIsClosed} INT,
       ${OPHEntity.createdBy} TEXT,
       ${OPHEntity.createdDate} TEXT,
       ${OPHEntity.createdTime} TEXT,
       ${OPHEntity.updatedBy} TEXT,
       ${OPHEntity.updatedDate} TEXT,
       ${OPHEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertOPH(OPH object) async {
    Database db = await DatabaseHelper().database;
    int saved = await db.insert(tOPHSchemaListTable, object.toJson());
    return saved;
  }

  Future<List<OPH>> selectOPH() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tOPHSchemaListTable,
        orderBy: "${OPHEntity.createdTime}", groupBy: "${OPHEntity.ophId}");
    List<OPH> list = [];
    for (int i = 0; i < mapList.length; i++) {
      OPH oph = OPH.fromJson(mapList[i]);
      list.add(oph);
    }
    return list.reversed.toList();
  }

  Future<List<OPH>> selectOPHPhoto() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.rawQuery(
        "SELECT * From $tOPHSchemaListTable WHERE ${OPHEntity.ophPhoto} IS NULL ORDER BY ${OPHEntity.createdTime}");
    List<OPH> list = [];
    for (int i = 0; i < mapList.length; i++) {
      OPH oph = OPH.fromJson(mapList[i]);
      list.add(oph);
    }
    return list.reversed.toList();
  }

  Future<List<LaporanPanenKemarin>> selectOPHForListOPHHarian() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.rawQuery(
        "SELECT ${OPHEntity.employeeName}, ${OPHEntity.employeeCode}, SUM(${OPHEntity.bunchesRipe}) AS ${OPHEntity.bunchesRipe}, SUM(${OPHEntity.bunchesOverripe}) AS ${OPHEntity.bunchesOverripe}, SUM(${OPHEntity.bunchesHalfripe}) AS ${OPHEntity.bunchesHalfripe},SUM(${OPHEntity.bunchesUnripe}) AS ${OPHEntity.bunchesUnripe},SUM(${OPHEntity.bunchesAbnormal}) AS ${OPHEntity.bunchesAbnormal},SUM(${OPHEntity.bunchesEmpty}) AS ${OPHEntity.bunchesEmpty},SUM(${OPHEntity.looseFruits}) AS ${OPHEntity.looseFruits},SUM(${OPHEntity.bunchesTotal}) AS ${OPHEntity.bunchesTotal},SUM(${OPHEntity.bunchesNotSent}) AS ${OPHEntity.bunchesTotal}, ${OPHEntity.createdDate} FROM $tOPHSchemaListTable GROUP BY ${OPHEntity.employeeName}, ${OPHEntity.employeeCode} ");
    List<LaporanPanenKemarin> list = [];
    print(mapList);
    for (int i = 0; i < mapList.length; i++) {
      LaporanPanenKemarin laporanPanenKemarin =
          LaporanPanenKemarin.fromJson(mapList[i]);
      list.add(laporanPanenKemarin);
    }
    return list.reversed.toList();
  }

  Future<List<LaporanPanenKemarin>> selectLaporanHarian() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.rawQuery(
        "SELECT ${OPHEntity.employeeName}, ${OPHEntity.employeeCode}, ${OPHEntity.createdDate}, SUM(${OPHEntity.bunchesRipe}) AS ${OPHEntity.bunchesRipe}, SUM(${OPHEntity.bunchesUnripe}) AS ${OPHEntity.bunchesUnripe}, SUM(${OPHEntity.bunchesOverripe}) AS ${OPHEntity.bunchesOverripe}, SUM(${OPHEntity.bunchesHalfripe}) AS ${OPHEntity.bunchesHalfripe},  SUM(${OPHEntity.looseFruits}) AS ${OPHEntity.looseFruits}, SUM(${OPHEntity.bunchesAbnormal}) AS ${OPHEntity.bunchesAbnormal}, SUM(${OPHEntity.bunchesEmpty}) AS ${OPHEntity.bunchesEmpty}, SUM(${OPHEntity.bunchesTotal}) AS ${OPHEntity.bunchesTotal}, SUM(${OPHEntity.bunchesNotSent}) AS ${OPHEntity.bunchesNotSent}, FROM_TYPE FROM (SELECT $laporanPanenKemarinTable.${OPHEntity.employeeName} AS ${OPHEntity.employeeName}, $laporanPanenKemarinTable.${OPHEntity.employeeCode} AS ${OPHEntity.employeeCode} , $laporanPanenKemarinTable.${OPHEntity.bunchesRipe} AS ${OPHEntity.bunchesRipe}, $laporanPanenKemarinTable.${OPHEntity.bunchesOverripe} AS ${OPHEntity.bunchesOverripe}, $laporanPanenKemarinTable.${OPHEntity.bunchesHalfripe} AS ${OPHEntity.bunchesHalfripe}, $laporanPanenKemarinTable.${OPHEntity.bunchesUnripe} AS ${OPHEntity.bunchesUnripe}, $laporanPanenKemarinTable.${OPHEntity.bunchesAbnormal} AS ${OPHEntity.bunchesAbnormal}, $laporanPanenKemarinTable.${OPHEntity.bunchesEmpty} AS ${OPHEntity.bunchesEmpty}, $laporanPanenKemarinTable.${OPHEntity.looseFruits} AS ${OPHEntity.looseFruits}, $laporanPanenKemarinTable.${OPHEntity.bunchesTotal} AS ${OPHEntity.bunchesTotal}, $laporanPanenKemarinTable.${OPHEntity.bunchesNotSent} AS ${OPHEntity.bunchesNotSent}, $laporanPanenKemarinTable.${OPHEntity.createdDate} AS ${OPHEntity.createdDate}, 'laporan_kemarin' AS FROM_TYPE FROM $laporanPanenKemarinTable WHERE $laporanPanenKemarinTable.${OPHEntity.createdDate} = '${TimeManager.dateWithDash(DateTime.now())}' UNION ALL SELECT $tOPHSchemaListTable.${OPHEntity.employeeName} AS ${OPHEntity.employeeName}, $tOPHSchemaListTable.${OPHEntity.employeeCode} AS ${OPHEntity.employeeCode} , $tOPHSchemaListTable.${OPHEntity.bunchesRipe} AS ${OPHEntity.bunchesRipe}, $tOPHSchemaListTable.${OPHEntity.bunchesOverripe} AS ${OPHEntity.bunchesOverripe}, $tOPHSchemaListTable.${OPHEntity.bunchesHalfripe} AS ${OPHEntity.bunchesHalfripe}, $tOPHSchemaListTable.${OPHEntity.bunchesUnripe} AS ${OPHEntity.bunchesUnripe}, $tOPHSchemaListTable.${OPHEntity.bunchesAbnormal} AS ${OPHEntity.bunchesAbnormal}, $tOPHSchemaListTable.${OPHEntity.bunchesEmpty} AS ${OPHEntity.bunchesEmpty}, $tOPHSchemaListTable.${OPHEntity.looseFruits} AS ${OPHEntity.looseFruits}, $tOPHSchemaListTable.${OPHEntity.bunchesTotal} AS ${OPHEntity.bunchesTotal}, $tOPHSchemaListTable.${OPHEntity.bunchesNotSent} AS ${OPHEntity.bunchesNotSent}, $tOPHSchemaListTable.${OPHEntity.createdDate} AS ${OPHEntity.createdDate}, 'oph' AS FROM_TYPE FROM $tOPHSchemaListTable ) t_laporan_kemarin_temp GROUP BY ${OPHEntity.employeeCode}, ${OPHEntity.createdDate}");
    List<LaporanPanenKemarin> list = [];
    for (int i = 0; i < mapList.length; i++) {
      LaporanPanenKemarin laporanPanenKemarin =
          LaporanPanenKemarin.fromJson(mapList[i]);
      list.add(laporanPanenKemarin);
    }
    return list.reversed.toList();
  }

  Future<OPH?> selectOPHLast() async {
    OPH? ophLast;
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tOPHSchemaListTable,
        orderBy: "${OPHEntity.createdTime}");
    if (mapList.isNotEmpty) {
      ophLast = OPH.fromJson(mapList.last);
    }
    return ophLast;
  }

  Future<OPH?> selectOPHByID(String ophID) async {
    OPH? oph;
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tOPHSchemaListTable,
        where: "${OPHEntity.ophId} = ?", whereArgs: [ophID]);
    if (mapList.isNotEmpty) {
      oph = OPH.fromJson(mapList[0]);
    }
    return oph;
  }

  Future<int> updateOPHByID(OPH object) async {
    Database db = await DatabaseHelper().database;
    int count = await db.update(tOPHSchemaListTable, object.toJson(),
        where: '${OPHEntity.ophId}=?', whereArgs: [object.ophId]);
    return count;
  }

  void deleteOPHById(OPH object) async {
    Database db = await DatabaseHelper().database;
    db.delete(tOPHSchemaListTable,
        where: '${OPHEntity.ophId}=?', whereArgs: [object.ophId]);
  }

  void deleteOPH() async {
    Database db = await DatabaseHelper().database;
    db.delete(tOPHSchemaListTable);
  }
}

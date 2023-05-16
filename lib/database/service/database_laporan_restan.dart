import 'package:epms/database/entity/laporan_restan_entity.dart';
import 'package:epms/model/laporan_restan.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';
import '../helper/database_table.dart';

class DatabaseLaporanRestan {
  void createLaporanRestan(Database db) async {
    await db.execute('''
      CREATE TABLE $laporanRestanTable(
       ${LaporanRestantEntity.ophId} TEXT NOT NULL,
       ${LaporanRestantEntity.ophCardId} TEXT,
       ${LaporanRestantEntity.ophHarvestingMethod} INT,
       ${LaporanRestantEntity.ophHarvestingType} INT,
       ${LaporanRestantEntity.ophEstateCode} TEXT,
       ${LaporanRestantEntity.ophDivisionCode} TEXT,
       ${LaporanRestantEntity.ophBlockCode} TEXT,
       ${LaporanRestantEntity.ophTphCode} TEXT,
       ${LaporanRestantEntity.ophNotes} TEXT,
       ${LaporanRestantEntity.mandorEmployeeCode} TEXT,
       ${LaporanRestantEntity.mandorEmployeeName} TEXT,
       ${LaporanRestantEntity.keraniPanenEmployeeCode} TEXT,
       ${LaporanRestantEntity.keraniPanenEmployeeName} TEXT,
       ${LaporanRestantEntity.employeeCode} TEXT,
       ${LaporanRestantEntity.employeeName} TEXT,
       ${LaporanRestantEntity.bunchesRipe} INT,
       ${LaporanRestantEntity.bunchesOverripe} INT,
       ${LaporanRestantEntity.bunchesHalfripe} INT,
       ${LaporanRestantEntity.bunchesUnripe} INT,
       ${LaporanRestantEntity.bunchesAbnormal} INT,
       ${LaporanRestantEntity.bunchesEmpty} INT,
       ${LaporanRestantEntity.looseFruits} INT,
       ${LaporanRestantEntity.bunchesTotal} INT,
       ${LaporanRestantEntity.bunchesNotSent} INT,
       ${LaporanRestantEntity.ophEstimateTonnage} REAL,
       ${LaporanRestantEntity.isPlanned} INT,
       ${LaporanRestantEntity.isRestantPermanent} INT,
       ${LaporanRestantEntity.ophCustomerCode} TEXT,
       ${LaporanRestantEntity.ophPickupDate} TEXT,
       ${LaporanRestantEntity.ophPickupTime} TEXT,
       ${LaporanRestantEntity.createdDate} TEXT,
       ${LaporanRestantEntity.createdTime} TEXT)
    ''');
  }

  Future<int> insertLaporanRestan(List<LaporanRestan> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    for (int i = 0; i < object.length; i++) {
      int saved = await db.insert(laporanRestanTable, object[i].toJson());
      count = count + saved;
    }
    return count;
  }

  Future<List<LaporanRestan>> selectLaporanRestan() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(laporanRestanTable);
    List<LaporanRestan> list = [];
    for (int i = 0; i < mapList.length; i++) {
      LaporanRestan laporanRestan = LaporanRestan.fromJson(mapList[i]);
      list.add(laporanRestan);
    }
    return list;
  }

  void deleteLaporanRestan() async {
    Database db = await DatabaseHelper().database;
    db.delete(laporanRestanTable);
  }
}

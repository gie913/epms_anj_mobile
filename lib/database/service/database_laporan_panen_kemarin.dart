import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/database/entity/laporan_panen_kemarin_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/laporan_panen_kemarin.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseLaporanPanenKemarin {
  void createLaporanPanenKemarin(Database db) async {
    await db.execute('''
      CREATE TABLE $laporanPanenKemarinTable(
       ${LaporanPanenKemarinEntity.employeeCode} TEXT,
       ${LaporanPanenKemarinEntity.employeeName} TEXT,
       ${LaporanPanenKemarinEntity.bunchesRipe} INT,
       ${LaporanPanenKemarinEntity.bunchesOverripe} INT,
       ${LaporanPanenKemarinEntity.bunchesHalfripe} INT,
       ${LaporanPanenKemarinEntity.bunchesUnripe} INT,
       ${LaporanPanenKemarinEntity.bunchesAbnormal} INT,
       ${LaporanPanenKemarinEntity.bunchesEmpty} INT,
       ${LaporanPanenKemarinEntity.looseFruits} INT,
       ${LaporanPanenKemarinEntity.bunchesTotal} INT,
       ${LaporanPanenKemarinEntity.bunchesNotSent} INT,
       ${LaporanPanenKemarinEntity.createdDate} TEXT)
    ''');
  }

  Future<int> insertLaporanPanenKemarin(
      List<LaporanPanenKemarin> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    List<LaporanPanenKemarin> listLaporanKemarin =
        await selectLaporanPanenKemarin();
    for (int i = 0; i < object.length; i++) {
      if (!(listLaporanKemarin.contains(object[i]))) {
        int saved =
            await db.insert(laporanPanenKemarinTable, object[i].toJson());
        count = count + saved;
      }
    }
    return count;
  }

  Future<int> updateLaporanPanenKemarin(
      List<LaporanPanenKemarin> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    for (int i = 0; i < object.length; i++) {
      int saved = await db.update(laporanPanenKemarinTable, object[i].toJson());
      count = count + saved;
    }
    return count;
  }

  Future<List<LaporanPanenKemarin>> selectLaporanPanenKemarinByDate(
      String date) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(laporanPanenKemarinTable,
        where: "${LaporanPanenKemarinEntity.createdDate}=?", whereArgs: [date]);
    List<LaporanPanenKemarin> list = [];
    for (int i = 0; i < mapList.length; i++) {
      LaporanPanenKemarin laporanPanenKemarin =
          LaporanPanenKemarin.fromJson(mapList[i]);
      list.add(laporanPanenKemarin);
    }
    return list;
  }

  Future<List<LaporanPanenKemarin>> selectLaporanPanenKemarin() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(laporanPanenKemarinTable);
    List<LaporanPanenKemarin> list = [];
    for (int i = 0; i < mapList.length; i++) {
      LaporanPanenKemarin laporanPanenKemarin =
          LaporanPanenKemarin.fromJson(mapList[i]);
      list.add(laporanPanenKemarin);
    }
    return list;
  }

  void deleteLaporanPanenKemarin() async {
    Database db = await DatabaseHelper().database;
    db.delete(laporanPanenKemarinTable);
  }

  void deleteLaporanPanenKemarinByDate() async {
    DateTime now = DateTime.now();
    String createdDate = TimeManager.dateWithDash(now);
    Database db = await DatabaseHelper().database;
    db.delete(laporanPanenKemarinTable,
        where: "${LaporanPanenKemarinEntity.createdDate}=?",
        whereArgs: [createdDate]);
  }
}

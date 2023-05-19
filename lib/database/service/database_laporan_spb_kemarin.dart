import 'package:epms/model/laporan_spb_kemarin.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/laporan_spb_kemarin_entity.dart';
import '../helper/database_table.dart';
import '../helper/database_helper.dart';

class DatabaseLaporanSPBKemarin {
  void createTableLaporanSPBKemarin(Database db) async {
    await db.execute('''
      CREATE TABLE $laporanSPBKemarinTable(
       ${LaporanSPBKemarinEntity.spbId} TEXT NOT NULL,
       ${LaporanSPBKemarinEntity.spbCardId} TEXT,
       ${LaporanSPBKemarinEntity.spbEstateCode} TEXT,
       ${LaporanSPBKemarinEntity.spbDivisionCode} TEXT,
       ${LaporanSPBKemarinEntity.spbLicenseNumber} TEXT,
       ${LaporanSPBKemarinEntity.spbType} TEXT,
       ${LaporanSPBKemarinEntity.spbDeliverToCode} TEXT,
       ${LaporanSPBKemarinEntity.spbDeliverToName} TEXT,
       ${LaporanSPBKemarinEntity.spbDeliveryNote} TEXT,
       ${LaporanSPBKemarinEntity.spbLat} TEXT,
       ${LaporanSPBKemarinEntity.spbLong} TEXT,
       ${LaporanSPBKemarinEntity.spbPhoto} TEXT,
       ${LaporanSPBKemarinEntity.spbKeraniTransportEmployeeCode} TEXT,
       ${LaporanSPBKemarinEntity.spbKeraniTransportEmployeeName} TEXT,
       ${LaporanSPBKemarinEntity.spbDriverEmployeeCode} TEXT,
       ${LaporanSPBKemarinEntity.spbDriverEmployeeName} TEXT,
       ${LaporanSPBKemarinEntity.spbTotalBunches} INT,
       ${LaporanSPBKemarinEntity.spbTotalOph} INT,
       ${LaporanSPBKemarinEntity.spbTotalLooseFruit} INT,
       ${LaporanSPBKemarinEntity.spbCapacityTonnage} REAL,
       ${LaporanSPBKemarinEntity.spbEstimateTonnage} REAL,
       ${LaporanSPBKemarinEntity.spbActualWeightDate} TEXT,
       ${LaporanSPBKemarinEntity.spbActualWeightTime} TEXT,
       ${LaporanSPBKemarinEntity.spbActualTonnage} REAL,
       ${LaporanSPBKemarinEntity.spbIsClosed} INT,
       ${LaporanSPBKemarinEntity.spbCertificateId} TEXT,
       ${LaporanSPBKemarinEntity.createdDate} TEXT,
       ${LaporanSPBKemarinEntity.createdTime} TEXT,
       ${LaporanSPBKemarinEntity.certificationCertNoRspo} TEXT,
       ${LaporanSPBKemarinEntity.certificationCertNoIspo} TEXT,
       ${LaporanSPBKemarinEntity.certificationCertNoIscc} TEXT,
       ${LaporanSPBKemarinEntity.certificationNilaiGhgNoRspo} TEXT,
       ${LaporanSPBKemarinEntity.certificationNilaiGhgNoIspo} TEXT,
       ${LaporanSPBKemarinEntity.certificationNilaiGhgNoIscc} TEXT,
       ${LaporanSPBKemarinEntity.certificationIsccId} TEXT,
       ${LaporanSPBKemarinEntity.certificationIspoId} TEXT,
       ${LaporanSPBKemarinEntity.certificationRspoId} TEXT)
    ''');
  }

  Future<int> insertLaporanSPBKemarin(List<LaporanSPBKemarin> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    List<LaporanSPBKemarin> listLaporanKemarin = await selectLaporanSPBKemarin();
    for (int i = 0; i < object.length; i++) {
     if(!(listLaporanKemarin.contains(object[i]))) {
       int saved = await db.insert(laporanSPBKemarinTable, object[i].toJson());
       count = count + saved;
     }
    }
    return count;
  }

  Future<List<LaporanSPBKemarin>> selectLaporanSPBKemarin() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(laporanSPBKemarinTable);
    List<LaporanSPBKemarin> list = [];
    for (int i = 0; i < mapList.length; i++) {
      LaporanSPBKemarin oph = LaporanSPBKemarin.fromJson(mapList[i]);
      list.add(oph);
    }
    return list;
  }

  void deleteLaporanSPBKemarin() async {
    Database db = await DatabaseHelper().database;
    db.delete(laporanSPBKemarinTable);
  }
}

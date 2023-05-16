import 'package:epms/database/entity/oph_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
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
    var mapList = await db.query(tOPHSchemaListTable, orderBy: "${OPHEntity.createdTime}");
    List<OPH> list = [];
    for (int i = 0; i < mapList.length; i++) {
      OPH oph = OPH.fromJson(mapList[i]);
      list.add(oph);
    }
    return list.reversed.toList();
  }

  Future<OPH?> selectOPHByID(String ophID) async {
    OPH? oph;
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tOPHSchemaListTable,
        where: "${OPHEntity.ophId} = ?", whereArgs: [ophID]);
    if(mapList.isNotEmpty) {
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

  void deleteOPH() async {
    Database db = await DatabaseHelper().database;
    db.delete(tOPHSchemaListTable);
  }
}

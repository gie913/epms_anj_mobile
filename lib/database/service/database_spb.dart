import 'package:epms/database/entity/spb_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/spb.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseSPB {
  void createTableSPB(Database db) async {
    await db.execute('''
      CREATE TABLE $tSPBSchemaListTable(
       ${SPBEntity.spbId} TEXT NOT NULL,
       ${SPBEntity.spbCardId} TEXT,
       ${SPBEntity.spbEstateCode} TEXT,
       ${SPBEntity.spbDivisionCode} TEXT,
       ${SPBEntity.spbLicenseNumber} TEXT,
       ${SPBEntity.spbType} INT,
       ${SPBEntity.spbVendorOthers} TEXT,
       ${SPBEntity.spbDeliverToCode} TEXT,
       ${SPBEntity.spbDeliverToName} TEXT,
       ${SPBEntity.spbDeliveryNote} TEXT,
       ${SPBEntity.spbLat} TEXT,
       ${SPBEntity.spbLong} TEXT,
       ${SPBEntity.spbPhoto} TEXT,
       ${SPBEntity.spbKeraniTransportEmployeeCode} TEXT,
       ${SPBEntity.spbKeraniTransportEmployeeName} TEXT,
       ${SPBEntity.spbDriverEmployeeCode} TEXT,
       ${SPBEntity.spbDriverEmployeeName} TEXT,
       ${SPBEntity.spbTotalBunches} INT,
       ${SPBEntity.spbTotalOph} INT,
       ${SPBEntity.spbTotalLooseFruit} INT,
       ${SPBEntity.spbCapacityTonnage} REAL,
       ${SPBEntity.spbEstimateTonnage} REAL,
       ${SPBEntity.spbActualWeightDate} TEXT,
       ${SPBEntity.spbActualWeightTime} TEXT,
       ${SPBEntity.spbActualTonnage} REAL,
       ${SPBEntity.spbEstateVendorCode} TEXT,
       ${SPBEntity.spbIsClosed} INT,
       ${SPBEntity.createdBy} TEXT,
       ${SPBEntity.createdDate} TEXT,
       ${SPBEntity.createdTime} TEXT,
       ${SPBEntity.updatedBy} TEXT,
       ${SPBEntity.updatedDate} TEXT,
       ${SPBEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertSPB(SPB object) async {
    Database db = await DatabaseHelper().database;
    int saved = await db.insert(tSPBSchemaListTable, object.toJson());
    return saved;
  }

  Future<List<SPB>> selectSPB() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tSPBSchemaListTable);
    List<SPB> list = [];
    for (int i = 0; i < mapList.length; i++) {
      SPB spb = SPB.fromJson(mapList[i]);
      list.add(spb);
    }
    return list.reversed.toList();
  }

  Future<int> updateSPBByID(SPB object) async {
    Database db = await DatabaseHelper().database;
    int count = await db.update(tSPBSchemaListTable, object.toJson(),
        where: '${SPBEntity.spbId}=?', whereArgs: [object.spbId]);
    return count;
  }

  Future<SPB?> selectSPBByID(String spbID) async {
    SPB? spb;
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tSPBSchemaListTable,
        where: "${SPBEntity.spbId}=?", whereArgs: [spbID]);
    if(mapList.isNotEmpty) {
      spb = SPB.fromJson(mapList[0]);
    }
    return spb;
  }

  void deleteSPB() async {
    Database db = await DatabaseHelper().database;
    db.delete(tSPBSchemaListTable);
  }
}

import 'package:epms/database/entity/tbs_luar_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/tbs_luar.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseTBSLuar {
  void createTableTBSLuar(Database db) async {
    await db.execute('''
      CREATE TABLE $tTBSLuar(
       ${TBSLuarEntity.sortasiID} TEXT NOT NULL,
       ${TBSLuarEntity.supervisiName} TEXT,
       ${TBSLuarEntity.gpsLat} TEXT,
       ${TBSLuarEntity.gpsLong} TEXT,
       ${TBSLuarEntity.contractNumber} TEXT,
       ${TBSLuarEntity.supplierCode} TEXT,
       ${TBSLuarEntity.supplierName} TEXT,
       ${TBSLuarEntity.formType} INT,
       ${TBSLuarEntity.driverName} TEXT,
       ${TBSLuarEntity.licenseNumber} TEXT,
       ${TBSLuarEntity.spbID} TEXT,
       ${TBSLuarEntity.bunchesLess4kg} INT,
       ${TBSLuarEntity.bunchesCengkeh} INT,
       ${TBSLuarEntity.brondolanRotten} INT,
       ${TBSLuarEntity.quantity} INT,
       ${TBSLuarEntity.bunchesHalfripe} INT,
       ${TBSLuarEntity.bunchesAbnormal} INT,
       ${TBSLuarEntity.bunchesEmpty} INT,
       ${TBSLuarEntity.deduction} INT,
       ${TBSLuarEntity.bunchesTotal} INT,
       ${TBSLuarEntity.bunchesUnripe} INT,
       ${TBSLuarEntity.bunchesOverripe} INT,
       ${TBSLuarEntity.bunchesRotten} INT,
       ${TBSLuarEntity.rubbish} INT,
       ${TBSLuarEntity.water} INT,
       ${TBSLuarEntity.longStalk} INT,
       ${TBSLuarEntity.notes} TEXT,
       ${TBSLuarEntity.gradingPhoto} TEXT,
       ${TBSLuarEntity.small} INT,
       ${TBSLuarEntity.medium} INT,
       ${TBSLuarEntity.large} INT,
       ${TBSLuarEntity.createdBy} TEXT,
       ${TBSLuarEntity.createdDate} TEXT,
       ${TBSLuarEntity.createdTime} TEXT,
       ${TBSLuarEntity.updatedBy} TEXT,
       ${TBSLuarEntity.updatedDate} TEXT,
       ${TBSLuarEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertTBSLuar(TBSLuar object) async {
    Database db = await DatabaseHelper().database;
    int saved = await db.insert(tTBSLuar, object.toJson());
    return saved;
  }

  Future<List<TBSLuar>> selectTBSLuar() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tTBSLuar,
        orderBy: "${TBSLuarEntity.createdTime}",
        groupBy: "${TBSLuarEntity.sortasiID}");
    List<TBSLuar> list = [];
    for (int i = 0; i < mapList.length; i++) {
      TBSLuar oph = TBSLuar.fromJson(mapList[i]);
      list.add(oph);
    }
    return list.reversed.toList();
  }

  Future<TBSLuar?> selectTBSLuarByID(String deliveryID) async {
    TBSLuar? oph;
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tTBSLuar,
        where: "${TBSLuarEntity.spbID} = ?", whereArgs: [deliveryID]);
    if (mapList.isNotEmpty) {
      oph = TBSLuar.fromJson(mapList[0]);
    }
    return oph;
  }

  Future<int> updateTBSLuarByID(TBSLuar object) async {
    Database db = await DatabaseHelper().database;
    int count = await db.update(tTBSLuar, object.toJson(),
        where: '${TBSLuarEntity.sortasiID}=?', whereArgs: [object.sortasiID]);
    return count;
  }

  void deleteTBSLuar() async {
    Database db = await DatabaseHelper().database;
    db.delete(tTBSLuar);
  }
}

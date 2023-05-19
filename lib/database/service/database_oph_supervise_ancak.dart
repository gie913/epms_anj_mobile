import 'package:epms/database/entity/oph_supervise_ancak_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/oph_supervise_ancak.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseOPHSuperviseAncak {
  void createTableOPH(Database db) async {
    await db.execute('''
      CREATE TABLE $tSuperviseAncakPanenSchemaListTable(
      ${OPHSuperviseAncakEntity.supervisiAncakId} TEXT NOT Null,
        ${OPHSuperviseAncakEntity.supervisiAncakEstateCode} TEXT,
        ${OPHSuperviseAncakEntity.supervisiAncakBlockCode} TEXT,
        ${OPHSuperviseAncakEntity.supervisiAncakLat} TEXT,
        ${OPHSuperviseAncakEntity.supervisiAncakLong} TEXT,
        ${OPHSuperviseAncakEntity.supervisiAncakLatEnd} TEXT,
        ${OPHSuperviseAncakEntity.supervisiAncakLongEnd} TEXT,
        ${OPHSuperviseAncakEntity.supervisiAncakMandorEmployeeCode} TEXT,
        ${OPHSuperviseAncakEntity.supervisiAncakMandorEmployeeName} TEXT,
        ${OPHSuperviseAncakEntity.supervisiAncakPemanenEmployeeCode} TEXT,
        ${OPHSuperviseAncakEntity.supervisiAncakPemanenEmployeeName} TEXT,
        ${OPHSuperviseAncakEntity.supervisiAncakAssignToId} INT,
        ${OPHSuperviseAncakEntity.supervisiAncakAssignToName} TEXT,
        ${OPHSuperviseAncakEntity.supervisiAncakPhoto} TEXT,
        ${OPHSuperviseAncakEntity.supervisiAncakDivisionCode} TEXT,
        ${OPHSuperviseAncakEntity.pokokSample} TEXT,
        ${OPHSuperviseAncakEntity.bunchesVCut} INT,
        ${OPHSuperviseAncakEntity.bunchesRat} INT,
        ${OPHSuperviseAncakEntity.bunchesTangkaiPanjang} INT,
        ${OPHSuperviseAncakEntity.pelepahSengkleh} INT,
        ${OPHSuperviseAncakEntity.bunchesTinggal} INT,
        ${OPHSuperviseAncakEntity.bunchesTinggalPercentage} INT,
        ${OPHSuperviseAncakEntity.bunchesBrondolanTinggal} INT,
        ${OPHSuperviseAncakEntity.bunchesBrondolanTinggalPercentage} INT,
        ${OPHSuperviseAncakEntity.bunchesTotal} INT,
        ${OPHSuperviseAncakEntity.looseFruits} INT,
        ${OPHSuperviseAncakEntity.supervisiAncakNotes} TEXT,
        ${OPHSuperviseAncakEntity.createdBy} TEXT,
        ${OPHSuperviseAncakEntity.supervisiAncakEmployeeCode} TEXT,
        ${OPHSuperviseAncakEntity.supervisiAncakEmployeeName} TEXT,
        ${OPHSuperviseAncakEntity.supervisiAncakDate} TEXT,
        ${OPHSuperviseAncakEntity.createdDate} TEXT,
        ${OPHSuperviseAncakEntity.createdTime} TEXT,
        ${OPHSuperviseAncakEntity.updatedBy} TEXT,
        ${OPHSuperviseAncakEntity.updatedDate} TEXT,
        ${OPHSuperviseAncakEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertOPHSuperviseAncak(OPHSuperviseAncak object) async {
    Database db = await DatabaseHelper().database;
    int saved =
        await db.insert(tSuperviseAncakPanenSchemaListTable, object.toJson());
    return saved;
  }

  Future<List<OPHSuperviseAncak>> selectOPHSuperviseAncak() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tSuperviseAncakPanenSchemaListTable,
        groupBy: "${OPHSuperviseAncakEntity.supervisiAncakId}");
    List<OPHSuperviseAncak> list = [];
    for (int i = 0; i < mapList.length; i++) {
      OPHSuperviseAncak oph = OPHSuperviseAncak.fromJson(mapList[i]);
      list.add(oph);
    }
    return list.reversed.toList();
  }

  Future<List> selectOPHSuperviseAncakByID(OPHSuperviseAncak oph) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tSuperviseAncakPanenSchemaListTable,
        where: "${OPHSuperviseAncakEntity.supervisiAncakId} = ?",
        whereArgs: [oph.supervisiAncakId]);
    return mapList;
  }

  Future<int> updateOPHSuperviseAncakByID(OPHSuperviseAncak object) async {
    Database db = await DatabaseHelper().database;
    int count = await db.update(
        tSuperviseAncakPanenSchemaListTable, object.toJson(),
        where: '${OPHSuperviseAncakEntity.supervisiAncakId}=?',
        whereArgs: [object.supervisiAncakId]);
    return count;
  }

  void deleteOPHSuperviseAncak() async {
    Database db = await DatabaseHelper().database;
    db.delete(tSuperviseAncakPanenSchemaListTable);
  }
}

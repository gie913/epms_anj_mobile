import 'package:epms/database/entity/supervisi_3rd_party_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/supervisi_3rd_party.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseTBSLuarOneMonth {
  void createTableTBSLuarOneMonth(Database db) async {
    await db.execute('''
      CREATE TABLE $tTBSLuarOneMonth(
       ${Supervisi3rdPartyEntity.sortasiId} TEXT NOT NULL,
       ${Supervisi3rdPartyEntity.spbId} TEXT,
       ${Supervisi3rdPartyEntity.gradingDate} TEXT)
    ''');
  }

  Future<int> insertTBSLuarOneMonth(List<Supervisi3rdParty> objectList) async {
    Database db = await DatabaseHelper().database;
    Batch batch = db.batch();
    objectList.forEach((val) {
      Supervisi3rdParty supervisi3rdParty = val;
      batch.insert(tTBSLuarOneMonth, supervisi3rdParty.toJson());
    });
    List<Object?> i = await batch.commit();
    return i.length;
  }

  Future<List<Supervisi3rdParty>> selectTBSLuarOneMonth() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tTBSLuarOneMonth);
    List<Supervisi3rdParty> list = [];
    for (int i = 0; i < mapList.length; i++) {
      Supervisi3rdParty supervisi3rdParty =
          Supervisi3rdParty.fromJson(mapList[i]);
      list.add(supervisi3rdParty);
    }
    return list.reversed.toList();
  }

  Future<Supervisi3rdParty?> selectTBSLuarOneMonthByID(
      String deliveryID) async {
    Supervisi3rdParty? supervisi3rdParty;
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tTBSLuarOneMonth,
        where: "${Supervisi3rdPartyEntity.spbId} = ?", whereArgs: [deliveryID]);
    if (mapList.isNotEmpty) {
      supervisi3rdParty = Supervisi3rdParty.fromJson(mapList[0]);
    }
    return supervisi3rdParty;
  }

  void deleteTBSLuarOneMonth() async {
    Database db = await DatabaseHelper().database;
    db.delete(tTBSLuarOneMonth);
  }
}

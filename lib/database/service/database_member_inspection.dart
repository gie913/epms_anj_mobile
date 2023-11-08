import 'package:epms/database/entity/member_inspection_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/member_inspection_model.dart';
import 'package:epms/model/team_inspection_model.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseMemberInspection {
  void createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $memberInspectionTable(
       ${MemberInspectionEntity.id} TEXT,
       ${MemberInspectionEntity.mTeamId} TEXT,
       ${MemberInspectionEntity.mUserId} TEXT,
       ${MemberInspectionEntity.isActive} INTEGER,
       ${MemberInspectionEntity.createdAt} TEXT,
       ${MemberInspectionEntity.createdBy} TEXT,
       ${MemberInspectionEntity.updatedAt} TEXT,
       ${MemberInspectionEntity.updatedBy} TEXT)
    ''');
  }

  static Future<void> insetData(List<TeamInspectionModel> data) async {
    Database db = await DatabaseHelper().database;

    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < data[i].member.length; j++) {
        await db.insert(memberInspectionTable, data[i].member[j].toJson());
      }
    }
  }

  static Future<List<MemberInspectionModel>> selectData() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(memberInspectionTable);
    var data = List<MemberInspectionModel>.from(mapList.map((e) {
      return MemberInspectionModel.fromJson(e);
    }));
    return data;
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(memberInspectionTable);
  }
}

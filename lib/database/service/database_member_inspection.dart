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
       ${MemberInspectionEntity.mUserId} TEXT,
       ${MemberInspectionEntity.mTeamId} TEXT,
       ${MemberInspectionEntity.mCompanyId} TEXT,
       ${MemberInspectionEntity.mDivisionId} TEXT,
       ${MemberInspectionEntity.mEstateId} TEXT,
       ${MemberInspectionEntity.mUserName} TEXT,
       ${MemberInspectionEntity.mUserCode} TEXT,
       ${MemberInspectionEntity.mTeamName} TEXT,
       ${MemberInspectionEntity.mCompanyAlias} TEXT,
       ${MemberInspectionEntity.mDivisionName} TEXT)
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

  static Future<List<MemberInspectionModel>> selectData({
    required String teamId,
    required String companyId,
    required String estateId,
    required String divisiId,
  }) async {
    Database db = await DatabaseHelper().database;

    if (estateId.isNotEmpty && divisiId.isEmpty) {
      var mapList = await db.query(
        memberInspectionTable,
        where:
            '${MemberInspectionEntity.mTeamId}=? AND ${MemberInspectionEntity.mCompanyId}=? AND ${MemberInspectionEntity.mEstateId}=?',
        whereArgs: [teamId, companyId, estateId],
      );
      var data = List<MemberInspectionModel>.from(mapList.map((e) {
        return MemberInspectionModel.fromJson(e);
      }));
      return data;
    } else if (estateId.isNotEmpty && divisiId.isNotEmpty) {
      var mapList = await db.query(
        memberInspectionTable,
        where:
            '${MemberInspectionEntity.mTeamId}=? AND ${MemberInspectionEntity.mCompanyId}=? AND ${MemberInspectionEntity.mEstateId}=? AND ${MemberInspectionEntity.mDivisionId}=?',
        whereArgs: [teamId, companyId, estateId, divisiId],
      );
      var data = List<MemberInspectionModel>.from(mapList.map((e) {
        return MemberInspectionModel.fromJson(e);
      }));
      return data;
    } else {
      var mapList = await db.query(
        memberInspectionTable,
        where:
            '${MemberInspectionEntity.mTeamId}=? AND ${MemberInspectionEntity.mCompanyId}=?',
        whereArgs: [teamId, companyId],
      );
      var data = List<MemberInspectionModel>.from(mapList.map((e) {
        return MemberInspectionModel.fromJson(e);
      }));
      return data;
    }
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(memberInspectionTable);
  }
}

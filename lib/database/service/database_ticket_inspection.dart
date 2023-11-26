import 'package:epms/database/entity/ticket_inspection_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseTicketInspection {
  void createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $ticketInspectionTable(
       ${TicketInspectionEntity.id} TEXT,
       ${TicketInspectionEntity.code} TEXT,
       ${TicketInspectionEntity.trTime} TEXT,
       ${TicketInspectionEntity.mCompanyId} TEXT,
       ${TicketInspectionEntity.mCompanyName} TEXT,
       ${TicketInspectionEntity.mCompanyAlias} TEXT,
       ${TicketInspectionEntity.mTeamId} TEXT,
       ${TicketInspectionEntity.mTeamName} TEXT,
       ${TicketInspectionEntity.mDivisionId} TEXT,
       ${TicketInspectionEntity.mDivisionName} TEXT,
       ${TicketInspectionEntity.mDivisionEstateCode} TEXT,
       ${TicketInspectionEntity.gpsLng} REAL,
       ${TicketInspectionEntity.gpsLat} REAL,
       ${TicketInspectionEntity.submittedAt} TEXT,       
       ${TicketInspectionEntity.submittedBy} TEXT,
       ${TicketInspectionEntity.submittedByName} TEXT,
       ${TicketInspectionEntity.assignee} TEXT,
       ${TicketInspectionEntity.assigneeId} TEXT,
       ${TicketInspectionEntity.status} TEXT,
       ${TicketInspectionEntity.description} TEXT,
       ${TicketInspectionEntity.closedAt} TEXT,
       ${TicketInspectionEntity.closedBy} TEXT,
       ${TicketInspectionEntity.closedByName} TEXT,
       ${TicketInspectionEntity.isSynchronize} INTEGER,
       ${TicketInspectionEntity.attachments} TEXT,
       ${TicketInspectionEntity.responses} TEXT)
    ''');
  }

  static Future<void> addAllData(List<TicketInspectionModel> data) async {
    Database db = await DatabaseHelper().database;

    var mapList = await db.query(ticketInspectionTable);
    var dataFromLocal = List<TicketInspectionModel>.from(mapList.map((e) {
      return TicketInspectionModel.fromDatabase(e);
    }));
    List dataFromLocalCode = dataFromLocal.map((e) => e.code).toList();

    for (var i = 0; i < data.length; i++) {
      if (!dataFromLocalCode.contains(data[i].code)) {
        await db.insert(ticketInspectionTable, data[i].toDatabase());
      } else {
        final dataFromLocalIndex = dataFromLocalCode.indexOf(data[i].code);
        final dataFromLocalItem = dataFromLocal[dataFromLocalIndex];
        await db.update(
          ticketInspectionTable,
          dataFromLocalItem.toDatabase(),
          where: '${TicketInspectionEntity.code}=?',
          whereArgs: [dataFromLocalItem.code],
        );
      }
    }
  }

  static Future<void> insertData(TicketInspectionModel data) async {
    Database db = await DatabaseHelper().database;
    await db.insert(ticketInspectionTable, data.toDatabase());
  }

  static Future<void> updateData(TicketInspectionModel data) async {
    Database db = await DatabaseHelper().database;
    await db.update(ticketInspectionTable, data.toDatabase(),
        where: '${TicketInspectionEntity.code}=?', whereArgs: [data.code]);
  }

  static Future<List<TicketInspectionModel>> selectData() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(ticketInspectionTable);
    var data = List<TicketInspectionModel>.from(mapList.map((e) {
      return TicketInspectionModel.fromDatabase(e);
    }));
    return data;
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(ticketInspectionTable);
  }
}

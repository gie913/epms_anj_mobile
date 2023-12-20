import 'package:epms/database/entity/subordinate_inspection_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseSubordinateInspection {
  void createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $subordinateInspectionTable(
       ${SubordinateInspectionEntity.id} TEXT,
       ${SubordinateInspectionEntity.code} TEXT,
       ${SubordinateInspectionEntity.trTime} TEXT,
       ${SubordinateInspectionEntity.mCompanyId} TEXT,
       ${SubordinateInspectionEntity.mCompanyName} TEXT,
       ${SubordinateInspectionEntity.mCompanyAlias} TEXT,
       ${SubordinateInspectionEntity.mTeamId} TEXT,
       ${SubordinateInspectionEntity.mTeamName} TEXT,
       ${SubordinateInspectionEntity.mDivisionId} TEXT,
       ${SubordinateInspectionEntity.mDivisionName} TEXT,
       ${SubordinateInspectionEntity.mDivisionEstateCode} TEXT,
       ${SubordinateInspectionEntity.gpsLng} REAL,
       ${SubordinateInspectionEntity.gpsLat} REAL,
       ${SubordinateInspectionEntity.submittedAt} TEXT,       
       ${SubordinateInspectionEntity.submittedBy} TEXT,
       ${SubordinateInspectionEntity.submittedByName} TEXT,
       ${SubordinateInspectionEntity.assignee} TEXT,
       ${SubordinateInspectionEntity.assigneeId} TEXT,
       ${SubordinateInspectionEntity.status} TEXT,
       ${SubordinateInspectionEntity.description} TEXT,
       ${SubordinateInspectionEntity.closedAt} TEXT,
       ${SubordinateInspectionEntity.closedBy} TEXT,
       ${SubordinateInspectionEntity.closedByName} TEXT,
       ${SubordinateInspectionEntity.isSynchronize} INTEGER,
       ${SubordinateInspectionEntity.isClosed} INTEGER,
       ${SubordinateInspectionEntity.attachments} TEXT,
       ${SubordinateInspectionEntity.responses} TEXT)
    ''');
  }

  static Future<void> addAllData(List<TicketInspectionModel> data) async {
    Database db = await DatabaseHelper().database;

    // await db.delete(subordinateInspectionTable);

    // final batch = db.batch();
    // for (final item in data) {
    //   batch.insert(subordinateInspectionTable, item.toDatabase());
    // }
    // await batch.commit();

    var mapList = await db.query(subordinateInspectionTable);
    var dataFromLocal = List<TicketInspectionModel>.from(mapList.map((e) {
      return TicketInspectionModel.fromDatabase(e);
    }));
    List dataFromLocalCode = dataFromLocal.map((e) => e.code).toList();

    for (var i = 0; i < data.length; i++) {
      if (!dataFromLocalCode.contains(data[i].code)) {
        await db.insert(subordinateInspectionTable, data[i].toDatabase());
      } else {
        await db.update(
          subordinateInspectionTable,
          data[i].toDatabase(),
          where: '${SubordinateInspectionEntity.code}=?',
          whereArgs: [data[i].code],
        );
      }
    }
  }

  static Future<List<TicketInspectionModel>> selectData() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(subordinateInspectionTable);
    var data = List<TicketInspectionModel>.from(mapList.map((e) {
      return TicketInspectionModel.fromDatabase(e);
    }));
    data.sort((a, b) =>
        DateTime.parse(b.submittedAt).compareTo(DateTime.parse(a.submittedAt)));
    return data;
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(subordinateInspectionTable);
  }
}

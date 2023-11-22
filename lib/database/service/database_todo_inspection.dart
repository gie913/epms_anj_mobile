import 'package:epms/database/entity/todo_inspection_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';

class DatabaseTodoInspection {
  void createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $todoInspectionTable(
       ${TodoInspectionEntity.id} TEXT,
       ${TodoInspectionEntity.code} TEXT,
       ${TodoInspectionEntity.trTime} TEXT,
       ${TodoInspectionEntity.mCompanyId} TEXT,
       ${TodoInspectionEntity.mCompanyName} TEXT,
       ${TodoInspectionEntity.mCompanyAlias} TEXT,
       ${TodoInspectionEntity.mTeamId} TEXT,
       ${TodoInspectionEntity.mTeamName} TEXT,
       ${TodoInspectionEntity.mDivisionId} TEXT,
       ${TodoInspectionEntity.mDivisionName} TEXT,
       ${TodoInspectionEntity.mDivisionEstateCode} TEXT,
       ${TodoInspectionEntity.gpsLng} REAL,
       ${TodoInspectionEntity.gpsLat} REAL,
       ${TodoInspectionEntity.submittedAt} TEXT,       
       ${TodoInspectionEntity.submittedBy} TEXT,
       ${TodoInspectionEntity.submittedByName} TEXT,
       ${TodoInspectionEntity.assignee} TEXT,
       ${TodoInspectionEntity.assigneeId} TEXT,
       ${TodoInspectionEntity.status} TEXT,
       ${TodoInspectionEntity.description} TEXT,
       ${TodoInspectionEntity.closedAt} TEXT,
       ${TodoInspectionEntity.closedBy} TEXT,
       ${TodoInspectionEntity.closedByName} TEXT,
       ${TodoInspectionEntity.attachments} TEXT,
       ${TodoInspectionEntity.responses} TEXT)
    ''');
  }

  static Future<void> addAllData(List<TicketInspectionModel> data) async {
    Database db = await DatabaseHelper().database;

    final batch = db.batch();

    for (final item in data) {
      batch.insert(todoInspectionTable, item.toDatabase());
    }
    await batch.commit();
  }

  static Future<void> insertData(TicketInspectionModel data) async {
    Database db = await DatabaseHelper().database;
    await db.insert(todoInspectionTable, data.toDatabase());
  }

  static Future<void> updateData(TicketInspectionModel data) async {
    Database db = await DatabaseHelper().database;
    await db.update(todoInspectionTable, data.toDatabase(),
        where: '${TodoInspectionEntity.code}=?', whereArgs: [data.code]);
  }

  static Future<List<TicketInspectionModel>> selectData() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(todoInspectionTable);
    var data = List<TicketInspectionModel>.from(mapList.map((e) {
      return TicketInspectionModel.fromDatabase(e);
    }));
    return data;
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(todoInspectionTable);
  }
}

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
       ${TicketInspectionEntity.date} TEXT,
       ${TicketInspectionEntity.longitude} REAL,
       ${TicketInspectionEntity.latitude} REAL,
       ${TicketInspectionEntity.category} TEXT,
       ${TicketInspectionEntity.company} TEXT,
       ${TicketInspectionEntity.division} TEXT,
       ${TicketInspectionEntity.userAssign} TEXT,
       ${TicketInspectionEntity.status} TEXT,
       ${TicketInspectionEntity.description} TEXT,
       ${TicketInspectionEntity.assignedTo} TEXT,
       ${TicketInspectionEntity.mTeamId} TEXT,
       ${TicketInspectionEntity.mCompanyId} TEXT,
       ${TicketInspectionEntity.mDivisionId} TEXT,       
       ${TicketInspectionEntity.images} TEXT,
       ${TicketInspectionEntity.history} TEXT)
    ''');
  }

  static Future<void> insertData(TicketInspectionModel data) async {
    Database db = await DatabaseHelper().database;
    await db.insert(ticketInspectionTable, data.toDatabase());
  }

  static Future<void> updateData(TicketInspectionModel data) async {
    Database db = await DatabaseHelper().database;
    await db.update(ticketInspectionTable, data.toDatabase(),
        where: '${TicketInspectionEntity.id}=?', whereArgs: [data.id]);
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

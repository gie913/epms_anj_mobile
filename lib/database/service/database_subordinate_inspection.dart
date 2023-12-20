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
       ${SubordinateInspectionEntity.isNewResponse} INTEGER,
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
        final inspectionTemp = TicketInspectionModel(
          assignee: data[i].assignee,
          assigneeId: data[i].assigneeId,
          attachments: data[i].attachments,
          closedAt: data[i].closedAt,
          closedBy: data[i].closedBy,
          closedByName: data[i].closedByName,
          code: data[i].code,
          description: data[i].description,
          gpsLat: data[i].gpsLat,
          gpsLng: data[i].gpsLng,
          id: data[i].id,
          isClosed: data[i].isClosed,
          isNewResponse: 1,
          isSynchronize: data[i].isSynchronize,
          mCompanyAlias: data[i].mCompanyAlias,
          mCompanyId: data[i].mCompanyId,
          mCompanyName: data[i].mCompanyName,
          mDivisionEstateCode: data[i].mDivisionEstateCode,
          mDivisionId: data[i].mDivisionId,
          mDivisionName: data[i].mDivisionName,
          mTeamId: data[i].mTeamId,
          mTeamName: data[i].mTeamName,
          responses: data[i].responses,
          status: data[i].status,
          submittedAt: data[i].submittedAt,
          submittedBy: data[i].submittedBy,
          submittedByName: data[i].submittedByName,
          trTime: data[i].trTime,
        );
        await db.insert(
            subordinateInspectionTable, inspectionTemp.toDatabase());
      } else {
        var indexDataLocal = dataFromLocalCode.indexOf(data[i].code);
        if (dataFromLocal[indexDataLocal].responses.length !=
            data[i].responses.length) {
          final inspectionTemp = TicketInspectionModel(
            assignee: data[i].assignee,
            assigneeId: data[i].assigneeId,
            attachments: data[i].attachments,
            closedAt: data[i].closedAt,
            closedBy: data[i].closedBy,
            closedByName: data[i].closedByName,
            code: data[i].code,
            description: data[i].description,
            gpsLat: data[i].gpsLat,
            gpsLng: data[i].gpsLng,
            id: data[i].id,
            isClosed: data[i].isClosed,
            isNewResponse: 1,
            isSynchronize: data[i].isSynchronize,
            mCompanyAlias: data[i].mCompanyAlias,
            mCompanyId: data[i].mCompanyId,
            mCompanyName: data[i].mCompanyName,
            mDivisionEstateCode: data[i].mDivisionEstateCode,
            mDivisionId: data[i].mDivisionId,
            mDivisionName: data[i].mDivisionName,
            mTeamId: data[i].mTeamId,
            mTeamName: data[i].mTeamName,
            responses: data[i].responses,
            status: data[i].status,
            submittedAt: data[i].submittedAt,
            submittedBy: data[i].submittedBy,
            submittedByName: data[i].submittedByName,
            trTime: data[i].trTime,
          );
          await db.update(
            subordinateInspectionTable,
            inspectionTemp.toDatabase(),
            where: '${SubordinateInspectionEntity.code}=?',
            whereArgs: [data[i].code],
          );
        } else {
          final inspectionTemp = TicketInspectionModel(
            assignee: data[i].assignee,
            assigneeId: data[i].assigneeId,
            attachments: data[i].attachments,
            closedAt: data[i].closedAt,
            closedBy: data[i].closedBy,
            closedByName: data[i].closedByName,
            code: data[i].code,
            description: data[i].description,
            gpsLat: data[i].gpsLat,
            gpsLng: data[i].gpsLng,
            id: data[i].id,
            isClosed: data[i].isClosed,
            isNewResponse: dataFromLocal[indexDataLocal].isNewResponse,
            isSynchronize: data[i].isSynchronize,
            mCompanyAlias: data[i].mCompanyAlias,
            mCompanyId: data[i].mCompanyId,
            mCompanyName: data[i].mCompanyName,
            mDivisionEstateCode: data[i].mDivisionEstateCode,
            mDivisionId: data[i].mDivisionId,
            mDivisionName: data[i].mDivisionName,
            mTeamId: data[i].mTeamId,
            mTeamName: data[i].mTeamName,
            responses: data[i].responses,
            status: data[i].status,
            submittedAt: data[i].submittedAt,
            submittedBy: data[i].submittedBy,
            submittedByName: data[i].submittedByName,
            trTime: data[i].trTime,
          );
          await db.update(
            subordinateInspectionTable,
            inspectionTemp.toDatabase(),
            where: '${SubordinateInspectionEntity.code}=?',
            whereArgs: [data[i].code],
          );
        }
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

  static Future<void> updateData(TicketInspectionModel data) async {
    Database db = await DatabaseHelper().database;
    await db.update(subordinateInspectionTable, data.toDatabase(),
        where: '${SubordinateInspectionEntity.code}=?', whereArgs: [data.code]);
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(subordinateInspectionTable);
  }
}

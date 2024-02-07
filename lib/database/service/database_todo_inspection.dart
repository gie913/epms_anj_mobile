import 'package:epms/database/entity/todo_inspection_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/database/service/database_user_inspection_config.dart';
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
       ${TodoInspectionEntity.isSynchronize} INTEGER,
       ${TodoInspectionEntity.isNewResponse} INTEGER,
       ${TodoInspectionEntity.usingGps} INTEGER,
       ${TodoInspectionEntity.isClosed} INTEGER,
       ${TodoInspectionEntity.attachments} TEXT,
       ${TodoInspectionEntity.responses} TEXT)
    ''');
  }

  static Future<void> addAllData(List<TicketInspectionModel> data) async {
    Database db = await DatabaseHelper().database;

    // await db.delete(todoInspectionTable);

    final batchInspectionNew = db.batch();
    final batchInspectionExisting1 = db.batch();
    final batchInspectionExisting2 = db.batch();
    // for (final item in data) {
    //   batch.insert(todoInspectionTable, item.toDatabase());
    // }
    // await batch.commit();

    var mapList = await db.query(todoInspectionTable);
    var dataFromLocal = List<TicketInspectionModel>.from(mapList.map((e) {
      return TicketInspectionModel.fromDatabase(e);
    }));
    List dataFromLocalCode = dataFromLocal.map((e) => e.code).toList();
    final user = await DatabaseUserInspectionConfig.selectData();

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
          // isNewResponse: 1,
          isNewResponse: data[i].responses.isEmpty
              ? 1
              : (data[i].responses.isNotEmpty &&
                      data[i].responses.last.submittedBy != user.id)
                  ? 1
                  : 0,
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
          usingGps: data[i].usingGps,
        );
        batchInspectionNew.insert(
            todoInspectionTable, inspectionTemp.toDatabase());
        // await db.insert(todoInspectionTable, inspectionTemp.toDatabase());
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
            // isNewResponse: 1,
            isNewResponse: data[i].responses.isNotEmpty &&
                    data[i].responses.last.submittedBy != user.id
                ? 1
                : 0,
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
            usingGps: data[i].usingGps,
          );
          batchInspectionExisting1.update(
            todoInspectionTable,
            inspectionTemp.toDatabase(),
            where:
                '${TodoInspectionEntity.code}=? and ${TodoInspectionEntity.isSynchronize}=?',
            whereArgs: [data[i].code, 1],
          );
          // await db.update(
          //   todoInspectionTable,
          //   inspectionTemp.toDatabase(),
          //   where:
          //       '${TodoInspectionEntity.code}=? and ${TodoInspectionEntity.isSynchronize}=?',
          //   whereArgs: [data[i].code, 1],
          // );
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
            usingGps: data[i].usingGps,
          );
          batchInspectionExisting2.update(
            todoInspectionTable,
            inspectionTemp.toDatabase(),
            where:
                '${TodoInspectionEntity.code}=? and ${TodoInspectionEntity.isSynchronize}=?',
            whereArgs: [data[i].code, 1],
          );
          // await db.update(
          //   todoInspectionTable,
          //   inspectionTemp.toDatabase(),
          //   where:
          //       '${TodoInspectionEntity.code}=? and ${TodoInspectionEntity.isSynchronize}=?',
          //   whereArgs: [data[i].code, 1],
          // );
        }
      }
    }

    await batchInspectionNew.commit();
    await batchInspectionExisting1.commit();
    await batchInspectionExisting2.commit();
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
    data.sort((a, b) =>
        DateTime.parse(b.submittedAt).compareTo(DateTime.parse(a.submittedAt)));
    return data;
  }

  static Future<List<TicketInspectionModel>> selectDataNeedUpload() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(
      todoInspectionTable,
      where: '${TodoInspectionEntity.isSynchronize}=?',
      whereArgs: [0],
    );
    var data = List<TicketInspectionModel>.from(mapList.map((e) {
      return TicketInspectionModel.fromDatabase(e);
    }));
    return data;
  }

  static Future<void> deleteTodoByCode(TicketInspectionModel data) async {
    Database db = await DatabaseHelper().database;
    db.delete(
      todoInspectionTable,
      where: '${TodoInspectionEntity.code}=?',
      whereArgs: [data.code],
    );
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(todoInspectionTable);
  }
}

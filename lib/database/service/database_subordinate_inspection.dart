import 'package:epms/database/entity/subordinate_inspection_entity.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/database/service/database_attachment_inspection.dart';
import 'package:epms/database/service/database_response_inspection.dart';
import 'package:epms/database/service/database_user_inspection_config.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:intl/intl.dart';
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
       ${SubordinateInspectionEntity.usingGps} INTEGER,
       ${SubordinateInspectionEntity.isClosed} INTEGER,
       ${SubordinateInspectionEntity.attachments} TEXT)
    ''');
  }

  static Future<void> addAllDataNew(
      List<TicketInspectionModel> listInspectionData) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(subordinateInspectionTable);
    var dataFromLocal = List<TicketInspectionModel>.from(mapList.map((e) {
      return TicketInspectionModel.fromDatabase(e);
    }));
    List dataFromLocalCode = dataFromLocal.map((e) => e.code).toList();

    final batchNewData = db.batch();
    final batchExistingData = db.batch();

    final user = await DatabaseUserInspectionConfig.selectData();

    await Future.forEach(listInspectionData, (element) async {
      final listNewResponse =
          await DatabaseResponseInspection.selectDataByInspectionId(element.id);

      if (!dataFromLocalCode.contains(element.code)) {
        final ticketInspectionTemp = TicketInspectionModel(
          id: element.id,
          code: element.code,
          trTime: element.trTime,
          mCompanyId: element.mCompanyId,
          mCompanyName: element.mCompanyName,
          mCompanyAlias: element.mCompanyAlias,
          mTeamId: element.mTeamId,
          mTeamName: element.mTeamName,
          mDivisionId: element.mDivisionId,
          mDivisionName: element.mDivisionName,
          mDivisionEstateCode: element.mDivisionEstateCode,
          gpsLat: element.gpsLat,
          gpsLng: element.gpsLng,
          submittedAt: element.submittedAt,
          submittedBy: element.submittedBy,
          submittedByName: element.submittedByName,
          assignee: element.assignee,
          assigneeId: element.assigneeId,
          status: element.status,
          description: element.description,
          closedAt: element.closedAt,
          closedBy: element.closedBy,
          closedByName: element.closedByName,
          isNewResponse: listNewResponse.isNotEmpty &&
                  listNewResponse.last.submittedBy == user.id
              ? 0
              : 1,
          isSynchronize: 1,
          usingGps: element.usingGps,
          isClosed: element.isClosed,
          attachments: element.attachments,
        );
        batchNewData.insert(
          subordinateInspectionTable,
          ticketInspectionTemp.toDatabase(),
        );
      } else {
        final listNewResponse =
            await DatabaseResponseInspection.selectNewResponse(element.id);

        final inspectionLocal =
            dataFromLocal.firstWhere((item) => item.id == element.id);

        final ticketInspectionTemp = TicketInspectionModel(
          id: element.id,
          code: element.code,
          trTime: element.trTime,
          mCompanyId: element.mCompanyId,
          mCompanyName: element.mCompanyName,
          mCompanyAlias: element.mCompanyAlias,
          mTeamId: element.mTeamId,
          mTeamName: element.mTeamName,
          mDivisionId: element.mDivisionId,
          mDivisionName: element.mDivisionName,
          mDivisionEstateCode: element.mDivisionEstateCode,
          gpsLat: element.gpsLat,
          gpsLng: element.gpsLng,
          submittedAt: element.submittedAt,
          submittedBy: element.submittedBy,
          submittedByName: element.submittedByName,
          assignee: element.assignee,
          assigneeId: element.assigneeId,
          status: element.status,
          description: element.description,
          closedAt: element.closedAt,
          closedBy: element.closedBy,
          closedByName: element.closedByName,
          isNewResponse: listNewResponse.isNotEmpty &&
                  listNewResponse.last.submittedBy != user.id
              ? 1
              : inspectionLocal.isNewResponse,
          isSynchronize: inspectionLocal.isSynchronize,
          usingGps: element.usingGps,
          isClosed: element.isClosed,
          attachments: element.attachments,
        );
        batchExistingData.update(
          subordinateInspectionTable,
          ticketInspectionTemp.toDatabase(),
          where: '${SubordinateInspectionEntity.code}=?',
          whereArgs: [ticketInspectionTemp.code],
        );
      }
    });

    await batchNewData.commit();
    await batchExistingData.commit();
  }

  // static Future<void> addAllData(List<TicketInspectionModel> data) async {
  //   Database db = await DatabaseHelper().database;

  //   // await db.delete(subordinateInspectionTable);

  //   final batchInspectionNew = db.batch();
  //   final batchInspectionExisting1 = db.batch();
  //   final batchInspectionExisting2 = db.batch();
  //   // for (final item in data) {
  //   //   batch.insert(subordinateInspectionTable, item.toDatabase());
  //   // }
  //   // await batch.commit();

  //   var mapList = await db.query(subordinateInspectionTable);
  //   var dataFromLocal = List<TicketInspectionModel>.from(mapList.map((e) {
  //     return TicketInspectionModel.fromDatabase(e);
  //   }));
  //   List dataFromLocalCode = dataFromLocal.map((e) => e.code).toList();
  //   final user = await DatabaseUserInspectionConfig.selectData();

  //   for (var i = 0; i < data.length; i++) {
  //     if (!dataFromLocalCode.contains(data[i].code)) {
  //       final inspectionTemp = TicketInspectionModel(
  //         assignee: data[i].assignee,
  //         assigneeId: data[i].assigneeId,
  //         attachments: data[i].attachments,
  //         closedAt: data[i].closedAt,
  //         closedBy: data[i].closedBy,
  //         closedByName: data[i].closedByName,
  //         code: data[i].code,
  //         description: data[i].description,
  //         gpsLat: data[i].gpsLat,
  //         gpsLng: data[i].gpsLng,
  //         id: data[i].id,
  //         isClosed: data[i].isClosed,
  //         // isNewResponse: 1,
  //         // isNewResponse: data[i].responses.isNotEmpty &&
  //         //         data[i].responses.last.submittedBy != user.id
  //         //     ? 1
  //         //     : 0,
  //         isNewResponse:
  //             (data[i].responses.isEmpty && data[i].submittedBy != user.id)
  //                 ? 1
  //                 : (data[i].responses.isNotEmpty &&
  //                         data[i].responses.last.submittedBy != user.id &&
  //                         data[i].responses.last.status == 'Close')
  //                     ? 1
  //                     : (data[i].responses.isNotEmpty &&
  //                             data[i].responses.last.submittedBy == user.id &&
  //                             data[i].responses.last.status == 'Close')
  //                         ? 0
  //                         : (data[i].responses.isNotEmpty &&
  //                                 data[i].responses.last.submittedBy != user.id)
  //                             ? 1
  //                             : 0,
  //         isSynchronize: data[i].isSynchronize,
  //         mCompanyAlias: data[i].mCompanyAlias,
  //         mCompanyId: data[i].mCompanyId,
  //         mCompanyName: data[i].mCompanyName,
  //         mDivisionEstateCode: data[i].mDivisionEstateCode,
  //         mDivisionId: data[i].mDivisionId,
  //         mDivisionName: data[i].mDivisionName,
  //         mTeamId: data[i].mTeamId,
  //         mTeamName: data[i].mTeamName,
  //         responses: data[i].responses,
  //         status: data[i].status,
  //         submittedAt: data[i].submittedAt,
  //         submittedBy: data[i].submittedBy,
  //         submittedByName: data[i].submittedByName,
  //         trTime: data[i].trTime,
  //         usingGps: data[i].usingGps,
  //       );
  //       batchInspectionNew.insert(
  //           subordinateInspectionTable, inspectionTemp.toDatabase());
  //       // await db.insert(
  //       //     subordinateInspectionTable, inspectionTemp.toDatabase());
  //     } else {
  //       var indexDataLocal = dataFromLocalCode.indexOf(data[i].code);
  //       if (dataFromLocal[indexDataLocal].responses.length !=
  //           data[i].responses.length) {
  //         final inspectionTemp = TicketInspectionModel(
  //           assignee: data[i].assignee,
  //           assigneeId: data[i].assigneeId,
  //           attachments: data[i].attachments,
  //           closedAt: data[i].closedAt,
  //           closedBy: data[i].closedBy,
  //           closedByName: data[i].closedByName,
  //           code: data[i].code,
  //           description: data[i].description,
  //           gpsLat: data[i].gpsLat,
  //           gpsLng: data[i].gpsLng,
  //           id: data[i].id,
  //           isClosed: data[i].isClosed,
  //           // isNewResponse: 1,
  //           isNewResponse: data[i].responses.isNotEmpty &&
  //                   data[i].responses.last.submittedBy != user.id
  //               ? 1
  //               : 0,
  //           isSynchronize: data[i].isSynchronize,
  //           mCompanyAlias: data[i].mCompanyAlias,
  //           mCompanyId: data[i].mCompanyId,
  //           mCompanyName: data[i].mCompanyName,
  //           mDivisionEstateCode: data[i].mDivisionEstateCode,
  //           mDivisionId: data[i].mDivisionId,
  //           mDivisionName: data[i].mDivisionName,
  //           mTeamId: data[i].mTeamId,
  //           mTeamName: data[i].mTeamName,
  //           responses: data[i].responses,
  //           status: data[i].status,
  //           submittedAt: data[i].submittedAt,
  //           submittedBy: data[i].submittedBy,
  //           submittedByName: data[i].submittedByName,
  //           trTime: data[i].trTime,
  //           usingGps: data[i].usingGps,
  //         );
  //         batchInspectionExisting1.update(
  //           subordinateInspectionTable,
  //           inspectionTemp.toDatabase(),
  //           where: '${SubordinateInspectionEntity.code}=?',
  //           whereArgs: [data[i].code],
  //         );
  //         // await db.update(
  //         //   subordinateInspectionTable,
  //         //   inspectionTemp.toDatabase(),
  //         //   where: '${SubordinateInspectionEntity.code}=?',
  //         //   whereArgs: [data[i].code],
  //         // );
  //       } else {
  //         final inspectionTemp = TicketInspectionModel(
  //           assignee: data[i].assignee,
  //           assigneeId: data[i].assigneeId,
  //           attachments: data[i].attachments,
  //           closedAt: data[i].closedAt,
  //           closedBy: data[i].closedBy,
  //           closedByName: data[i].closedByName,
  //           code: data[i].code,
  //           description: data[i].description,
  //           gpsLat: data[i].gpsLat,
  //           gpsLng: data[i].gpsLng,
  //           id: data[i].id,
  //           isClosed: data[i].isClosed,
  //           isNewResponse: dataFromLocal[indexDataLocal].isNewResponse,
  //           isSynchronize: data[i].isSynchronize,
  //           mCompanyAlias: data[i].mCompanyAlias,
  //           mCompanyId: data[i].mCompanyId,
  //           mCompanyName: data[i].mCompanyName,
  //           mDivisionEstateCode: data[i].mDivisionEstateCode,
  //           mDivisionId: data[i].mDivisionId,
  //           mDivisionName: data[i].mDivisionName,
  //           mTeamId: data[i].mTeamId,
  //           mTeamName: data[i].mTeamName,
  //           responses: data[i].responses,
  //           status: data[i].status,
  //           submittedAt: data[i].submittedAt,
  //           submittedBy: data[i].submittedBy,
  //           submittedByName: data[i].submittedByName,
  //           trTime: data[i].trTime,
  //           usingGps: data[i].usingGps,
  //         );
  //         batchInspectionExisting2.update(
  //           subordinateInspectionTable,
  //           inspectionTemp.toDatabase(),
  //           where: '${SubordinateInspectionEntity.code}=?',
  //           whereArgs: [data[i].code],
  //         );
  //         // await db.update(
  //         //   subordinateInspectionTable,
  //         //   inspectionTemp.toDatabase(),
  //         //   where: '${SubordinateInspectionEntity.code}=?',
  //         //   whereArgs: [data[i].code],
  //         // );
  //       }
  //     }
  //   }

  //   await batchInspectionNew.commit();
  //   await batchInspectionExisting1.commit();
  //   await batchInspectionExisting2.commit();
  // }

  static Future<List<TicketInspectionModel>> selectData() async {
    Database db = await DatabaseHelper().database;

    final List<TicketInspectionModel> data = [];

    var mapListClosed = await db.query(
      subordinateInspectionTable,
      where: '${SubordinateInspectionEntity.isClosed}=?',
      whereArgs: [1],
    );
    var dataClosed = List<TicketInspectionModel>.from(mapListClosed.map((e) {
      return TicketInspectionModel.fromDatabase(e);
    }));
    dataClosed.sort((a, b) =>
        DateTime.parse(b.submittedAt).compareTo(DateTime.parse(a.submittedAt)));

    var mapListNotClosed = await db.query(
      subordinateInspectionTable,
      where: '${SubordinateInspectionEntity.isClosed}=?',
      whereArgs: [0],
    );
    var dataNotClosed =
        List<TicketInspectionModel>.from(mapListNotClosed.map((e) {
      return TicketInspectionModel.fromDatabase(e);
    }));
    dataNotClosed.sort((a, b) =>
        DateTime.parse(b.submittedAt).compareTo(DateTime.parse(a.submittedAt)));

    data.addAll(dataNotClosed);
    data.addAll(dataClosed);

    return data;
  }

  static Future<void> updateData(TicketInspectionModel data) async {
    Database db = await DatabaseHelper().database;
    await db.update(subordinateInspectionTable, data.toDatabase(),
        where: '${SubordinateInspectionEntity.code}=?', whereArgs: [data.code]);
  }

  static Future<void> updateDataFromListMyInspection(
      TicketInspectionModel data) async {
    Database db = await DatabaseHelper().database;
    final mapList = await db.query(subordinateInspectionTable,
        where: '${SubordinateInspectionEntity.code}=?', whereArgs: [data.code]);
    if (mapList.isNotEmpty) {
      final dataTemp = TicketInspectionModel.fromDatabase(mapList.first);
      final dataTempUpdate = TicketInspectionModel(
        assignee: dataTemp.assignee,
        assigneeId: dataTemp.assigneeId,
        attachments: dataTemp.attachments,
        closedAt: dataTemp.closedAt,
        closedBy: dataTemp.closedBy,
        closedByName: dataTemp.closedByName,
        code: dataTemp.code,
        description: dataTemp.description,
        gpsLat: dataTemp.gpsLat,
        gpsLng: dataTemp.gpsLng,
        id: dataTemp.id,
        isClosed: dataTemp.isClosed,
        isNewResponse: 0,
        isSynchronize: dataTemp.isSynchronize,
        mCompanyAlias: dataTemp.mCompanyAlias,
        mCompanyId: dataTemp.mCompanyId,
        mCompanyName: dataTemp.mCompanyName,
        mDivisionEstateCode: dataTemp.mDivisionEstateCode,
        mDivisionId: dataTemp.mDivisionId,
        mDivisionName: dataTemp.mDivisionName,
        mTeamId: dataTemp.mTeamId,
        mTeamName: dataTemp.mTeamName,
        status: dataTemp.status,
        submittedAt: dataTemp.submittedAt,
        submittedBy: dataTemp.submittedBy,
        submittedByName: dataTemp.submittedByName,
        trTime: dataTemp.trTime,
        usingGps: dataTemp.usingGps,
      );
      await updateData(dataTempUpdate);
    }
  }

  static Future<void> deleteSubordinateOneWeekAgo() async {
    Database db = await DatabaseHelper().database;
    var date = DateTime.now();
    var newDate = new DateTime(date.year, date.month, date.day - 7);
    String oneWeekAgoDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(newDate);

    var mapList = await db.query(
      subordinateInspectionTable,
      where:
          "${SubordinateInspectionEntity.trTime}<=? AND ${SubordinateInspectionEntity.status}=? AND ${SubordinateInspectionEntity.isSynchronize}=?",
      whereArgs: ['$oneWeekAgoDate%', 'close', 1],
    );
    var listInspection = List<TicketInspectionModel>.from(mapList.map((e) {
      return TicketInspectionModel.fromDatabase(e);
    }));

    await Future.forEach(listInspection, (inspection) async {
      await DatabaseAttachmentInspection.deleteDataByCode(inspection.code);
      final listResponses =
          await DatabaseResponseInspection.selectDataByInspectionId(
        inspection.id,
      );

      await Future.forEach(listResponses, (response) async {
        await DatabaseAttachmentInspection.deleteDataByCode(response.code);
      });
    });

    await db.rawDelete(
      'DELETE FROM $subordinateInspectionTable WHERE ${SubordinateInspectionEntity.trTime} <= ? AND ${SubordinateInspectionEntity.status} = ? AND ${SubordinateInspectionEntity.isSynchronize} = ?',
      ['$oneWeekAgoDate%', 'close', 1],
    );
  }

  static Future<void> deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(subordinateInspectionTable);
  }
}

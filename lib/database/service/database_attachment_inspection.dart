import 'dart:developer';

import 'package:epms/database/entity/attachment_inspection_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/attachment_inspection_model.dart';
import 'package:epms/model/history_inspection_model.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/screen/inspection/inspection_repository.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseAttachmentInspection {
  void createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $attachmentInspectionTable(
       ${AttachmentInspectionEntity.id} TEXT,
       ${AttachmentInspectionEntity.code} TEXT,
       ${AttachmentInspectionEntity.image} TEXT,
       ${AttachmentInspectionEntity.imageUrl} TEXT)
    ''');
  }

  static Future<void> addAllDataNew(List<TicketInspectionModel> data) async {
    for (final inspection in data) {
      await insertInspection(inspection);
    }
  }

  static Future<void> insertInspection(TicketInspectionModel data) async {
    Database db = await DatabaseHelper().database;

    final batchAttachmentInspection = db.batch();
    final batchAttachmentResponse = db.batch();

    for (final attachment in data.attachments) {
      var mapList = await db.query(attachmentInspectionTable);
      var dataFromLocal = List<AttachmentInspectionModel>.from(mapList.map((e) {
        return AttachmentInspectionModel.fromJson(e);
      }));
      List dataFromLocalCode = dataFromLocal.map((e) => e.code).toList();

      final indexAttachment = data.attachments.indexOf(attachment);
      final code = '${data.code}$indexAttachment';

      if (!dataFromLocalCode.contains(code)) {
        log('insert baru');
        final image = await InspectionRepository().saveFoto(attachment);
        if (image.isNotEmpty) {
          final attachmentModel = AttachmentInspectionModel(
            id: data.code,
            code: code,
            image: image,
            imageUrl: attachment,
          );

          batchAttachmentInspection.insert(
              attachmentInspectionTable, attachmentModel.toJson());
          // await db.insert(attachmentInspectionTable, attachmentModel.toJson());
        }
      }
    }

    for (final response in data.responses) {
      for (final attachment in response.attachments) {
        var mapList = await db.query(attachmentInspectionTable);
        var dataFromLocal =
            List<AttachmentInspectionModel>.from(mapList.map((e) {
          return AttachmentInspectionModel.fromJson(e);
        }));
        List dataFromLocalCode = dataFromLocal.map((e) => e.code).toList();

        final indexAttachment = response.attachments.indexOf(attachment);
        final code = '${response.code}$indexAttachment';

        if (!dataFromLocalCode.contains(code)) {
          log('insert baru');
          final image = await InspectionRepository().saveFoto(attachment);
          if (image.isNotEmpty) {
            final attachmentModel = AttachmentInspectionModel(
              id: response.code,
              code: code,
              image: image,
              imageUrl: attachment,
            );

            batchAttachmentResponse.insert(
                attachmentInspectionTable, attachmentModel.toJson());
            // await db.insert(attachmentInspectionTable, attachmentModel.toJson());
          }
        }
      }
    }

    await batchAttachmentInspection.commit();
    await batchAttachmentResponse.commit();
  }

  static Future<void> insertResponse(HistoryInspectionModel data) async {
    Database db = await DatabaseHelper().database;

    for (final attachment in data.attachments) {
      log('insert baru');
      final image = await InspectionRepository().saveFoto(attachment);
      final indexAttachment = data.attachments.indexOf(attachment);
      final code = '${data.code}$indexAttachment';

      if (image.isNotEmpty) {
        final attachmentModel = AttachmentInspectionModel(
          id: data.code,
          code: code,
          image: image,
          imageUrl: attachment,
        );

        await db.insert(attachmentInspectionTable, attachmentModel.toJson());
      }
    }
  }

  static Future<AttachmentInspectionModel> selectData(String code) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(
      attachmentInspectionTable,
      where: '${AttachmentInspectionEntity.code}=?',
      whereArgs: [code],
    );

    AttachmentInspectionModel data =
        AttachmentInspectionModel.fromJson(mapList.first);

    return data;
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(attachmentInspectionTable);
  }
}

import 'dart:developer';

import 'package:epms/database/entity/attachment_inspection_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/attachment_inspection_model.dart';
import 'package:epms/model/response_inspection_model.dart';
import 'package:epms/model/ticket_inspection_data_model.dart';
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

  static Future<void> addAllData(TicketInspectionDataModel data) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(attachmentInspectionTable);
    var dataFromLocal = List<AttachmentInspectionModel>.from(mapList.map((e) {
      return AttachmentInspectionModel.fromJson(e);
    }));
    List dataFromLocalCode = dataFromLocal.map((e) => e.code).toList();

    final batchNewData = db.batch();

    await Future.forEach(data.inspection, (inspection) async {
      await Future.forEach(inspection.attachments, (attachment) async {
        final indexAttachment = inspection.attachments.indexOf(attachment);
        final code = '${inspection.code}$indexAttachment';

        if (!dataFromLocalCode.contains(code)) {
          log('insert inspection attachment baru');
          final image = await InspectionRepository().saveFoto(attachment);
          if (image.isNotEmpty) {
            final attachmentModel = AttachmentInspectionModel(
              id: inspection.code,
              code: code,
              image: image,
              imageUrl: attachment,
            );

            batchNewData.insert(
                attachmentInspectionTable, attachmentModel.toJson());
          }
        }
      });
    });

    await Future.forEach(data.responses, (response) async {
      await Future.forEach(response.attachments, (attachment) async {
        final indexAttachment = response.attachments.indexOf(attachment);
        final code = '${response.code}$indexAttachment';

        if (!dataFromLocalCode.contains(code)) {
          log('insert response attachment baru');
          final image = await InspectionRepository().saveFoto(attachment);
          if (image.isNotEmpty) {
            final attachmentModel = AttachmentInspectionModel(
              id: response.code,
              code: code,
              image: image,
              imageUrl: attachment,
            );

            batchNewData.insert(
                attachmentInspectionTable, attachmentModel.toJson());
          }
        }
      });
    });

    await batchNewData.commit();
  }

  static Future<void> insertResponse(ResponseInspectionModel response) async {
    Database db = await DatabaseHelper().database;

    final batchNewData = db.batch();

    await Future.forEach(response.attachments, (attachment) async {
      final indexAttachment = response.attachments.indexOf(attachment);
      final code = '${response.code}$indexAttachment';

      log('insert response attachment baru');
      final image = await InspectionRepository().saveFoto(attachment);
      if (image.isNotEmpty) {
        final attachmentModel = AttachmentInspectionModel(
          id: response.code,
          code: code,
          image: image,
          imageUrl: attachment,
        );

        batchNewData.insert(
            attachmentInspectionTable, attachmentModel.toJson());
      }
    });

    await batchNewData.commit();
  }

  // static Future<void> addAllDataNew(List<TicketInspectionModel> data) async {
  //   for (final inspection in data) {
  //     await insertInspection(inspection);
  //   }
  // }

  static Future<void> insertInspection(TicketInspectionModel inspection) async {
    Database db = await DatabaseHelper().database;

    final batchNewData = db.batch();

    await Future.forEach(inspection.attachments, (attachment) async {
      final indexAttachment = inspection.attachments.indexOf(attachment);
      final code = '${inspection.code}$indexAttachment';

      log('insert inspection attachment baru');
      final image = await InspectionRepository().saveFoto(attachment);
      if (image.isNotEmpty) {
        final attachmentModel = AttachmentInspectionModel(
          id: inspection.code,
          code: code,
          image: image,
          imageUrl: attachment,
        );

        batchNewData.insert(
            attachmentInspectionTable, attachmentModel.toJson());
      }
    });

    await batchNewData.commit();
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

  static Future<List<AttachmentInspectionModel>> selectDataByCode(
    String code,
  ) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(
      attachmentInspectionTable,
      where: '${AttachmentInspectionEntity.id}=?',
      whereArgs: [code],
    );
    var data = List<AttachmentInspectionModel>.from(mapList.map((e) {
      return AttachmentInspectionModel.fromJson(e);
    }));

    return data;
  }

  static Future<void> deleteDataByCode(String code) async {
    Database db = await DatabaseHelper().database;
    await db.delete(
      attachmentInspectionTable,
      where: '${AttachmentInspectionEntity.id}=?',
      whereArgs: [code],
    );
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(attachmentInspectionTable);
  }
}

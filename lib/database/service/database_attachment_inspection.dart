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

  // static Future<void> addAllData(List<TicketInspectionModel> data) async {
  //   Database db = await DatabaseHelper().database;

  //   var mapList = await db.query(attachmentInspectionTable);
  //   var dataFromLocal = List<AttachmentInspectionModel>.from(mapList.map((e) {
  //     return AttachmentInspectionModel.fromJson(e);
  //   }));
  //   List dataFromLocalCode = dataFromLocal.map((e) => e.code).toList();

  //   for (var i = 0; i < data.length; i++) {
  //     final inspectionItem = data[i];

  //     for (var j = 0; j < inspectionItem.attachments.length; j++) {
  //       final attachmentItem = inspectionItem.attachments[j];

  //       if (!dataFromLocalCode.contains(inspectionItem.code)) {
  //         final image = await InspectionRepository().saveFoto(attachmentItem);

  //         if (image.isNotEmpty) {
  //           final attachmentModel = AttachmentInspectionModel(
  //             code: inspectionItem.code,
  //             image: image,
  //             imageUrl: inspectionItem.attachments[j],
  //           );
  //           await db.insert(
  //               attachmentInspectionTable, attachmentModel.toJson());
  //         }
  //       }
  //       // else {
  //       //   await db.update(
  //       //     attachmentInspectionTable,
  //       //     attachmentModel.toJson(),
  //       //     where: '${AttachmentInspectionEntity.code}=?',
  //       //     whereArgs: [inspectionItem.code],
  //       //   );
  //       // }
  //     }

  //     if (inspectionItem.responses.isNotEmpty) {
  //       for (var a = 0; a < inspectionItem.responses.length; a++) {
  //         final responseItem = inspectionItem.responses[a];

  //         if (responseItem.attachments.isNotEmpty) {
  //           for (var b = 0; b < responseItem.attachments.length; b++) {
  //             final attachmentItem = responseItem.attachments[b];

  //             if (!dataFromLocalCode.contains(responseItem.code)) {
  //               final image =
  //                   await InspectionRepository().saveFoto(attachmentItem);

  //               if (image.isNotEmpty) {
  //                 final attachmentModel = AttachmentInspectionModel(
  //                   code: responseItem.code,
  //                   image: image,
  //                   imageUrl: attachmentItem,
  //                 );
  //                 await db.insert(
  //                     attachmentInspectionTable, attachmentModel.toJson());
  //               }
  //             }
  //             // else {
  //             //   await db.update(
  //             //     attachmentInspectionTable,
  //             //     attachmentModel.toJson(),
  //             //     where: '${AttachmentInspectionEntity.code}=?',
  //             //     whereArgs: [responseItem.code],
  //             //   );
  //             // }
  //           }
  //         }
  //       }
  //     }
  //   }
  // }

  static Future<void> addAllDataNew(List<TicketInspectionModel> data) async {
    Database db = await DatabaseHelper().database;

    var mapList = await db.query(attachmentInspectionTable);
    var dataFromLocal = List<AttachmentInspectionModel>.from(mapList.map((e) {
      return AttachmentInspectionModel.fromJson(e);
    }));
    List dataFromLocalCode = dataFromLocal.map((e) => e.id).toList();
    // log('dataFromLocalCode : $dataFromLocalCode');

    for (final inspection in data) {
      // log('item code : ${inspection.code}');
      if (!dataFromLocalCode.contains(inspection.code)) {
        log('insert attachment');
        await insertInspection(inspection);
      } else {
        log('update attachment');
        await updateInspection(inspection);
      }
    }
  }

  static Future<void> insertInspection(TicketInspectionModel data) async {
    Database db = await DatabaseHelper().database;

    final batchAttachmentInspection = db.batch();
    final batchAttachmentResponse = db.batch();

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

        batchAttachmentInspection.insert(
            attachmentInspectionTable, attachmentModel.toJson());
        // await db.insert(attachmentInspectionTable, attachmentModel.toJson());
      }
    }

    for (final response in data.responses) {
      for (final attachment in response.attachments) {
        log('insert baru');
        final image = await InspectionRepository().saveFoto(attachment);
        final indexAttachment = response.attachments.indexOf(attachment);
        final code = '${response.code}$indexAttachment';

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

  static Future<void> updateInspection(TicketInspectionModel data) async {
    Database db = await DatabaseHelper().database;

    var mapList = await db.query(attachmentInspectionTable);
    var dataFromLocal = List<AttachmentInspectionModel>.from(mapList.map((e) {
      return AttachmentInspectionModel.fromJson(e);
    }));
    List dataFromLocalCode = dataFromLocal.map((e) => e.code).toList();

    final batchAttachmentInspection = db.batch();
    final batchAttachmentResponse = db.batch();

    for (final attachment in data.attachments) {
      final indexAttachment = data.attachments.indexOf(attachment);
      final code = '${data.code}$indexAttachment';

      if (!dataFromLocalCode.contains(code)) {
        log('update existing');
        final image = await InspectionRepository().saveFoto(attachment);

        if (image.isNotEmpty) {
          final attachmentModel = AttachmentInspectionModel(
            id: data.code,
            code: code,
            image: image,
            imageUrl: attachment,
          );

          batchAttachmentInspection.update(
            attachmentInspectionTable,
            attachmentModel.toJson(),
            where: '${AttachmentInspectionEntity.code}=?',
            whereArgs: [code],
          );
          // await db.update(
          //   attachmentInspectionTable,
          //   attachmentModel.toJson(),
          //   where: '${AttachmentInspectionEntity.code}=?',
          //   whereArgs: [code],
          // );
        }
      }
    }

    for (final response in data.responses) {
      for (final attachment in response.attachments) {
        final indexAttachment = response.attachments.indexOf(attachment);
        final code = '${response.code}$indexAttachment';

        if (!dataFromLocalCode.contains(code)) {
          log('update existing');
          final image = await InspectionRepository().saveFoto(attachment);

          if (image.isNotEmpty) {
            final attachmentModel = AttachmentInspectionModel(
              id: response.code,
              code: code,
              image: image,
              imageUrl: attachment,
            );

            batchAttachmentResponse.update(
              attachmentInspectionTable,
              attachmentModel.toJson(),
              where: '${AttachmentInspectionEntity.code}=?',
              whereArgs: [code],
            );
            // await db.update(
            //   attachmentInspectionTable,
            //   attachmentModel.toJson(),
            //   where: '${AttachmentInspectionEntity.code}=?',
            //   whereArgs: [code],
            // );
          }
        }
      }
    }
  }

  static Future<void> deleteInspectionByCode(TicketInspectionModel data) async {
    Database db = await DatabaseHelper().database;

    await db.delete(
      attachmentInspectionTable,
      where: '${AttachmentInspectionEntity.code}=?',
      whereArgs: [data.code],
    );

    for (final response in data.responses) {
      await db.delete(attachmentInspectionTable,
          where: '${AttachmentInspectionEntity.code}=?',
          whereArgs: [response.code]);
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

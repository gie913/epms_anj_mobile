import 'package:epms/database/entity/response_inspection_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/response_inspection_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseResponseInspection {
  void createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $responseInspectionTable(
       ${ResponseInspectionEntity.tInspectionId} TEXT,
       ${ResponseInspectionEntity.id} TEXT,
       ${ResponseInspectionEntity.code} TEXT,
       ${ResponseInspectionEntity.trTime} TEXT,
       ${ResponseInspectionEntity.submittedAt} TEXT,
       ${ResponseInspectionEntity.submittedBy} TEXT,
       ${ResponseInspectionEntity.submittedByName} TEXT,
       ${ResponseInspectionEntity.reassignedTo} TEXT,
       ${ResponseInspectionEntity.reassignedToName} TEXT,
       ${ResponseInspectionEntity.consultedWith} TEXT,
       ${ResponseInspectionEntity.consultedWithName} TEXT,
       ${ResponseInspectionEntity.description} TEXT,
       ${ResponseInspectionEntity.gpsLng} REAL,
       ${ResponseInspectionEntity.gpsLat} REAL,
       ${ResponseInspectionEntity.status} TEXT,
       ${ResponseInspectionEntity.isSynchronize} INTEGER,
       ${ResponseInspectionEntity.isNewResponse} INTEGER,       
       ${ResponseInspectionEntity.attachments} TEXT)
    ''');
  }

  static Future<void> addAllData(
      List<ResponseInspectionModel> listResponseData) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(responseInspectionTable);
    var dataFromLocal = List<ResponseInspectionModel>.from(mapList.map((e) {
      return ResponseInspectionModel.fromDatabase(e);
    }));
    List dataFromLocalCode = dataFromLocal.map((e) => e.code).toList();

    final batchNewData = db.batch();

    await Future.forEach(listResponseData, (response) async {
      if (!dataFromLocalCode.contains(response.code)) {
        final responseInspectionTemp = ResponseInspectionModel(
          tInspectionId: response.tInspectionId,
          id: response.id,
          code: response.code,
          trTime: response.trTime,
          submittedAt: response.submittedAt,
          submittedBy: response.submittedBy,
          submittedByName: response.submittedByName,
          reassignedTo: response.reassignedTo,
          reassignedToName: response.reassignedToName,
          consultedWith: response.consultedWith,
          consultedWithName: response.consultedWithName,
          description: response.description,
          gpsLat: response.gpsLat,
          gpsLng: response.gpsLng,
          status: response.status,
          attachments: response.attachments,
          isNewResponse: 1,
          isSynchronize: 1,
        );
        batchNewData.insert(
          responseInspectionTable,
          responseInspectionTemp.toDatabase(),
        );
      }
    });

    await batchNewData.commit();
  }

  static Future<void> insertData(ResponseInspectionModel data) async {
    Database db = await DatabaseHelper().database;
    await db.insert(responseInspectionTable, data.toDatabase());
  }

  static Future<void> updateResponseInspection(String inspectionId) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(
      responseInspectionTable,
      where: '${ResponseInspectionEntity.tInspectionId}=?',
      whereArgs: [inspectionId],
    );
    var listResponseData = List<ResponseInspectionModel>.from(mapList.map((e) {
      return ResponseInspectionModel.fromDatabase(e);
    }));

    final batchExistingData = db.batch();

    await Future.forEach(listResponseData, (element) async {
      final responseInspectionTemp = ResponseInspectionModel(
        tInspectionId: element.tInspectionId,
        id: element.id,
        code: element.code,
        trTime: element.trTime,
        submittedAt: element.submittedAt,
        submittedBy: element.submittedBy,
        submittedByName: element.submittedByName,
        reassignedTo: element.reassignedTo,
        reassignedToName: element.reassignedToName,
        consultedWith: element.consultedWith,
        consultedWithName: element.consultedWithName,
        description: element.description,
        gpsLat: element.gpsLat,
        gpsLng: element.gpsLng,
        status: element.status,
        attachments: element.attachments,
        isNewResponse: 0,
        isSynchronize: element.isSynchronize,
      );

      batchExistingData.update(
        responseInspectionTable,
        responseInspectionTemp.toDatabase(),
        where: '${ResponseInspectionEntity.code}=?',
        whereArgs: [responseInspectionTemp.code],
      );
    });

    await batchExistingData.commit();
  }

  static Future<List<ResponseInspectionModel>> selectDataByInspectionId(
    String inspectionId,
  ) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(
      responseInspectionTable,
      where: '${ResponseInspectionEntity.tInspectionId}=?',
      whereArgs: [inspectionId],
    );
    var data = List<ResponseInspectionModel>.from(mapList.map((e) {
      return ResponseInspectionModel.fromDatabase(e);
    }));

    return data;
  }

  static Future<List<ResponseInspectionModel>> selectNewResponse(
    String inspectionId,
  ) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(
      responseInspectionTable,
      where:
          '${ResponseInspectionEntity.tInspectionId}=? and ${ResponseInspectionEntity.isNewResponse}=? and ${ResponseInspectionEntity.isSynchronize}=?',
      whereArgs: [inspectionId, 1, 1],
    );
    var data = List<ResponseInspectionModel>.from(mapList.map((e) {
      return ResponseInspectionModel.fromDatabase(e);
    }));
    return data;
  }

  static Future<List<ResponseInspectionModel>>
      selectResponseNeedUpload() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(
      responseInspectionTable,
      where:
          '${ResponseInspectionEntity.isNewResponse}=? and ${ResponseInspectionEntity.isSynchronize}=?',
      whereArgs: [1, 1],
    );
    var data = List<ResponseInspectionModel>.from(mapList.map((e) {
      return ResponseInspectionModel.fromDatabase(e);
    }));
    return data;
  }

  static Future<void> deleteResponseByCode(String code) async {
    Database db = await DatabaseHelper().database;
    db.delete(
      responseInspectionTable,
      where: '${ResponseInspectionEntity.code}=?',
      whereArgs: [code],
    );
  }

  static void deleteTable() async {
    Database db = await DatabaseHelper().database;
    db.delete(responseInspectionTable);
  }
}

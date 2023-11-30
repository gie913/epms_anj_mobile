import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:epms/base/api/api_configuration.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/model/history_inspection_model.dart';
import 'package:epms/model/my_inspection_response.dart';
import 'package:epms/model/my_subordinate_response.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/model/todo_inspection_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

class InspectionRepository extends APIConfiguration {
  Future<void> getMyInspection(
    BuildContext context,
    Function(BuildContext context, List<TicketInspectionModel> data) onSuccess,
    Function(BuildContext context, String errorMessage) onError,
  ) async {
    String inspectionToken = await StorageManager.readData("inspectionToken");
    log('cek ticketInspectionToken : $inspectionToken');

    try {
      var headers = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $inspectionToken'
      };

      var urlMyInspection =
          'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/inspection/myinspection';
      var responseMyInspection =
          await ioClient!.get(Uri.parse(urlMyInspection), headers: headers);
      log('cek url : $urlMyInspection');
      MyInspectionResponse res =
          MyInspectionResponse.fromJson(jsonDecode(responseMyInspection.body));
      log('cek response get my inspection : ${res.data}');

      if (res.success) {
        onSuccess(context, res.data);
      } else {
        onError(context, res.message);
      }
    } on SocketException {
      log('cek error get my inspection : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on HttpException {
      log('cek error get my inspection : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on FormatException {
      log('cek error get my inspection : Response Format Gagal');
      onError(context, 'Response Format Gagal');
    } catch (exception) {
      log('cek error get my inspection : $exception');
      onError(context, exception.toString());
      rethrow;
    }
  }

  Future<void> getToDoInspection(
    BuildContext context,
    Function(BuildContext context, List<TicketInspectionModel> data) onSuccess,
    Function(BuildContext context, String errorMessage) onError,
  ) async {
    String inspectionToken = await StorageManager.readData("inspectionToken");
    log('cek TodoInspectionToken : $inspectionToken');

    try {
      var headers = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $inspectionToken'
      };

      var urlToDoInspection =
          'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/inspection/myduty';
      var responseToDoInspection =
          await ioClient!.get(Uri.parse(urlToDoInspection), headers: headers);
      log('cek url : $urlToDoInspection');

      TodoInspectionResponse res = TodoInspectionResponse.fromJson(
          jsonDecode(responseToDoInspection.body));
      log('cek response todo inspection : ${res.data}');

      List<TicketInspectionModel> listTodoInspection = [];

      for (var item in res.data.notYet) {
        final todoInspection = TicketInspectionModel(
          id: item.id,
          code: item.code,
          trTime: item.trTime,
          mCompanyId: item.mCompanyId,
          mCompanyName: item.mCompanyName,
          mCompanyAlias: item.mCompanyAlias,
          mTeamId: item.mTeamId,
          mTeamName: item.mTeamName,
          mDivisionId: item.mDivisionId,
          mDivisionName: item.mDivisionName,
          mDivisionEstateCode: item.mDivisionEstateCode,
          gpsLng: item.gpsLng,
          gpsLat: item.gpsLat,
          submittedAt: item.submittedAt,
          submittedBy: item.submittedBy,
          submittedByName: item.submittedByName,
          assignee: item.assignee,
          assigneeId: item.assigneeId,
          status: item.status,
          statusCategory: 'not_yet',
          description: item.description,
          closedAt: item.closedAt,
          closedBy: item.closedBy,
          closedByName: item.closedByName,
          isSynchronize: item.isSynchronize,
          attachments: item.attachments,
          responses: item.responses,
        );
        listTodoInspection.add(todoInspection);
      }

      // for (var item in res.data.done) {
      //   final todoInspection = TicketInspectionModel(
      //     id: item.id,
      //     code: item.code,
      //     trTime: item.trTime,
      //     mCompanyId: item.mCompanyId,
      //     mCompanyName: item.mCompanyName,
      //     mCompanyAlias: item.mCompanyAlias,
      //     mTeamId: item.mTeamId,
      //     mTeamName: item.mTeamName,
      //     mDivisionId: item.mDivisionId,
      //     mDivisionName: item.mDivisionName,
      //     mDivisionEstateCode: item.mDivisionEstateCode,
      //     gpsLng: item.gpsLng,
      //     gpsLat: item.gpsLat,
      //     submittedAt: item.submittedAt,
      //     submittedBy: item.submittedBy,
      //     submittedByName: item.submittedByName,
      //     assignee: item.assignee,
      //     assigneeId: item.assigneeId,
      //     status: item.status,
      //     statusCategory: 'done',
      //     description: item.description,
      //     closedAt: item.closedAt,
      //     closedBy: item.closedBy,
      //     closedByName: item.closedByName,
      //     isSynchronize: item.isSynchronize,
      //     attachments: item.attachments,
      //     responses: item.responses,
      //   );
      //   listTodoInspection.add(todoInspection);
      // }

      if (res.success) {
        onSuccess(context, listTodoInspection);
      } else {
        onError(context, res.message);
      }
    } on SocketException {
      log('cek error get todo inspection : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on HttpException {
      log('cek error get todo inspection : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on FormatException {
      log('cek error get todo inspection : Response Format Gagal');
      onError(context, 'Response Format Gagal');
    } catch (exception) {
      log('cek error get todo inspection : $exception');
      onError(context, exception.toString());
      rethrow;
    }
  }

  Future<void> getMySubordinate(
    BuildContext context,
    Function(BuildContext context, List<TicketInspectionModel> data) onSuccess,
    Function(BuildContext context, String errorMessage) onError,
  ) async {
    String inspectionToken = await StorageManager.readData("inspectionToken");
    log('cek mySubordinateInspectionToken : $inspectionToken');

    try {
      var headers = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $inspectionToken'
      };

      var urlMySubordinate =
          'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/inspection/mysubordinate';
      var responseMySubordinate =
          await ioClient!.get(Uri.parse(urlMySubordinate), headers: headers);
      log('cek url : $urlMySubordinate');
      MySubordinateResponse res = MySubordinateResponse.fromJson(
          jsonDecode(responseMySubordinate.body));
      log('cek response get my subordinate : ${res.data}');

      if (res.success) {
        onSuccess(context, res.data);
      } else {
        onError(context, res.message);
      }
    } on SocketException {
      log('cek error get my subordinate : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on HttpException {
      log('cek error get my subordinate : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on FormatException {
      log('cek error get my subordinate : Response Format Gagal');
      onError(context, 'Response Format Gagal');
    } catch (exception) {
      log('cek error get my subordinate : $exception');
      onError(context, exception.toString());
      rethrow;
    }
  }

  Future<void> createInspection(
    BuildContext context,
    TicketInspectionModel ticketInspection,
    Function(BuildContext context, dynamic successMessage) onSuccess,
    Function(BuildContext context, String errorMessage) onError,
  ) async {
    String inspectionToken = await StorageManager.readData("inspectionToken");
    log('cek CreateInspectionToken : $inspectionToken');

    var headers = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Authorization': 'Bearer $inspectionToken'
    };

    try {
      var url =
          'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/inspection/create';
      var request = http.MultipartRequest("POST", Uri.parse(url));
      for (final image in ticketInspection.attachments) {
        if (image.toString().contains('http')) {
          var response = await http.get(Uri.parse(image));
          List imageName = image.toString().split('/');
          var multipartFile = http.MultipartFile.fromBytes(
            'file[]',
            response.bodyBytes,
            filename: imageName.last,
            contentType: MediaType.parse('image/jpeg'),
          );
          request.files.add(multipartFile);
        } else if (image.toString().isNotEmpty) {
          File imageFile = File(image);
          var stream = http.ByteStream(imageFile.openRead());
          var length = await imageFile.length();

          var mimeContent = lookupMimeType(
              '${imageFile.path.toString().substring(imageFile.path.toString().length - 20)}');
          var typeMedia =
              mimeContent!.substring(0, mimeContent.indexOf('/', 0));

          var pos = mimeContent.indexOf('/', 0);
          var subTypeMedia = mimeContent.substring(pos + 1, mimeContent.length);
          var multipartFile = http.MultipartFile(
            'file[]',
            stream,
            length,
            filename: basename(imageFile.path),
            contentType: MediaType(typeMedia, subTypeMedia),
          );
          request.files.add(multipartFile);
        }
      }
      request.fields['code'] = ticketInspection.code;
      request.fields['tr_time'] = ticketInspection.trTime;
      request.fields['description'] = ticketInspection.description;
      request.fields['m_team_id'] = ticketInspection.mTeamId;
      request.fields['assigned_to'] = ticketInspection.assigneeId;
      request.fields['gps_lng'] = jsonEncode(ticketInspection.gpsLng);
      request.fields['gps_lat'] = jsonEncode(ticketInspection.gpsLat);
      request.fields['m_company_id'] = ticketInspection.mCompanyId;
      request.fields['m_division_id'] = ticketInspection.mDivisionId.isNotEmpty
          ? ticketInspection.mDivisionId
          : jsonEncode(null);
      request.headers.addAll(headers);
      var response = await request.send();

      response.stream.transform(utf8.decoder).listen((value) {
        log('cek url : $url');
        log('cek body fields encode : ${jsonEncode(request.fields)}');
        log('cek body files encode : ${request.files.map((e) => 'MultipartFile(field : ${e.field}, fileName : ${e.filename}, length: ${e.length / 1000} Kb)').toList()}');
        log('cek response : $value');
        var res = jsonDecode(value);
        if (response.statusCode == 200) {
          onSuccess(context, res['message']);
        } else {
          onError(context, res['message']);
        }
      });
    } on SocketException {
      onError(context, 'Tidak Ada Koneksi Internet');
      rethrow;
    } on HttpException {
      onError(context, 'Tidak Ada Koneksi Internet');
      rethrow;
    } on FormatException {
      onError(context, 'Response Format Gagal');
      rethrow;
    } catch (exception) {
      onError(context, exception.toString());
      rethrow;
    }
  }

  Future<void> createResponseInspection(
    BuildContext context,
    TicketInspectionModel ticketInspection,
    HistoryInspectionModel responseInspection,
    Function(BuildContext context, dynamic successMessage) onSuccess,
    Function(BuildContext context, String errorMessage) onError,
  ) async {
    String inspectionToken = await StorageManager.readData("inspectionToken");
    log('cek CreateResponseInspectionToken : $inspectionToken');

    var headers = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Authorization': 'Bearer $inspectionToken'
    };

    try {
      var url =
          'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/response/create';
      var request = http.MultipartRequest("POST", Uri.parse(url));
      for (final image in responseInspection.attachments) {
        if (image.toString().contains('http')) {
          var response = await http.get(Uri.parse(image));
          List imageName = image.toString().split('/');
          var multipartFile = http.MultipartFile.fromBytes(
            'file[]',
            response.bodyBytes,
            filename: imageName.last,
            contentType: MediaType.parse('image/jpeg'),
          );
          request.files.add(multipartFile);
        } else if (image.toString().isNotEmpty) {
          File imageFile = File(image);
          var stream = http.ByteStream(imageFile.openRead());
          var length = await imageFile.length();

          var mimeContent = lookupMimeType(
              '${imageFile.path.toString().substring(imageFile.path.toString().length - 20)}');
          var typeMedia =
              mimeContent!.substring(0, mimeContent.indexOf('/', 0));

          var pos = mimeContent.indexOf('/', 0);
          var subTypeMedia = mimeContent.substring(pos + 1, mimeContent.length);

          var multipartFile = http.MultipartFile(
            'file[]',
            stream,
            length,
            filename: basename(imageFile.path),
            contentType: MediaType(typeMedia, subTypeMedia),
          );
          request.files.add(multipartFile);
        }
      }
      request.fields['code'] = responseInspection.code;
      request.fields['tr_time'] = responseInspection.trTime;
      request.fields['description'] = responseInspection.description;
      request.fields['reassigned_to'] = responseInspection.reassignedTo;
      request.fields['gps_lng'] = jsonEncode(responseInspection.gpsLng);
      request.fields['gps_lat'] = jsonEncode(responseInspection.gpsLat);
      request.fields['t_inspection_id'] = ticketInspection.id;
      request.fields['status'] = responseInspection.status;
      request.fields['consulted_with'] = responseInspection.consultedWith;
      request.headers.addAll(headers);
      var response = await request.send();

      response.stream.transform(utf8.decoder).listen((value) {
        log('cek url : $url');
        log('cek body fields encode : ${jsonEncode(request.fields)}');
        log('cek body files encode : ${request.files.map((e) => 'MultipartFile(field : ${e.field}, fileName : ${e.filename}, length: ${e.length / 1000} Kb)').toList()}');
        log('cek response : $value');
        var res = jsonDecode(value);
        if (response.statusCode == 200) {
          onSuccess(context, res['message']);
        } else {
          onError(context, res['message']);
        }
      });
    } on SocketException {
      onError(context, 'Tidak Ada Koneksi Internet');
      rethrow;
    } on HttpException {
      onError(context, 'Tidak Ada Koneksi Internet');
      rethrow;
    } on FormatException {
      onError(context, 'Response Format Gagal');
      rethrow;
    } catch (exception) {
      onError(context, exception.toString());
      rethrow;
    }
  }
}

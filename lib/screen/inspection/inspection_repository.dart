import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:epms/base/api/api_configuration.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/model/response_inspection_model.dart';
import 'package:epms/model/ticket_inspection_data_model.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/model/ticket_inspection_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

class InspectionRepository extends APIConfiguration {
  Future<void> getMyInspectionNotClose(
    BuildContext context,
    Function(BuildContext context, TicketInspectionDataModel data) onSuccess,
    Function(BuildContext context, String errorMessage) onError,
  ) async {
    String inspectionToken = await StorageManager.readData("inspectionToken");
    final lastSynchTimeInspection =
        await StorageManager.readData('lastSynchTimeInspection');
    final lastSynchDateInspection =
        await StorageManager.readData('lastSynchDateInspection');
    log('cek getMyInspectionNotClose : $inspectionToken');

    try {
      var headers = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $inspectionToken'
      };

      // var urlInspectionDev =
      //     'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/inspection/filter/on-going/inspector';
      // var urlInspectionDev =
      //     'http://10.10.10.91/inspection/public/index.php/api/v1/inspection/filter/on-going/inspector?updated_date=${lastSynchDateInspection != null ? lastSynchDateInspection : ""}&updated_time=${lastSynchTimeInspection != null ? lastSynchTimeInspection : ""}';
      var urlInspectionProd =
          'https://inspection.anj-group.co.id/public/index.php/api/v1/inspection/filter/on-going/inspector?updated_date=${lastSynchDateInspection != null ? lastSynchDateInspection : ""}&updated_time=${lastSynchTimeInspection != null ? lastSynchTimeInspection : ""}';
      var responseMyInspection =
          await ioClient!.get(Uri.parse(urlInspectionProd), headers: headers);
      log('cek url : $urlInspectionProd');
      log('cek response getMyInspectionNotClose : ${responseMyInspection.body}');

      TicketInspectionResponse res = TicketInspectionResponse.fromJson(
          jsonDecode(responseMyInspection.body));

      if (res.success) {
        onSuccess(context, res.data);
      } else {
        onError(context, res.message);
      }
    } on SocketException {
      log('cek error getMyInspectionNotClose : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on HttpException {
      log('cek error getMyInspectionNotClose : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on FormatException {
      log('cek error getMyInspectionNotClose : Response Format Gagal');
      onError(context, 'Response Format Gagal');
    } catch (exception) {
      log('cek error getMyInspectionNotClose : $exception');
      onError(context, exception.toString());
      rethrow;
    }
  }

  Future<void> getMyInspectionClose(
    BuildContext context,
    Function(BuildContext context, TicketInspectionDataModel data) onSuccess,
    Function(BuildContext context, String errorMessage) onError,
  ) async {
    String inspectionToken = await StorageManager.readData("inspectionToken");
    final lastSynchTimeInspection =
        await StorageManager.readData('lastSynchTimeInspection');
    final lastSynchDateInspection =
        await StorageManager.readData('lastSynchDateInspection');
    log('cek getMyInspectionClose : $inspectionToken');

    try {
      var headers = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $inspectionToken'
      };

      // var urlInspectionDev =
      //     'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/inspection/filter/close/inspector';
      // var urlInspectionDev =
      //     'http://10.10.10.91/inspection/public/index.php/api/v1/inspection/filter/close/inspector?updated_date=${lastSynchDateInspection != null ? lastSynchDateInspection : ""}&updated_time=${lastSynchTimeInspection != null ? lastSynchTimeInspection : ""}';
      var urlInspectionProd =
          'https://inspection.anj-group.co.id/public/index.php/api/v1/inspection/filter/close/inspector?updated_date=${lastSynchDateInspection != null ? lastSynchDateInspection : ""}&updated_time=${lastSynchTimeInspection != null ? lastSynchTimeInspection : ""}';
      var responseMyInspection =
          await ioClient!.get(Uri.parse(urlInspectionProd), headers: headers);
      log('cek url : $urlInspectionProd');
      log('cek response getMyInspectionClose : ${responseMyInspection.body}');

      TicketInspectionResponse res = TicketInspectionResponse.fromJson(
          jsonDecode(responseMyInspection.body));

      if (res.success) {
        onSuccess(context, res.data);
      } else {
        onError(context, res.message);
      }
    } on SocketException {
      log('cek error getMyInspectionClose : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on HttpException {
      log('cek error getMyInspectionClose : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on FormatException {
      log('cek error getMyInspectionClose : Response Format Gagal');
      onError(context, 'Response Format Gagal');
    } catch (exception) {
      log('cek error getMyInspectionClose : $exception');
      onError(context, exception.toString());
      rethrow;
    }
  }

  Future<void> getToDoInspection(
    BuildContext context,
    Function(BuildContext context, TicketInspectionDataModel data) onSuccess,
    Function(BuildContext context, String errorMessage) onError,
  ) async {
    final lastSynchTimeInspection =
        await StorageManager.readData('lastSynchTimeInspection');
    final lastSynchDateInspection =
        await StorageManager.readData('lastSynchDateInspection');
    String inspectionToken = await StorageManager.readData("inspectionToken");
    log('cek TodoInspectionToken : $inspectionToken');

    try {
      var headers = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $inspectionToken'
      };

      // var urlInspectionDev =
      //     'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/inspection/myduty';
      // var urlInspectionDev =
      //     'http://10.10.10.91/inspection/public/index.php/api/v1/inspection/myduty?updated_date=${lastSynchDateInspection != null ? lastSynchDateInspection : ""}&updated_time=${lastSynchTimeInspection != null ? lastSynchTimeInspection : ""}';
      var urlInspectionProd =
          'https://inspection.anj-group.co.id/public/index.php/api/v1/inspection/myduty?updated_date=${lastSynchDateInspection != null ? lastSynchDateInspection : ""}&updated_time=${lastSynchTimeInspection != null ? lastSynchTimeInspection : ""}';
      var responseToDoInspection =
          await ioClient!.get(Uri.parse(urlInspectionProd), headers: headers);
      log('cek url : $urlInspectionProd');
      log('cek response todo inspection : ${responseToDoInspection.body}');

      TicketInspectionResponse res = TicketInspectionResponse.fromJson(
          jsonDecode(responseToDoInspection.body));

      if (res.success) {
        onSuccess(context, res.data);
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

  Future<void> getToDoInspectionNotClose(
    BuildContext context,
    Function(BuildContext context, TicketInspectionDataModel data) onSuccess,
    Function(BuildContext context, String errorMessage) onError,
  ) async {
    String inspectionToken = await StorageManager.readData("inspectionToken");
    final lastSynchTimeInspection =
        await StorageManager.readData('lastSynchTimeInspection');
    final lastSynchDateInspection =
        await StorageManager.readData('lastSynchDateInspection');
    log('cek getToDoInspectionNotClose : $inspectionToken');

    try {
      var headers = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $inspectionToken'
      };

      // var urlInspectionDev =
      //     'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/inspection/filter/on-going/assignee';
      // var urlInspectionDev =
      //     'http://10.10.10.91/inspection/public/index.php/api/v1/inspection/filter/on-going/assignee?updated_date=${lastSynchDateInspection != null ? lastSynchDateInspection : ""}&updated_time=${lastSynchTimeInspection != null ? lastSynchTimeInspection : ""}';
      var urlInspectionProd =
          'https://inspection.anj-group.co.id/public/index.php/api/v1/inspection/filter/on-going/assignee?updated_date=${lastSynchDateInspection != null ? lastSynchDateInspection : ""}&updated_time=${lastSynchTimeInspection != null ? lastSynchTimeInspection : ""}';
      var responseToDoInspection =
          await ioClient!.get(Uri.parse(urlInspectionProd), headers: headers);
      log('cek url : $urlInspectionProd');
      log('cek response getToDoInspectionNotClose : ${responseToDoInspection.body}');

      TicketInspectionResponse res = TicketInspectionResponse.fromJson(
          jsonDecode(responseToDoInspection.body));

      if (res.success) {
        onSuccess(context, res.data);
      } else {
        onError(context, res.message);
      }
    } on SocketException {
      log('cek error getToDoInspectionNotClose : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on HttpException {
      log('cek error getToDoInspectionNotClose : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on FormatException {
      log('cek error getToDoInspectionNotClose : Response Format Gagal');
      onError(context, 'Response Format Gagal');
    } catch (exception) {
      log('cek error getToDoInspectionNotClose : $exception');
      onError(context, exception.toString());
      rethrow;
    }
  }

  Future<void> getToDoInspectionClose(
    BuildContext context,
    Function(BuildContext context, TicketInspectionDataModel data) onSuccess,
    Function(BuildContext context, String errorMessage) onError,
  ) async {
    String inspectionToken = await StorageManager.readData("inspectionToken");
    final lastSynchTimeInspection =
        await StorageManager.readData('lastSynchTimeInspection');
    final lastSynchDateInspection =
        await StorageManager.readData('lastSynchDateInspection');
    log('cek getToDoInspectionClose : $inspectionToken');

    try {
      var headers = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $inspectionToken'
      };

      // var urlInspectionDev =
      //     'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/inspection/filter/close/assignee';
      // var urlInspectionDev =
      //     'http://10.10.10.91/inspection/public/index.php/api/v1/inspection/filter/close/assignee?updated_date=${lastSynchDateInspection != null ? lastSynchDateInspection : ""}&updated_time=${lastSynchTimeInspection != null ? lastSynchTimeInspection : ""}';
      var urlInspectionProd =
          'https://inspection.anj-group.co.id/public/index.php/api/v1/inspection/filter/close/assignee?updated_date=${lastSynchDateInspection != null ? lastSynchDateInspection : ""}&updated_time=${lastSynchTimeInspection != null ? lastSynchTimeInspection : ""}';
      var responseToDoInspection =
          await ioClient!.get(Uri.parse(urlInspectionProd), headers: headers);
      log('cek url : $urlInspectionProd');
      log('cek response getToDoInspectionClose : ${responseToDoInspection.body}');

      TicketInspectionResponse res = TicketInspectionResponse.fromJson(
          jsonDecode(responseToDoInspection.body));

      if (res.success) {
        onSuccess(context, res.data);
      } else {
        onError(context, res.message);
      }
    } on SocketException {
      log('cek error getToDoInspectionClose : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on HttpException {
      log('cek error getToDoInspectionClose : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on FormatException {
      log('cek error getToDoInspectionClose : Response Format Gagal');
      onError(context, 'Response Format Gagal');
    } catch (exception) {
      log('cek error getToDoInspectionClose : $exception');
      onError(context, exception.toString());
      rethrow;
    }
  }

  Future<void> getMySubordinate(
    BuildContext context,
    Function(BuildContext context, TicketInspectionDataModel data) onSuccess,
    Function(BuildContext context, String errorMessage) onError,
  ) async {
    String inspectionToken = await StorageManager.readData("inspectionToken");
    final lastSynchTimeInspection =
        await StorageManager.readData('lastSynchTimeInspection');
    final lastSynchDateInspection =
        await StorageManager.readData('lastSynchDateInspection');
    log('cek mySubordinateInspectionToken : $inspectionToken');

    try {
      var headers = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $inspectionToken'
      };

      // var urlInspectionDev =
      //     'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/inspection/mysubordinate';
      // var urlInspectionDev =
      //     'http://10.10.10.91/inspection/public/index.php/api/v1/inspection/mysubordinate?updated_date=${lastSynchDateInspection != null ? lastSynchDateInspection : ""}&updated_time=${lastSynchTimeInspection != null ? lastSynchTimeInspection : ""}';
      var urlInspectionProd =
          'https://inspection.anj-group.co.id/public/index.php/api/v1/inspection/mysubordinate?updated_date=${lastSynchDateInspection != null ? lastSynchDateInspection : ""}&updated_time=${lastSynchTimeInspection != null ? lastSynchTimeInspection : ""}';
      var responseMySubordinate =
          await ioClient!.get(Uri.parse(urlInspectionProd), headers: headers);
      log('cek url : $urlInspectionProd');
      TicketInspectionResponse res = TicketInspectionResponse.fromJson(
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

  Future<void> getOnGoingInspectionNotClose(
    BuildContext context,
    Function(BuildContext context, TicketInspectionDataModel data) onSuccess,
    Function(BuildContext context, String errorMessage) onError,
  ) async {
    String inspectionToken = await StorageManager.readData("inspectionToken");
    final lastSynchTimeInspection =
        await StorageManager.readData('lastSynchTimeInspection');
    final lastSynchDateInspection =
        await StorageManager.readData('lastSynchDateInspection');
    log('cek getOnGoingInspectionNotClose : $inspectionToken');

    try {
      var headers = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $inspectionToken'
      };

      // var urlInspectionDev =
      //     'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/inspection/filter/on-going/subordinate';
      // var urlInspectionDev =
      //     'http://10.10.10.91/inspection/public/index.php/api/v1/inspection/filter/on-going/subordinate?updated_date=${lastSynchDateInspection != null ? lastSynchDateInspection : ""}&updated_time=${lastSynchTimeInspection != null ? lastSynchTimeInspection : ""}';
      var urlInspectionProd =
          'https://inspection.anj-group.co.id/public/index.php/api/v1/inspection/filter/on-going/subordinate?updated_date=${lastSynchDateInspection != null ? lastSynchDateInspection : ""}&updated_time=${lastSynchTimeInspection != null ? lastSynchTimeInspection : ""}';
      var responseMySubordinate =
          await ioClient!.get(Uri.parse(urlInspectionProd), headers: headers);
      log('cek url : $urlInspectionProd');
      TicketInspectionResponse res = TicketInspectionResponse.fromJson(
          jsonDecode(responseMySubordinate.body));
      log('cek response getOnGoingInspectionNotClose : ${res.data}');

      if (res.success) {
        onSuccess(context, res.data);
      } else {
        onError(context, res.message);
      }
    } on SocketException {
      log('cek error getOnGoingInspectionNotClose : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on HttpException {
      log('cek error getOnGoingInspectionNotClose : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on FormatException {
      log('cek error getOnGoingInspectionNotClose : Response Format Gagal');
      onError(context, 'Response Format Gagal');
    } catch (exception) {
      log('cek error getOnGoingInspectionNotClose : $exception');
      onError(context, exception.toString());
      rethrow;
    }
  }

  Future<void> getOnGoingInspectionClose(
    BuildContext context,
    Function(BuildContext context, TicketInspectionDataModel data) onSuccess,
    Function(BuildContext context, String errorMessage) onError,
  ) async {
    String inspectionToken = await StorageManager.readData("inspectionToken");
    final lastSynchTimeInspection =
        await StorageManager.readData('lastSynchTimeInspection');
    final lastSynchDateInspection =
        await StorageManager.readData('lastSynchDateInspection');
    log('cek getOnGoingInspectionClose : $inspectionToken');

    try {
      var headers = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $inspectionToken'
      };

      // var urlInspectionDev =
      //     'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/inspection/filter/close/subordinate';
      // var urlInspectionDev =
      //     'http://10.10.10.91/inspection/public/index.php/api/v1/inspection/filter/close/subordinate?updated_date=${lastSynchDateInspection != null ? lastSynchDateInspection : ""}&updated_time=${lastSynchTimeInspection != null ? lastSynchTimeInspection : ""}';
      var urlInspectionProd =
          'https://inspection.anj-group.co.id/public/index.php/api/v1/inspection/filter/close/subordinate?updated_date=${lastSynchDateInspection != null ? lastSynchDateInspection : ""}&updated_time=${lastSynchTimeInspection != null ? lastSynchTimeInspection : ""}';
      var responseMySubordinate =
          await ioClient!.get(Uri.parse(urlInspectionProd), headers: headers);
      log('cek url : $urlInspectionProd');
      TicketInspectionResponse res = TicketInspectionResponse.fromJson(
          jsonDecode(responseMySubordinate.body));
      log('cek response getOnGoingInspectionClose : ${res.data}');

      if (res.success) {
        onSuccess(context, res.data);
      } else {
        onError(context, res.message);
      }
    } on SocketException {
      log('cek error getOnGoingInspectionClose : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on HttpException {
      log('cek error getOnGoingInspectionClose : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on FormatException {
      log('cek error getOnGoingInspectionClose : Response Format Gagal');
      onError(context, 'Response Format Gagal');
    } catch (exception) {
      log('cek error getOnGoingInspectionClose : $exception');
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
      // var urlInspectionDev =
      //     'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/inspection/create';
      // var urlInspectionDev =
      //     'http://10.10.10.91/inspection/public/index.php/api/v1/inspection/create';
      var urlInspectionProd =
          'https://inspection.anj-group.co.id/public/index.php/api/v1/inspection/create';
      var request = http.MultipartRequest("POST", Uri.parse(urlInspectionProd));
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
      request.fields['using_gps'] = jsonEncode(ticketInspection.usingGps);
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
    ResponseInspectionModel responseInspection,
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
      // var urlInspectionDev =
      //     'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/response/create';
      // var urlInspectionDev =
      //     'http://10.10.10.91/inspection/public/index.php/api/v1/response/create';
      var urlInspectionProd =
          'https://inspection.anj-group.co.id/public/index.php/api/v1/response/create';
      var request = http.MultipartRequest("POST", Uri.parse(urlInspectionProd));
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
      request.fields['t_inspection_id'] = responseInspection.tInspectionId;
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

  Future<String> saveFoto(String imageUrl) async {
    if (imageUrl.contains('http')) {
      try {
        var res = await ioClient!.get(Uri.parse(imageUrl));

        if (res.statusCode == 200) {
          log('download foto success : $imageUrl');
          return base64.encode(res.bodyBytes);
        }
        return '';
      } catch (e) {
        return '';
      }
    } else if (imageUrl.isNotEmpty) {
      File imageFile = File(imageUrl);
      final image = await imageFile.readAsBytes();
      log('convert foto success : ${imageFile.path}');

      return base64.encode(image);
    } else {
      return '';
    }
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:epms/base/api/api_configuration.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/model/my_inspection_response.dart';
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
    log('cek inspectionToken : $inspectionToken');

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
      log('cek response get my inspection : ${responseMyInspection.body}');
      MyInspectionResponse res =
          MyInspectionResponse.fromJson(jsonDecode(responseMyInspection.body));

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
    log('cek inspectionToken : $inspectionToken');

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
      log('cek response todo inspection : ${responseToDoInspection.body}');
      TodoInspectionResponse res = TodoInspectionResponse.fromJson(
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

  Future<void> createInspection(
    BuildContext context,
    TicketInspectionModel ticketInspection,
    Function(BuildContext context, dynamic successMessage) onSuccess,
    Function(BuildContext context, String errorMessage) onError,
  ) async {
    String inspectionToken = await StorageManager.readData("inspectionToken");
    log('cek inspectionToken : $inspectionToken');

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
        } else {
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
    Function(BuildContext context, dynamic successMessage) onSuccess,
    Function(BuildContext context, String errorMessage) onError,
  ) async {
    String inspectionToken = await StorageManager.readData("inspectionToken");
    log('cek inspectionToken : $inspectionToken');

    var headers = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Authorization': 'Bearer $inspectionToken'
    };

    try {
      var url =
          'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/response/create';
      var request = http.MultipartRequest("POST", Uri.parse(url));
      for (final image in ticketInspection.responses.last.attachments) {
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
        } else {
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
      request.fields['code'] = ticketInspection.responses.last.code;
      request.fields['tr_time'] = ticketInspection.responses.last.trTime;
      request.fields['description'] =
          ticketInspection.responses.last.description;
      request.fields['reassigned_to'] =
          ticketInspection.responses.last.reassignedTo;
      request.fields['gps_lng'] =
          jsonEncode(ticketInspection.responses.last.gpsLng);
      request.fields['gps_lat'] =
          jsonEncode(ticketInspection.responses.last.gpsLat);
      request.fields['t_inspection_id'] = ticketInspection.id;
      request.fields['status'] = ticketInspection.responses.last.status;
      request.fields['consulted_with'] =
          ticketInspection.responses.last.consultedWith;
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

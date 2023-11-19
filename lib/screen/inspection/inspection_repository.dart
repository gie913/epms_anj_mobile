import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:epms/base/api/api_configuration.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

class InspectionRepository extends APIConfiguration {
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
      for (final image in ticketInspection.images) {
        File imageFile = File(image);
        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();

        var mimeContent = lookupMimeType(
            '${imageFile.path.toString().substring(imageFile.path.toString().length - 20)}');
        var typeMedia = mimeContent!.substring(0, mimeContent.indexOf('/', 0));

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
      request.fields['code'] = ticketInspection.id;
      request.fields['tr_time'] =
          TimeManager.dateInspection(ticketInspection.date);
      request.fields['description'] = ticketInspection.description;
      request.fields['m_team_id'] = ticketInspection.mTeamId;
      request.fields['assigned_to'] = ticketInspection.assignedTo;
      request.fields['gps_lng'] = jsonEncode(ticketInspection.longitude);
      request.fields['gps_lat'] = jsonEncode(ticketInspection.latitude);
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
}

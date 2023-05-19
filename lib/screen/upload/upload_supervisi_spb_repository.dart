
import 'dart:convert';
import 'dart:io';

import 'package:epms/base/api/api_configuration.dart';
import 'package:epms/base/api/api_endpoint.dart';
import 'package:epms/common_manager/file_manager.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UploadSupervisiSPBRepository extends APIConfiguration {
  void doPostUploadSupervisiSPB(BuildContext context, String listSPB, String listGrading, onSuccess, onError) async {
    String token = await StorageManager.readData("userToken");
    String baseUrl = await StorageManager.readData("apiServer");

    Map<String, dynamic> newMapSPB = jsonDecode(listSPB);
    Map<String, dynamic> newMapGrading = jsonDecode(listGrading);

    try {
      var url = baseUrl + APIEndPoint.UPLOAD_ENDPOINT;
      var uri = Uri.parse(url);
      var mapTP = Map<String, dynamic>();
      mapTP = {
        'Supervisi': {
          'T_SPB_Supervisi_Schema_List': newMapSPB,
          'T_Grading_3rd_Party_Schema_List' : newMapGrading
        }
      };
      var epmsData = Map<String, dynamic>();
      var jsonMap = jsonEncode(mapTP);
      epmsData['epms_data'] = jsonMap;
      epmsData['user_token'] = token;
      await FileManagerJson().writeFileJsonSupervisiSPB();
      http.Response response = await http.post(
        uri,
        body: epmsData,
      );
      if (response.statusCode == 200) {
        onSuccess(context, response);
      } else {
        onError(context, response);
      }
    } on SocketException {
      onError(context, 'No Internet');
    } on HttpException {
      onError(context, 'No Service Found');
    } on FormatException {
      onError(context, 'Invalid Response format');
    } catch (exception) {
      onError(context, exception.toString());
    }
  }
}

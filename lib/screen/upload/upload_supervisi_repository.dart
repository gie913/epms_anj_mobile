import 'dart:convert';
import 'dart:io';

import 'package:epms/base/api/api_configuration.dart';
import 'package:epms/base/api/api_endpoint.dart';
import 'package:epms/common_manager/file_manager.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UploadSupervisiRepository extends APIConfiguration {
  void doPostUploadSupervisi(BuildContext context, String listSPB,
      String listSPBDetail, onSuccess, onError) async {
    String token = await StorageManager.readData("userToken");
    String baseUrl = await StorageManager.readData("apiServer");

    var newMapSPB;
    var newMapSPBDetail;

    if (listSPB != "Null") {
      newMapSPB = jsonDecode(listSPB);
    }

    if (listSPBDetail != "Null") {
      newMapSPBDetail = jsonDecode(listSPBDetail);
    }

    try {
      var url = baseUrl + APIEndPoint.UPLOAD_ENDPOINT;
      var uri = Uri.parse(url);
      var mapTP = Map<String, dynamic>();
      mapTP = {
        'Supervisi': {
          'T_OPH_Supervise_Schema_List': newMapSPB,
          'T_Supervise_Ancak_Panen_Schema_List': newMapSPBDetail
        }
      };
      var epmsData = Map<String, dynamic>();
      var jsonMap = jsonEncode(mapTP);
      epmsData['epms_data'] = jsonMap;
      epmsData['user_token'] = token;
      await FileManagerJson().writeFileJsonSupervisi();
      http.Response response = await http.post(
        uri,
        body: epmsData,
      );
      if (response.statusCode == 200) {
        print(response.body);
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

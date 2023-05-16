
import 'dart:convert';
import 'dart:io';

import 'package:epms/base/api/api_configuration.dart';
import 'package:epms/base/api/api_endpoint.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class UploadSupervisiRepository extends APIConfiguration {
  void doPostUploadSupervisi(BuildContext context, String listSPB, String listSPBDetail, onSuccess, onError) async {
    String token = await StorageManager.readData("userToken");


    Map<String, dynamic> newMapSPB = jsonDecode(listSPB);
    Map<String, dynamic> newMapSPBDetail = jsonDecode(listSPBDetail);

    try {
      var url = APIEndPoint.BASE_URL + APIEndPoint.UPLOAD_ENDPOINT;
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
      print(jsonMap);
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

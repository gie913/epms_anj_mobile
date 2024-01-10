import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:epms/base/api/api_configuration.dart';
import 'package:epms/base/api/api_endpoint.dart';
import 'package:epms/common_manager/file_manager.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:flutter/cupertino.dart';

class UploadSPBRepository extends APIConfiguration {
  void doPostUploadSPB(BuildContext context, String listSPB,
      String listSPBDetail, String listSPBLoader, onSuccess, onError) async {
    String token = await StorageManager.readData("userToken");
    String baseUrl = await StorageManager.readData("apiServer");

    Map<String, dynamic> newMapSPB = jsonDecode(listSPB);
    Map<String, dynamic> newMapSPBDetail = jsonDecode(listSPBDetail);
    Map<String, dynamic> newMapSPBLoader = jsonDecode(listSPBLoader);

    try {
      var url = baseUrl + APIEndPoint.UPLOAD_ENDPOINT;
      var uri = Uri.parse(url);
      var mapTP = Map<String, dynamic>();
      mapTP = {
        'TP': {
          'T_SPB_Schema_List': newMapSPB,
          'T_SPB_Detail_Schema_List': newMapSPBDetail,
          'T_SPB_Loader_Schema_List': newMapSPBLoader
        }
      };
      log('cek params : $mapTP');
      var epmsData = Map<String, dynamic>();
      var jsonMap = jsonEncode(mapTP);
      epmsData['epms_data'] = jsonMap;
      epmsData['user_token'] = token;
      await FileManagerJson().writeFileJsonSPB();
      var response = await ioClient!.post(
        uri,
        body: epmsData,
      );
      // http.Response response = await http.post(
      //   uri,
      //   body: epmsData,
      // );
      print(response.body);
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

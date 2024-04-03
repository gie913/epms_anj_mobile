import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:epms/base/api/api_configuration.dart';
import 'package:epms/base/api/api_endpoint.dart';
import 'package:epms/common_manager/storage_manager.dart';

class LogOutRepository extends APIConfiguration {
  void doPostLogOut(onSuccess, onError) async {
    String baseUrl = await StorageManager.readData("apiServer");
    String userToken = await StorageManager.readData("userToken");
    try {
      var url = baseUrl + APIEndPoint.LOGOUT_ENDPOINT;
      var uri = Uri.parse(url);
      var map = new Map<String, dynamic>();
      map['user_token'] = userToken;
      // http.Response response = await http.post(
      //   uri,
      //   body: map,
      // );
      var response = await ioClient!.post(
        uri,
        body: map,
      );
      if (response.statusCode == 200) {
        onSuccess();
      } else {
        onError(response.statusCode.toString());
      }
      print(response.body);
    } on SocketException {
      onError('No Internet');
    } on HttpException {
      onError('No Service Found');
    } on FormatException {
      onError('Invalid Response format');
    } catch (exception) {
      onError(exception.toString());
    }
  }

  Future<void> doPostLogOutInspection(
    Function(String value) onSuccess,
    Function(String value) onError,
  ) async {
    String inspectionToken = await StorageManager.readData("inspectionToken");
    try {
      var headers = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $inspectionToken'
      };
      // var urlInspectionDev =
      //     'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/signout';
      // var urlInspectionDev =
      //     'http://10.10.10.91/inspection/public/index.php/api/v1/signout';
      var urlInspectionProd =
          'https://inspection.anj-group.co.id/public/index.php/api/v1/signout';
      var uri = Uri.parse(urlInspectionProd);
      var response = await ioClient!.get(uri, headers: headers);
      final data = jsonDecode(response.body);
      log('cek url : $urlInspectionProd');
      log('cek response logout inspection : ${response.body}');

      if (data['success'] == true) {
        onSuccess(data['message']);
      } else {
        onError(data['message']);
      }
      print(response.body);
    } on SocketException {
      onError('No Internet');
    } on HttpException {
      onError('No Service Found');
    } on FormatException {
      onError('Invalid Response format');
    } catch (exception) {
      onError(exception.toString());
    }
  }
}

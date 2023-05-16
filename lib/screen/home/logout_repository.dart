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
}

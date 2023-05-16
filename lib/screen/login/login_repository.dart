import 'dart:convert';
import 'dart:io';

import 'package:epms/base/api/api_configuration.dart';
import 'package:epms/base/api/api_endpoint.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/model/login_response.dart';
import 'package:flutter/material.dart';

class LoginRepository extends APIConfiguration {
  LoginRepository() : super();


  void doPostLogin(BuildContext context, String username, String password,
      onSuccess, onError) async {
    String baseUrl = await StorageManager.readData("apiServer");
    try {
      var url = baseUrl + APIEndPoint.LOGIN_ENDPOINT;
      var uri = Uri.parse(url);
      var map = new Map<String, dynamic>();
      map['user_login'] = username;
      map['password'] = password;
      var response = await ioClient!.post(
        uri,
        body: map,
      );
      // http.Response response = await http.post(
      //   uri,
      //   body: map,
      // );
      LoginResponse loginResponseRevamp =
          LoginResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        onSuccess(context, loginResponseRevamp);
      } else {
        String jsonString = json.decode(response.body)['message'];
        onError(context, jsonString);
      }
    } on SocketException {
      onError(context, 'Tidak Ada Koneksi Internet');
    } on HttpException {
      onError(context, 'Tidak Ada Koneksi Internet');
    } on FormatException {
      onError(context, 'Response Format Gagal');
    } catch (exception) {
      onError(context, exception.toString());
    }
  }
}

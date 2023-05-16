import 'dart:convert';
import 'dart:io';

import 'package:epms/base/api/api_configuration.dart';
import 'package:epms/base/api/api_endpoint.dart';
import 'package:epms/common_manager/storage_manager.dart';

class UploadOPHRepository extends APIConfiguration {
  void doPostUploadOPH(
      String listOPH, String listAttendance, onSuccess, onError) async {
    Map<String, dynamic> newMapOPH = jsonDecode(listOPH);
    Map<String, dynamic> newMapAttendance = jsonDecode(listAttendance);

    String token = await StorageManager.readData("userToken");

    try {
      var url = APIEndPoint.BASE_URL + APIEndPoint.UPLOAD_ENDPOINT;
      var uri = Uri.parse(url);
      var mapBC = Map<String, dynamic>();

      mapBC = {
        'BC': {
          'T_OPH_Schema_List': newMapOPH,
          'T_Attendance_Schema_List_Panen': newMapAttendance
        }
      };
      var epmsData = Map<String, dynamic>();
      var jsonMap = jsonEncode(mapBC);
      epmsData['epms_data'] = jsonMap;
      epmsData['user_token'] = token;

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
        onSuccess(response);
      } else {
        onError(response);
      }
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

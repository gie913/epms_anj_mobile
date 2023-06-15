import 'dart:convert';
import 'dart:io';

import 'package:epms/base/api/api_configuration.dart';
import 'package:epms/base/api/api_endpoint.dart';
import 'package:epms/common_manager/file_manager.dart';
import 'package:epms/common_manager/storage_manager.dart';

class KeraniRepository extends APIConfiguration {
  void uploadData(
    String listOPH,
    String listAttendance,
    String listSPB,
    String listSPBDetail,
    String listSPBLoader,
    onSuccess,
    onError,
  ) async {
    String token = await StorageManager.readData("userToken");
    String baseUrl = await StorageManager.readData("apiServer");

    Map<String, dynamic> newMapOPH = jsonDecode(listOPH);
    Map<String, dynamic> newMapAttendance = jsonDecode(listAttendance);

    Map<String, dynamic> newMapSPB = jsonDecode(listSPB);
    Map<String, dynamic> newMapSPBDetail = jsonDecode(listSPBDetail);
    Map<String, dynamic> newMapSPBLoader = jsonDecode(listSPBLoader);

    try {
      var url = baseUrl + APIEndPoint.UPLOAD_ENDPOINT;
      var uri = Uri.parse(url);
      var mapKR = {
        'BC': {
          'T_OPH_Schema_List': newMapOPH,
          'T_Attendance_Schema_List_Panen': newMapAttendance
        },
        'TP': {
          'T_SPB_Schema_List': newMapSPB,
          'T_SPB_Detail_Schema_List': newMapSPBDetail,
          'T_SPB_Loader_Schema_List': newMapSPBLoader
        }
      };

      var epmsData = Map<String, dynamic>();
      var jsonMap = jsonEncode(mapKR);
      epmsData['epms_data'] = jsonMap;
      epmsData['user_token'] = token;
      await FileManagerJson().writeFileJsonKerani();
      print('cek body upload role KR : $epmsData');
      var response = await ioClient!.post(
        uri,
        body: epmsData,
      );
      // http.Response response = await http.post(
      //   uri,
      //   body: epmsData,
      // );
      if (response.statusCode == 200) {
        final responseSuccess = jsonDecode(response.body);
        onSuccess(responseSuccess);
      } else {
        final responseFailed = jsonDecode(response.body)['message'];
        onError(responseFailed);
      }
    } on SocketException {
      onError('No Internet');
    } on HttpException {
      onError('No Service Found');
    } on FormatException {
      onError('Invalid Response format');
    } catch (exception) {
      onError(exception.toString());
      rethrow;
    }
  }
}

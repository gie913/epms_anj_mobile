import 'dart:convert';
import 'dart:io';

import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/database/service/database_attendance.dart';
import 'package:epms/database/service/database_oph.dart';
import 'package:epms/database/service/database_oph_supervise.dart';
import 'package:epms/database/service/database_oph_supervise_ancak.dart';
import 'package:epms/database/service/database_spb.dart';
import 'package:epms/database/service/database_spb_detail.dart';
import 'package:epms/database/service/database_spb_loader.dart';
import 'package:epms/database/service/database_spb_supervise.dart';
import 'package:epms/database/service/database_tbs_luar.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/oph_supervise.dart';
import 'package:epms/model/oph_supervise_ancak.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_detail.dart';
import 'package:epms/model/spb_loader.dart';
import 'package:epms/model/spb_supervise.dart';
import 'package:epms/model/t_attendance_schema.dart';
import 'package:epms/model/tbs_luar.dart';
import 'package:path_provider/path_provider.dart';

class FileManagerJson {
  Future<File?> writeFileJsonOPH() async {
    List<OPH> _listOPH = await DatabaseOPH().selectOPH();
    List<TAttendanceSchema> _listAttendance =
        await DatabaseAttendance().selectEmployeeAttendance();
    List<String> mapListOPH = [];
    List<String> mapListAttendance = [];
    if (_listOPH.isNotEmpty) {
      for (int i = 0; i < _listOPH.length; i++) {
        String jsonString = jsonEncode(_listOPH[i]);
        mapListOPH.add("\"$i\":$jsonString");
      }

      for (int i = 0; i < _listAttendance.length; i++) {
        String jsonString = jsonEncode(_listAttendance[i]);
        mapListAttendance.add("\"$i\":$jsonString");
      }
      var stringListOPH = mapListOPH.join(",");
      var stringListAttendance = mapListAttendance.join(",");
      String listOPH = "{$stringListOPH}";
      String listAttendance = "{$stringListAttendance}";
      Map<String, dynamic> newMapOPH = jsonDecode(listOPH);
      Map<String, dynamic> newMapAttendance = jsonDecode(listAttendance);

      var mapBC = Map<String, dynamic>();
      String token = await StorageManager.readData("userToken");

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

      var json = jsonEncode(epmsData);
      Directory? tempDir = await getExternalStorageDirectory();
      File fileResult = File('${tempDir?.path}/KeraniPanen.json')
        ..writeAsString(json);
      return fileResult;
    } else {
      return null;
    }
  }

  Future<File?> writeFileJsonSPB() async {
    List<SPB> _listSPB = await DatabaseSPB().selectSPB();
    List<SPBDetail> _listSPBDetail =
        await DatabaseSPBDetail().selectSPBDetail();
    List<SPBLoader> _listSPBLoader =
        await DatabaseSPBLoader().selectSPBLoader();
    List<String> mapListSPB = [];
    List<String> mapListSPBDetail = [];
    List<String> mapListSPBLoader = [];

    if (_listSPB.isNotEmpty) {
      for (int i = 0; i < _listSPB.length; i++) {
        String jsonString = jsonEncode(_listSPB[i]);
        mapListSPB.add("\"$i\":$jsonString");
      }
      for (int i = 0; i < _listSPBDetail.length; i++) {
        String jsonString = jsonEncode(_listSPBDetail[i]);
        mapListSPBDetail.add("\"$i\":$jsonString");
      }

      for (int i = 0; i < _listSPBLoader.length; i++) {
        String jsonString = jsonEncode(_listSPBLoader[i]);
        mapListSPBLoader.add("\"$i\":$jsonString");
      }

      var stringListSPB = mapListSPB.join(",");
      var stringListSPBDetail = mapListSPBDetail.join(",");
      var stringListSPBLoader = mapListSPBLoader.join(",");

      String listSPB = "{$stringListSPB}";
      String listSPBDetail = "{$stringListSPBDetail}";
      String listSPBLoader = "{$stringListSPBLoader}";
      String token = await StorageManager.readData("userToken");

      Map<String, dynamic> newMapSPB = jsonDecode(listSPB);
      Map<String, dynamic> newMapSPBDetail = jsonDecode(listSPBDetail);
      Map<String, dynamic> newMapSPBLoader = jsonDecode(listSPBLoader);

      var mapTP = Map<String, dynamic>();
      mapTP = {
        'TP': {
          'T_SPB_Schema_List': newMapSPB,
          'T_SPB_Detail_Schema_List': newMapSPBDetail,
          'T_SPB_Loader_Schema_List': newMapSPBLoader
        }
      };
      var epmsData = Map<String, dynamic>();
      var jsonMap = jsonEncode(mapTP);
      epmsData['epms_data'] = jsonMap;
      epmsData['user_token'] = token;
      print(jsonMap);
      var json = jsonEncode(epmsData);
      Directory? tempDir = await getExternalStorageDirectory();
      File fileResult = File('${tempDir?.path}/KeraniKirim.json')
        ..writeAsString(json);
      return fileResult;
    } else {
      return null;
    }
  }

  Future<File?> writeFileJsonKerani() async {
    List<OPH> _listOPH = await DatabaseOPH().selectOPH();
    List<TAttendanceSchema> _listAttendance =
        await DatabaseAttendance().selectEmployeeAttendance();
    List<String> mapListOPH = [];
    List<String> mapListAttendance = [];

    List<SPB> _listSPB = await DatabaseSPB().selectSPB();
    List<SPBDetail> _listSPBDetail =
        await DatabaseSPBDetail().selectSPBDetail();
    List<SPBLoader> _listSPBLoader =
        await DatabaseSPBLoader().selectSPBLoader();
    List<String> mapListSPB = [];
    List<String> mapListSPBDetail = [];
    List<String> mapListSPBLoader = [];

    String token = await StorageManager.readData("userToken");
    final mapKR = {};

    if (_listOPH.isNotEmpty) {
      for (int i = 0; i < _listOPH.length; i++) {
        String jsonString = jsonEncode(_listOPH[i]);
        mapListOPH.add("\"$i\":$jsonString");
      }

      for (int i = 0; i < _listAttendance.length; i++) {
        String jsonString = jsonEncode(_listAttendance[i]);
        mapListAttendance.add("\"$i\":$jsonString");
      }
      var stringListOPH = mapListOPH.join(",");
      var stringListAttendance = mapListAttendance.join(",");
      String listOPH = "{$stringListOPH}";
      String listAttendance = "{$stringListAttendance}";
      Map<String, dynamic> newMapOPH = jsonDecode(listOPH);
      Map<String, dynamic> newMapAttendance = jsonDecode(listAttendance);

      final mapBC = {
        'BC': {
          'T_OPH_Schema_List': newMapOPH,
          'T_Attendance_Schema_List_Panen': newMapAttendance
        }
      };
      mapKR.addAll(mapBC);
    }

    if (_listSPB.isNotEmpty) {
      for (int i = 0; i < _listSPB.length; i++) {
        String jsonString = jsonEncode(_listSPB[i]);
        mapListSPB.add("\"$i\":$jsonString");
      }
      for (int i = 0; i < _listSPBDetail.length; i++) {
        String jsonString = jsonEncode(_listSPBDetail[i]);
        mapListSPBDetail.add("\"$i\":$jsonString");
      }

      for (int i = 0; i < _listSPBLoader.length; i++) {
        String jsonString = jsonEncode(_listSPBLoader[i]);
        mapListSPBLoader.add("\"$i\":$jsonString");
      }

      var stringListSPB = mapListSPB.join(",");
      var stringListSPBDetail = mapListSPBDetail.join(",");
      var stringListSPBLoader = mapListSPBLoader.join(",");

      String listSPB = "{$stringListSPB}";
      String listSPBDetail = "{$stringListSPBDetail}";
      String listSPBLoader = "{$stringListSPBLoader}";

      Map<String, dynamic> newMapSPB = jsonDecode(listSPB);
      Map<String, dynamic> newMapSPBDetail = jsonDecode(listSPBDetail);
      Map<String, dynamic> newMapSPBLoader = jsonDecode(listSPBLoader);

      final mapTP = {
        'TP': {
          'T_SPB_Schema_List': newMapSPB,
          'T_SPB_Detail_Schema_List': newMapSPBDetail,
          'T_SPB_Loader_Schema_List': newMapSPBLoader
        }
      };
      mapKR.addAll(mapTP);
    }

    var epmsData = Map<String, dynamic>();
    var jsonMap = jsonEncode(mapKR);
    epmsData['epms_data'] = jsonMap;
    epmsData['user_token'] = token;

    var json = jsonEncode(epmsData);
    Directory? tempDir = await getExternalStorageDirectory();
    File fileResult = File('${tempDir?.path}/Kerani.json')..writeAsString(json);
    print('cek direktori file json upload : ${tempDir?.path}/Kerani.json');
    return fileResult;
  }

  Future<File?> writeFileJsonSupervisi() async {
    List<OPHSupervise> _listOPHSupervise =
        await DatabaseOPHSupervise().selectOPHSupervise();
    List<OPHSuperviseAncak> _listOPHAncak =
        await DatabaseOPHSuperviseAncak().selectOPHSuperviseAncak();

    List<String> mapListOPHSupervise = [];
    List<String> mapListOPHAncak = [];

    if (_listOPHSupervise.isNotEmpty || _listOPHAncak.isNotEmpty) {
      if (_listOPHSupervise.isNotEmpty) {
        for (int i = 0; i < _listOPHSupervise.length; i++) {
          String jsonString = jsonEncode(_listOPHSupervise[i]);
          mapListOPHSupervise.add("\"$i\":$jsonString");
        }
      }
      if (_listOPHAncak.isNotEmpty) {
        for (int i = 0; i < _listOPHAncak.length; i++) {
          String jsonString = jsonEncode(_listOPHAncak[i]);
          mapListOPHAncak.add("\"$i\":$jsonString");
        }
      }

      var stringListSPB = mapListOPHSupervise.join(",");
      var stringListSPBDetail = mapListOPHAncak.join(",");

      String? listSPBDetail;
      String? listSPB;

      if (stringListSPBDetail != "") {
        listSPBDetail = "{$stringListSPBDetail}";
      } else {
        listSPBDetail = "Null";
      }

      if (stringListSPB != "") {
        listSPB = "{$stringListSPB}";
      } else {
        listSPB = "Null";
      }

      String token = await StorageManager.readData("userToken");

      var newMapSPB;
      var newMapSPBDetail;

      if (listSPB != "Null") {
        newMapSPB = jsonDecode(listSPB);
      }

      if (listSPBDetail != "Null") {
        newMapSPBDetail = jsonDecode(listSPBDetail);
      }

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
      var json = jsonEncode(epmsData);
      Directory? tempDir = await getExternalStorageDirectory();
      File fileResult = File('${tempDir?.path}/Supervisi.json')
        ..writeAsString(json);
      return fileResult;
    } else {
      return null;
    }
  }

  Future<File?> writeFileJsonSupervisiSPB() async {
    List<SPBSupervise> _listOPHSupervise =
        await DatabaseSPBSupervise().selectSPBSupervise();
    List<TBSLuar> _listTBSLuarGrading = await DatabaseTBSLuar().selectTBSLuar();

    List<String> mapListOPHSupervise = [];
    List<String> mapListTBSLuarGrading = [];

    if (_listOPHSupervise.isNotEmpty || _listTBSLuarGrading.isNotEmpty) {
      for (int i = 0; i < _listOPHSupervise.length; i++) {
        String jsonString = jsonEncode(_listOPHSupervise[i]);
        mapListOPHSupervise.add("\"$i\":$jsonString");
      }

      for (int i = 0; i < _listTBSLuarGrading.length; i++) {
        // _listTBSLuarGrading[i].formType = 2;
        String jsonString = jsonEncode(_listTBSLuarGrading[i]);
        mapListTBSLuarGrading.add("\"$i\":$jsonString");
      }

      var stringListSPB = mapListOPHSupervise.join(",");
      var stringListGrading = mapListTBSLuarGrading.join(",");
      String listSPB = "{$stringListSPB}";
      String listGrading = "{$stringListGrading}";

      String token = await StorageManager.readData("userToken");

      Map<String, dynamic> newMapSPB = jsonDecode(listSPB);
      Map<String, dynamic> newMapGrading = jsonDecode(listGrading);

      var mapTP = Map<String, dynamic>();
      mapTP = {
        'Supervisi': {
          'T_SPB_Supervisi_Schema_List': newMapSPB,
          'T_Grading_3rd_Party_Schema_List': newMapGrading,
        }
      };
      var epmsData = Map<String, dynamic>();
      var jsonMap = jsonEncode(mapTP);
      epmsData['epms_data'] = jsonMap;
      epmsData['user_token'] = token;
      print(jsonMap);
      var json = jsonEncode(epmsData);
      Directory? tempDir = await getExternalStorageDirectory();
      File fileResult = File('${tempDir?.path}/SupervisiSPB.json')
        ..writeAsString(json);
      return fileResult;
    } else {
      return null;
    }
  }
}

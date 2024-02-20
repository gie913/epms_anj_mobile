import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:epms/base/api/api_configuration.dart';
import 'package:epms/base/api/api_endpoint.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/database/service/database_activity.dart';
import 'package:epms/database/service/database_attendance.dart';
import 'package:epms/database/service/database_cost_control.dart';
import 'package:epms/database/service/database_destination.dart';
import 'package:epms/database/service/database_harvesting_plan.dart';
import 'package:epms/database/service/database_laporan_panen_kemarin.dart';
import 'package:epms/database/service/database_laporan_restan.dart';
import 'package:epms/database/service/database_laporan_spb_kemarin.dart';
import 'package:epms/database/service/database_m_attendance.dart';
import 'package:epms/database/service/database_m_block.dart';
import 'package:epms/database/service/database_m_customer_code.dart';
import 'package:epms/database/service/database_m_division.dart';
import 'package:epms/database/service/database_m_employee.dart';
import 'package:epms/database/service/database_m_estate.dart';
import 'package:epms/database/service/database_m_material.dart';
import 'package:epms/database/service/database_m_tph.dart';
import 'package:epms/database/service/database_m_vendor.dart';
import 'package:epms/database/service/database_m_vra.dart';
import 'package:epms/database/service/database_mc_oph.dart';
import 'package:epms/database/service/database_mc_spb.dart';
import 'package:epms/database/service/database_t_abw.dart';
import 'package:epms/database/service/database_t_user_assignment.dart';
import 'package:epms/model/sync_response_revamp.dart';
import 'package:epms/model/synch_inspection_data.dart';
import 'package:epms/model/synch_inspection_response.dart';
import 'package:flutter/material.dart';

class SynchRepository extends APIConfiguration {
  void doPostSynch(
      BuildContext context, String estateCode, onSuccess, onError) async {
    String baseUrl = await StorageManager.readData("apiServer");
    String userToken = await StorageManager.readData("userToken");
    String? lastSynchTime = await StorageManager.readData("lastSynchTime");
    String? lastSynchDate = await StorageManager.readData("lastSynchDate");
    String? estateCodeSaved = await StorageManager.readData("estateCode");
    String? userRolesSaved = await StorageManager.readData("userRoles");
    try {
      var url = baseUrl + APIEndPoint.SYNCH_ENDPOINT;
      var uri = Uri.parse(url);
      var map = new Map<String, dynamic>();
      map['user_token'] = userToken;
      if (estateCode != estateCodeSaved) {
        deleteMasterData(context);
      } else {
        if (userRolesSaved == "Supervisi_spb") {
          deleteMasterData(context);
        } else {
          if (lastSynchDate != null) {
            map['last_synch_date'] = lastSynchDate;
          }
          if (lastSynchTime != null) {
            map['last_synch_time'] = lastSynchTime;
          }
        }
      }

      var response = await ioClient!.post(
        uri,
        body: map,
      );
      // http.Response response = await http.post(
      //   uri,
      //   body: map,
      // );
      SynchResponse synchResponse =
          SynchResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        onSuccess(context, synchResponse);
      } else {
        onError(context, json.decode(response.body)['message']);
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

  void synchInspection(
    BuildContext context,
    Function(BuildContext context, SynchInspectionData data) onSuccess,
    Function(BuildContext context, String errorMessage) onError,
  ) async {
    String inspectionToken = await StorageManager.readData("inspectionToken");
    log('cek inspectionToken : $inspectionToken');

    try {
      var headers = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $inspectionToken'
      };

      // var urlSynchInspectionDev =
      //     'https://etrace-dev.anj-group.co.id/inspection/public/index.php/api/v1/synch';
      var urlSynchInspectionProd =
          'https://inspection.anj-group.co.id/public/index.php/api/v1/synch';
      var responseSynchInspection = await ioClient!
          .get(Uri.parse(urlSynchInspectionProd), headers: headers);
      log('cek url : $urlSynchInspectionProd');
      log('cek response synch inspection : ${responseSynchInspection.body}');
      SynchInspectionResponse res = SynchInspectionResponse.fromJson(
          jsonDecode(responseSynchInspection.body));

      if (res.success) {
        onSuccess(context, res.data);
      } else {
        onError(context, res.message);
      }
    } on SocketException {
      log('cek error synch inspection : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on HttpException {
      log('cek error synch inspection : Tidak Ada Koneksi Internet');
      onError(context, 'Tidak Ada Koneksi Internet');
    } on FormatException {
      log('cek error synch inspection : Response Format Gagal');
      onError(context, 'Response Format Gagal');
    } catch (exception) {
      log('cek error synch inspection : $exception');
      onError(context, exception.toString());
      rethrow;
    }
  }

  Future<bool> deleteMasterData(BuildContext context) async {
    try {
      StorageManager.deleteData("lastSynchTime");
      StorageManager.deleteData("lastSynchDate");
      StorageManager.deleteData("estateCode");
      DatabaseMEmployeeSchema().deleteMEmployeeSchema();
      DatabaseMActivitySchema().deleteMActivitySchema();
      DatabaseMCOPHSchema().deleteMCOPHSchema();
      DatabaseMCSPBCardSchema().deleteMCSPBCardSchema();
      DatabaseMCostControlSchema().deleteMCostControlSchema();
      DatabaseMCustomerCodeSchema().deleteMCustomerCodeSchema();
      DatabaseMDivisionSchema().deleteMDivisionSchema();
      DatabaseMDestinationSchema().deleteMDestinationSchema();
      DatabaseMMaterialSchema().deleteMMaterialSchema();
      DatabaseMTPHSchema().deleteMTPHSchema();
      DatabaseMVRASchema().deleteMVRASchema();
      DatabaseTUserAssignment().deleteEmployeeTUserAssignment();
      DatabaseLaporanPanenKemarin().deleteLaporanPanenKemarin();
      DatabaseTABWSchema().deleteTABWSchema();
      DatabaseTHarvestingPlan().deleteTHarvestingPlan();
      DatabaseLaporanRestan().deleteLaporanRestan();
      DatabaseLaporanSPBKemarin().deleteLaporanSPBKemarin();
      DatabaseMVendorSchema().deleteMVendorSchema();
      DatabaseMEstateSchema().deleteMEstateSchema();
      DatabaseAttendance().deleteEmployeeAttendance();
      DatabaseMAttendance().deleteEmployeeAttendance();
      DatabaseMBlockSchema().deleteMBlockSchema();
      return true;
    } catch (e) {
      return false;
    }
  }
}

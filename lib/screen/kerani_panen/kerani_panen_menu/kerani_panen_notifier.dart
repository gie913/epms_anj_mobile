import 'dart:convert';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/database/service/database_attendance.dart';
import 'package:epms/database/service/database_oph.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/supervisor.dart';
import 'package:epms/model/t_attendance_schema.dart';
import 'package:epms/screen/home/home_notifier.dart';
import 'package:epms/screen/upload/upload_image_repository.dart';
import 'package:epms/screen/upload/upload_oph_repository.dart';
import 'package:flutter/material.dart';

class KeraniPanenNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  doUpload() async {
    _dialogService.popDialog();
    List<OPH> _listOPH = await DatabaseOPH().selectOPH();
    List<TAttendanceSchema> _listAttendance =
        await DatabaseAttendance().selectEmployeeAttendance();

    if (_listOPH.isNotEmpty) {
      _dialogService.showLoadingDialog(title: "Upload OPH");
      List<String> mapListOPH = [];
      List<String> mapListAttendance = [];

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
      UploadOPHRepository().doPostUploadOPH(
          listOPH, listAttendance, onSuccessUploadOPH, onErrorUploadOPH);
    } else {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Upload Data",
          "Belum Ada OPH yang dibuat");
    }
  }

  onSuccessUploadOPH(response) {
    uploadImage(_navigationService.navigatorKey.currentContext!);
  }

  uploadImage(BuildContext context) async {
    List<OPH> listOPH = await DatabaseOPH().selectOPH();
    for (int i = 0; i < listOPH.length; i++) {
      UploadImageOPHRepository().doUploadPhoto(context, listOPH[i].ophPhoto!,
          listOPH[i].ophId!, "oph", onSuccessUploadImage, onErrorUploadImage);
    }
    DatabaseOPH().deleteOPH();
    _dialogService.popDialog();
    FlushBarManager.showFlushBarSuccess(
        _navigationService.navigatorKey.currentContext!,
        "Upload Data",
        "Berhasil mengupload data");
  }

  onErrorUploadOPH(String response) {
    _dialogService.popDialog();
    FlushBarManager.showFlushBarWarning(
        _navigationService.navigatorKey.currentContext!,
        "Upload Data",
        "Gagal mengupload data");
  }

  onSuccessUploadImage(BuildContext context, response) {
    print("Success Upload Image");
  }

  onErrorUploadImage(BuildContext context, String response) {
    _dialogService.popDialog();
    FlushBarManager.showFlushBarWarning(
        _navigationService.navigatorKey.currentContext!,
        "Upload Foto",
        "Gagal mengupload foto");
  }

  onLogOutClicked() {
    _dialogService.showNoOptionDialog(
        title: "Log Out",
        subtitle: "Anda yakin ingin Log Out",
        onPress: HomeNotifier().doLogOut);
  }

  onClickedMenu(BuildContext context, List<String> harvesterMenuEntries,
      int index) async {
    String dateNow = TimeManager.dateWithDash(DateTime.now());
    String dateLogin = await StorageManager.readData("lastSynchDate");
    switch (harvesterMenuEntries[index - 2].toUpperCase()) {
      case "ABSENSI":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.ATTENDANCE_PAGE);
        } else {
          dialogReLogin();
        }
        break;
      case "BUAT FORM OPH":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.OPH_FORM_PAGE);
        } else {
          dialogReLogin();
        }
        break;
      case "RIWAYAT OPH":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.OPH_HISTORY_PAGE, arguments: 'LIHAT');
        } else {
          dialogReLogin();
        }
        break;
      case "RENCANA PANEN HARI INI":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.HARVEST_PLAN);
        } else {
          dialogReLogin();
        }
        break;
      case "LAPORAN PANEN HARIAN":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.PANEN_KEMARIN);
        } else {
          dialogReLogin();
        }
        break;
      case "LAPORAN RESTAN HARI INI":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.RESTAN_REPORT, arguments: 'LIHAT');
        } else {
          dialogReLogin();
        }
        break;
      case "ADMINISTRASI OPH":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.ADMIN_OPH);
        } else {
          dialogReLogin();
        }
        break;
      case "BACA KARTU OPH":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.OPH_DETAIL_PAGE,
              arguments: {"method": "BACA", "oph": OPH(), "restan": false});
        } else {
          dialogReLogin();
        }
        break;
      case "UPLOAD DATA":
        _dialogService.showOptionDialog(
            title: "Upload Data",
            subtitle: "Anda yakin ingin mengupload data?",
            buttonTextYes: "Ya",
            buttonTextNo: "Tidak",
            onPressYes: doUpload,
            onPressNo: _dialogService.popDialog);
        break;
      case "KELUAR":
        _dialogService.showOptionDialog(
            title: "Log Out",
            subtitle: "Anda yakin ingin Log Out?",
            buttonTextYes: "Ya",
            buttonTextNo: "Tidak",
            onPressYes: HomeNotifier().doLogOut,
            onPressNo: _dialogService.popDialog);
        break;
    }
  }

  dialogReLogin() {
    _dialogService.showNoOptionDialog(
        title: "Anda harus login ulang",
        subtitle: "untuk melanjutkan transaksi",
        onPress: _dialogService.popDialog);
  }

  showDialogSupervisi(Supervisor supervisor) {
    _dialogService.showSupervisorDialog(
        supervisor: supervisor, onPress: _dialogService.popDialog);
  }

  navigateToSupervisionForm() {
    _navigationService.push(Routes.SUPERVISOR_FORM_PAGE, arguments: "Home");
  }
}

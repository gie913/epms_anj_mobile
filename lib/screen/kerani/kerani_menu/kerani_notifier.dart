import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/connection_manager.dart';
import 'package:epms/common_manager/delete_master.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/file_manager.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/service/database_attendance.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_oph.dart';
import 'package:epms/database/service/database_spb.dart';
import 'package:epms/database/service/database_spb_detail.dart';
import 'package:epms/database/service/database_spb_loader.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_detail.dart';
import 'package:epms/model/spb_loader.dart';
import 'package:epms/model/supervisor.dart';
import 'package:epms/model/sync_response_revamp.dart';
import 'package:epms/model/t_attendance_schema.dart';
import 'package:epms/screen/home/home_notifier.dart';
import 'package:epms/screen/kerani/kerani_menu/kerani_repository.dart';
import 'package:epms/screen/synch/synch_repository.dart';
import 'package:epms/screen/upload/upload_image_repository.dart';
import 'package:epms/screen/upload/upload_oph_repository.dart';
import 'package:epms/screen/upload/upload_spb_repository.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';
import 'package:provider/provider.dart';

class KeraniNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  doUploadOph() async {
    _dialogService.popDialog();
    List<OPH> _listOPH = await DatabaseOPH().selectOPH();
    List<TAttendanceSchema> _listAttendance =
        await DatabaseAttendance().selectEmployeeAttendance();
    if (_listOPH.isNotEmpty) {
      List<OPH> photo = await DatabaseOPH().selectOPHPhoto();
      if (photo.isNotEmpty) {
        onErrorUploadImageEmpty(_navigationService.navigatorKey.currentContext!,
            "${photo[0].ophId}");
      } else {
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
      }
    } else if (_listAttendance.isNotEmpty) {
      _dialogService.showLoadingDialog(title: "Upload OPH");
      List<String> mapListAttendance = [];
      List<TAttendanceSchema> _listAttendance =
          await DatabaseAttendance().selectEmployeeAttendance();
      for (int i = 0; i < _listAttendance.length; i++) {
        String jsonString = jsonEncode(_listAttendance[i]);
        mapListAttendance.add("\"$i\":$jsonString");
      }
      var stringListAttendance = mapListAttendance.join(",");
      String listOPH = "{}";
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

  doUploadSpb() async {
    _dialogService.popDialog();
    List<SPB> _listSPB = await DatabaseSPB().selectSPB();
    List<SPBDetail> _listSPBDetail =
        await DatabaseSPBDetail().selectSPBDetail();
    List<SPBLoader> _listSPBLoader =
        await DatabaseSPBLoader().selectSPBLoader();
    if (_listSPB.isNotEmpty) {
      List<String> mapListSPB = [];
      List<String> mapListSPBDetail = [];
      List<String> mapListSPBLoader = [];

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

      _dialogService.showLoadingDialog(title: "Mengupload SPB");
      UploadSPBRepository().doPostUploadSPB(
          _navigationService.navigatorKey.currentContext!,
          listSPB,
          listSPBDetail,
          listSPBLoader,
          onSuccessUploadSPB,
          onErrorUploadSPB);
    } else {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Upload SPB",
          "Belum ada SPB dibuat");
    }
  }

  doUpload() async {
    _dialogService.popDialog();
    List<OPH> _listOPH = await DatabaseOPH().selectOPH();
    List<TAttendanceSchema> _listAttendance =
        await DatabaseAttendance().selectEmployeeAttendance();

    List<SPB> _listSPB = await DatabaseSPB().selectSPB();
    List<SPBDetail> _listSPBDetail =
        await DatabaseSPBDetail().selectSPBDetail();
    List<SPBLoader> _listSPBLoader =
        await DatabaseSPBLoader().selectSPBLoader();

    if (_listOPH.isNotEmpty && _listSPB.isNotEmpty) {
      _dialogService.showLoadingDialog(title: "Upload Data Kerani");
      // PROSES BC
      List<OPH> photo = await DatabaseOPH().selectOPHPhoto();
      String listOPH = "";
      String listAttendance = "";
      if (photo.isNotEmpty) {
        onErrorUploadImageEmpty(_navigationService.navigatorKey.currentContext!,
            "${photo[0].ophId}");
      } else {
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
        listOPH = "{$stringListOPH}";
        listAttendance = "{$stringListAttendance}";
      }

      // PROSES TP
      List<String> mapListSPB = [];
      List<String> mapListSPBDetail = [];
      List<String> mapListSPBLoader = [];

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

      KeraniRepository().uploadData(
        listOPH,
        listAttendance,
        listSPB,
        listSPBDetail,
        listSPBLoader,
        onSuccessUploadKerani,
        onErrorUploadKerani,
      );
    } else {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Upload Data",
          "Belum Ada OPH dan SPB yang dibuat");
    }
  }

  onSuccessUploadOPH(response) {
    print('response success upload data OPH : $response');
    uploadImageOPH(_navigationService.navigatorKey.currentContext!);
  }

  onErrorUploadOPH(String response) {
    _dialogService.popDialog();
    FlushBarManager.showFlushBarWarning(
        _navigationService.navigatorKey.currentContext!,
        "Upload OPH",
        response);
  }

  onSuccessUploadSPB(BuildContext context, response) {
    uploadImageSPB(context);
  }

  onErrorUploadSPB(BuildContext context, String response) {
    print(response);
    _dialogService.popDialog();
    FlushBarManager.showFlushBarError(
        _navigationService.navigatorKey.currentContext!,
        "Upload SPB",
        response);
  }

  onSuccessUploadKerani(response) {
    print('response success upload data kerani : $response');
    uploadImageOPH(_navigationService.navigatorKey.currentContext!);
    uploadImageSPB(_navigationService.navigatorKey.currentContext!);
  }

  onErrorUploadKerani(response) {
    print('response failed upload data kerani : $response');
    print('$response');
    _dialogService.popDialog();
    FlushBarManager.showFlushBarWarning(
        _navigationService.navigatorKey.currentContext!,
        "Upload Data",
        response);
  }

  uploadImageOPH(BuildContext context) async {
    List<OPH> listOPH = await DatabaseOPH().selectOPH();
    for (int i = 0; i < listOPH.length; i++) {
      if (listOPH[i].ophPhoto != null) {
        UploadImageOPHRepository().doUploadPhoto(context, listOPH[i].ophPhoto!,
            listOPH[i].ophId!, "oph", onSuccessUploadImage, onErrorUploadImage);
      }
    }
    DatabaseOPH().deleteOPH();
    _dialogService.popDialog();
    FlushBarManager.showFlushBarSuccess(
        _navigationService.navigatorKey.currentContext!,
        "Upload Data",
        "Berhasil mengupload data");
    // DatabaseLaporanPanenKemarin().deleteLaporanPanenKemarin();
    // SynchNotifier().doSynchMasterDataBackground(context);
  }

  uploadImageSPB(BuildContext context) async {
    List<SPB> listSPB = await DatabaseSPB().selectSPB();
    for (int i = 0; i < listSPB.length; i++) {
      if (listSPB[i].spbPhoto != null) {
        UploadImageOPHRepository().doUploadPhoto(context, listSPB[i].spbPhoto!,
            listSPB[i].spbId!, "spb", onSuccessUploadImage, onErrorUploadImage);
      }
    }
    DatabaseSPB().deleteSPB();
    DatabaseSPBDetail().deleteSPBDetail();
    DatabaseSPBLoader().deleteSPBLoader();
    _dialogService.popDialog();
    FlushBarManager.showFlushBarSuccess(
        context, "Upload SPB", "Berhasil mengupload data");
  }

  onSuccessUploadImage(BuildContext context, response) {
    print("Success Upload Image");
  }

  onErrorUploadImage(BuildContext context, String response) {
    print('error upload image SPB');
    _dialogService.popDialog();
    // FlushBarManager.showFlushBarWarning(
    //     _navigationService.navigatorKey.currentContext!,
    //     "Upload Foto",
    //     "Gagal mengupload foto");
  }

  onErrorUploadImageEmpty(BuildContext context, String response) {
    _dialogService.popDialog();
    FlushBarManager.showFlushBarWarning(
        _navigationService.navigatorKey.currentContext!,
        "Upload Foto",
        "Ada OPH yang tidak ada foto, ID OPH $response");
  }

  onLogOutClicked() {
    _dialogService.showNoOptionDialog(
        title: "Log Out",
        subtitle: "Anda yakin ingin Log Out",
        onPress: HomeNotifier().doLogOut);
  }

  onClickedMenu(BuildContext context, String menu) async {
    final now = DateTime.now();
    String dateNow = TimeManager.dateWithDash(now);
    String? dateLogin = await StorageManager.readData("lastSynchDate");
    final dateLoginParse = DateTime.parse(dateLogin!);

    switch (menu.toUpperCase()) {
      case "INSPECTION":
        if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          await _navigationService.push(Routes.INSPECTION);
          await context.read<HomeNotifier>().updateCountInspection();
        }
        break;
      case "ABSENSI":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.ATTENDANCE_PAGE);
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "BUAT FORM OPH":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.OPH_FORM_PAGE);
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "RIWAYAT OPH":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.OPH_HISTORY_PAGE, arguments: 'LIHAT');
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "BACA KARTU OPH":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.OPH_DETAIL_PAGE,
              arguments: {"method": "BACA", "oph": OPH(), "restan": false});
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "RENCANA PANEN HARI INI":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.HARVEST_PLAN);
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "BUAT FORM SPB":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.SPB_FORM_PAGE);
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "RIWAYAT SPB":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.SPB_HISTORY_PAGE, arguments: "DETAIL");
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "BACA KARTU SPB":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.SPB_DETAIL_PAGE,
              arguments: {"spb": SPB(), "method": 'BACA'});
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "LAPORAN PANEN HARIAN":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.PANEN_KEMARIN);
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "LAPORAN SPB KEMARIN":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.REPORT_SPB_KEMARIN);
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "LAPORAN RESTAN HARI INI":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.RESTAN_REPORT, arguments: 'LIHAT');
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "ADMINISTRASI OPH":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.ADMIN_OPH);
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "ADMINISTRASI SPB":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.ADMIN_SPB);
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "UPLOAD DATA OPH":
        _dialogService.showOptionDialog(
            title: "Upload Data",
            subtitle: "Anda yakin ingin mengupload data?",
            buttonTextYes: "Ya",
            buttonTextNo: "Tidak",
            onPressYes: doUploadOph,
            onPressNo: _dialogService.popDialog);
        break;
      case "UPLOAD DATA SPB":
        _dialogService.showOptionDialog(
            title: "Upload Data",
            subtitle: "Anda yakin ingin mengupload data?",
            buttonTextYes: "Ya",
            buttonTextNo: "Tidak",
            onPressYes: doUploadSpb,
            onPressNo: _dialogService.popDialog);
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

  dialogSettingDateTime() {
    _dialogService.showNoOptionDialog(
      title: "Format Tanggal Salah",
      subtitle: "Mohon sesuaikan kembali tanggal di handphone Anda",
      onPress: () {
        _dialogService.popDialog();
        OpenSettings.openDateSetting();
      },
    );
  }

  showDialogSupervisi(Supervisor supervisor) {
    _dialogService.showSupervisorDialog(
        supervisor: supervisor, onPress: _dialogService.popDialog);
  }

  reSynch() {
    _dialogService.showOptionDialog(
        title: "Sinkronisasi Ulang",
        subtitle: "Anda yakin ingin sync ulang?",
        buttonTextYes: "Ya",
        buttonTextNo: "Tidak",
        onPressYes: onPressYes,
        onPressNo: onPressNo);
  }

  onSuccessSynch(BuildContext context, SynchResponse synchResponse) async {
    _dialogService.popDialog();
    final isLoginInspectionSuccess =
        await StorageManager.readData('is_login_inspection_success');

    if (isLoginInspectionSuccess == true) {
      final dataMyInspection =
          await DatabaseTicketInspection.selectDataNeedUpload();
      final dataToDoInspection =
          await DatabaseTodoInspection.selectDataNeedUpload();

      final totalDataInspectionUnUpload =
          dataMyInspection.length + dataToDoInspection.length;

      if (totalDataInspectionUnUpload != 0) {
        FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Gagal Sinkronisasi Ulang",
          "Anda memiliki inspection yang belum di upload",
        );
        return;
      }

      DatabaseHelper().deleteMasterDataInspectionReSynch();
      DeleteMaster().deleteMasterData().then((value) {
        if (value) {
          _navigationService.push(Routes.SYNCH_PAGE);
        }
      });
    } else {
      DeleteMaster().deleteMasterData().then((value) {
        if (value) {
          _navigationService.push(Routes.SYNCH_PAGE);
        }
      });
    }
  }

  onErrorSynch(BuildContext context, String response) {
    _dialogService.popDialog();
    FlushBarManager.showFlushBarWarning(
        _navigationService.navigatorKey.currentContext!,
        "Koneksi",
        "Tidak terkoneksi jaringan lokal");
  }

  navigateToSupervisionForm() {
    _navigationService.push(Routes.SUPERVISOR_FORM_PAGE, arguments: "Home");
  }

  onPressYes() {
    _dialogService.popDialog();
    ConnectionManager().checkConnection().then((value) {
      if (value == ConnectivityResult.none) {
        FlushBarManager.showFlushBarWarning(
            _navigationService.navigatorKey.currentContext!,
            "Koneksi",
            "Tidak ada koneksi internet");
      } else {
        DatabaseMConfig().selectMConfig().then((value) {
          _dialogService.showLoadingDialog(title: "Mohon tunggu");
          SynchRepository().synchEpms(
              _navigationService.navigatorKey.currentContext!,
              value.estateCode!,
              onSuccessSynch,
              onErrorSynch);
        });
      }
    });
  }

  onPressNo() {
    _dialogService.popDialog();
  }

  exportJson(BuildContext context) async {
    File? fileExport = await FileManagerJson().writeFileJsonKerani();
    if (fileExport != null) {
      FlushBarManager.showFlushBarSuccess(
          context, "Export Json Berhasil", "${fileExport.path}");
    } else {
      FlushBarManager.showFlushBarWarning(
          context, "Export Json", "Belum ada transaksi OPH dan SPB");
    }
  }
}

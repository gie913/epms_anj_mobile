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
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_oph_supervise.dart';
import 'package:epms/database/service/database_oph_supervise_ancak.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/oph_supervise.dart';
import 'package:epms/model/oph_supervise_ancak.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/sync_response_revamp.dart';
import 'package:epms/screen/home/home_notifier.dart';
import 'package:epms/screen/synch/synch_repository.dart';
import 'package:epms/screen/upload/upload_image_repository.dart';
import 'package:epms/screen/upload/upload_supervisi_repository.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';
import 'package:provider/provider.dart';

class SupervisorNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  doUpload() async {
    _dialogService.popDialog();
    List<OPHSupervise> _listOPHSupervise =
        await DatabaseOPHSupervise().selectOPHSupervise();
    List<OPHSuperviseAncak> _listOPHAncak =
        await DatabaseOPHSuperviseAncak().selectOPHSuperviseAncak();

    List<String> mapListOPHSupervise = [];
    List<String> mapListOPHAncak = [];

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
    _dialogService.showLoadingDialog(title: "Upload Supervisi");
    UploadSupervisiRepository().doPostUploadSupervisi(
        _navigationService.navigatorKey.currentContext!,
        listSPB,
        listSPBDetail,
        onSuccessUploadSPB,
        onErrorUploadSPB);
  }

  onSuccessUploadSPB(BuildContext context, response) {
    uploadImage(context);
  }

  onErrorUploadSPB(BuildContext context, String response) {
    _dialogService.popDialog();
    FlushBarManager.showFlushBarError(
        context, "Upload Supervisi", "Gagal mengupload data");
  }

  uploadImage(BuildContext context) async {
    List<OPHSupervise> listSPB =
        await DatabaseOPHSupervise().selectOPHSupervise();
    List<OPHSuperviseAncak> listSPBDetail =
        await DatabaseOPHSuperviseAncak().selectOPHSuperviseAncak();
    if (listSPB.isNotEmpty) {
      for (int i = 0; i < listSPB.length; i++) {
        if (listSPB[i].supervisiPhoto != null) {
          UploadImageOPHRepository().doUploadPhoto(
              context,
              listSPB[i].supervisiPhoto!,
              listSPB[i].ophSupervisiId!,
              "oph_supervise",
              onSuccessUploadImage,
              onErrorUploadImage);
        }
      }
    }
    if (listSPBDetail.isNotEmpty) {
      for (int i = 0; i < listSPBDetail.length; i++) {
        if (listSPBDetail[i].supervisiAncakPhoto != null) {
          UploadImageOPHRepository().doUploadPhoto(
              context,
              listSPBDetail[i].supervisiAncakPhoto!,
              listSPBDetail[i].supervisiAncakId!,
              "ancak_supervise",
              onSuccessUploadImage,
              onErrorUploadImage);
        }
      }
    }
    DatabaseOPHSupervise().deleteOPHSupervise();
    DatabaseOPHSuperviseAncak().deleteOPHSuperviseAncak();
    _dialogService.popDialog();
    FlushBarManager.showFlushBarSuccess(
        context, "Upload Supervisi", "Berhasil mengupload data");
  }

  onSuccessUploadImage(BuildContext context, response) {}

  onErrorUploadImage(BuildContext context, String response) {
    _dialogService.popDialog();
    FlushBarManager.showFlushBarError(
        context, "Upload Foto Supervisi", "Gagal mengupload data");
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

  void onClickMenu(BuildContext context, String menu) async {
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
      case "KELUAR":
        _dialogService.showOptionDialog(
            title: "Log Out",
            subtitle: "Anda yakin ingin Log Out?",
            buttonTextYes: "Ya",
            buttonTextNo: "Tidak",
            onPressYes: HomeNotifier().doLogOut,
            onPressNo: _dialogService.popDialog);
        break;
      case "SUPERVISI PANEN":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.OPH_SUPERVISI_FORM_PAGE);
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "SUPERVISI ANCAK PANEN":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.OPH_SUPERVISI_ANCAK_FORM_PAGE);
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
      case "LAPORAN SUPERVISI PANEN":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.OPH_SUPERVISI_HISTORY_PAGE);
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "LAPORAN SUPERVISI ANCAK PANEN":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.OPH_SUPERVISI_ANCAK_HISTORY_PAGE);
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "LAPORAN RESTAN HARI INI":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.RESTAN_REPORT, arguments: "LIHAT");
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
      case "RENCANA PANEN HARI INI":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.HARVEST_PLAN);
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "LIHAT WORKPLAN":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.WORK_PLAN);
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
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
    }
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
          SynchRepository().doPostSynch(
              _navigationService.navigatorKey.currentContext!,
              value.estateCode!,
              onSuccessSynch,
              onErrorSynch);
        });
      }
    });
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

  onPressNo() {
    _dialogService.popDialog();
  }

  exportJson(BuildContext context) async {
    File? fileExport = await FileManagerJson().writeFileJsonSupervisi();
    if (fileExport != null) {
      FlushBarManager.showFlushBarSuccess(
          context, "Export Json Berhasil", "${fileExport.path}");
    } else {
      FlushBarManager.showFlushBarWarning(
          context, "Export Json", "Belum ada Transaksi Supervisi");
    }
  }
}

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
import 'package:epms/database/service/database_spb_supervise.dart';
import 'package:epms/database/service/database_tbs_luar.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_supervise.dart';
import 'package:epms/model/sync_response_revamp.dart';
import 'package:epms/model/tbs_luar.dart';
import 'package:epms/screen/home/home_notifier.dart';
import 'package:epms/screen/synch/synch_repository.dart';
import 'package:epms/screen/upload/upload_image_repository.dart';
import 'package:epms/screen/upload/upload_supervisi_spb_repository.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';
import 'package:provider/provider.dart';

class SupervisorSPBNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

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

  doUpload() async {
    _dialogService.popDialog();
    List<SPBSupervise> _listOPHSupervise =
        await DatabaseSPBSupervise().selectSPBSupervise();
    List<TBSLuar> _listTBSLuarGrading = await DatabaseTBSLuar().selectTBSLuar();

    if (_listOPHSupervise.isNotEmpty || _listTBSLuarGrading.isNotEmpty) {
      List<String> mapListOPHSupervise = [];
      List<String> mapListTBSLuarGrading = [];

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

      _dialogService.showLoadingDialog(title: "Upload Supervisi SPB");
      UploadSupervisiSPBRepository().doPostUploadSupervisiSPB(
          _navigationService.navigatorKey.currentContext!,
          listSPB,
          listGrading,
          onSuccessUploadSPB,
          onErrorUploadSPB);
    } else {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Upload Supervisi SPB",
          "Tidak ada supervisi SPB yang dibuat");
    }
  }

  onSuccessUploadSPB(BuildContext context, response) {
    uploadImage(context);
  }

  onErrorUploadSPB(BuildContext context, String response) {
    _dialogService.popDialog();
    FlushBarManager.showFlushBarError(
        context, "Upload Supervisi SPB Gagal", response);
  }

  uploadImage(BuildContext context) async {
    List<SPBSupervise> listSPB =
        await DatabaseSPBSupervise().selectSPBSupervise();
    List<TBSLuar> listTBSLuar = await DatabaseTBSLuar().selectTBSLuar();
    for (int i = 0; i < listSPB.length; i++) {
      if (listSPB[i].supervisiSpbPhoto != null) {
        UploadImageOPHRepository().doUploadPhoto(
            context,
            listSPB[i].supervisiSpbPhoto!,
            listSPB[i].spbSuperviseId!,
            "spb_supervise",
            onSuccessUploadImage,
            onErrorUploadImage);
      }
    }
    for (int i = 0; i < listTBSLuar.length; i++) {
      if (listTBSLuar[i].gradingPhoto != null) {
        UploadImageOPHRepository().doUploadPhoto(
            context,
            listTBSLuar[i].gradingPhoto!,
            listTBSLuar[i].spdID!,
            "spb_supervise",
            onSuccessUploadImage,
            onErrorUploadImage);
      }
    }
    DatabaseSPBSupervise().deleteSPBSupervise();
    DatabaseTBSLuar().deleteTBSLuar();
    _dialogService.popDialog();
    FlushBarManager.showFlushBarSuccess(
        context, "Upload Supervisi SPB", "Berhasil mengupload data");
  }

  onSuccessUploadImage(BuildContext context, response) {
    print("Success Upload Image");
  }

  onErrorUploadImage(BuildContext context, String response) {
    _dialogService.popDialog();
    FlushBarManager.showFlushBarError(
        context, "Upload Foto Supervisi SPB", "Gagal mengupload data");
  }

  onClickMenu(BuildContext context, String menu) async {
    final now = DateTime.now();
    String dateNow = TimeManager.dateWithDash(now);
    String? dateLogin = await StorageManager.readData("lastSynchDate");
    final dateLoginParse = DateTime.parse(dateLogin!);

    switch (menu.toUpperCase()) {
      case 'INSPECTION':
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
      case "SUPERVISI TBS LUAR":
        // if (dateLogin == dateNow) {
        _navigationService.push(Routes.TBS_LUAR_FORM_PAGE);
        // } else {
        //   dialogReLogin();
        // }
        break;
      case "HISTORY GRADING TBS LUAR":
        // if (dateLogin == dateNow) {
        _navigationService.push(Routes.TBS_LUAR_HISTORY_PAGE);
        // } else {
        //   dialogReLogin();
        // }
        break;
      case "BACA KARTU TBS LUAR":
        // if (dateLogin == dateNow) {
        _navigationService.push(Routes.TBS_LUAR_DETAIL_PAGE,
            arguments: {"tbs_luar": TBSLuar(), "method": 'BACA'});
        // } else {
        //   dialogReLogin();
        // }
        break;
      case "SUPERVISI SPB":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.SPB_SUPERVISI_FORM_PAGE);
        } else if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          dialogReLogin();
        }
        break;
      case "HISTORY SUPERVISI SPB":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.SPB_SUPERVISI_HISTORY_PAGE);
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
    File? fileExport = await FileManagerJson().writeFileJsonSupervisiSPB();
    if (fileExport != null) {
      FlushBarManager.showFlushBarSuccess(
          context, "Export Json Berhasil", "${fileExport.path}");
    } else {
      FlushBarManager.showFlushBarWarning(
          context, "Export Json", "Belum ada Transaksi Supervisi SPB");
    }
  }
}

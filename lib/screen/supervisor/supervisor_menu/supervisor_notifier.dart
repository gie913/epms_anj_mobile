import 'dart:convert';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/database/service/database_oph_supervise.dart';
import 'package:epms/database/service/database_oph_supervise_ancak.dart';
import 'package:epms/model/menu_entities.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/oph_supervise.dart';
import 'package:epms/model/oph_supervise_ancak.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/screen/home/home_notifier.dart';
import 'package:epms/screen/upload/upload_image_repository.dart';
import 'package:epms/screen/upload/upload_supervisi_repository.dart';
import 'package:flutter/material.dart';

class SupervisorNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  doUpload() async {
    List<OPHSupervise> _listOPHSupervise =
        await DatabaseOPHSupervise().selectOPHSupervise();
    List<OPHSuperviseAncak> _listOPHAncak =
        await DatabaseOPHSuperviseAncak().selectOPHSuperviseAncak();

    List<String> mapListOPHSupervise = [];
    List<String> mapListOPHAncak = [];

    for (int i = 0; i < _listOPHSupervise.length; i++) {
      String jsonString = jsonEncode(_listOPHSupervise[i]);
      mapListOPHSupervise.add("\"$i\":$jsonString");
    }
    for (int i = 0; i < _listOPHAncak.length; i++) {
      String jsonString = jsonEncode(_listOPHAncak[i]);
      mapListOPHAncak.add("\"$i\":$jsonString");
    }

    var stringListSPB = mapListOPHSupervise.join(",");
    var stringListSPBDetail = mapListOPHAncak.join(",");
    String listSPB = "{$stringListSPB}";
    String listSPBDetail = "{$stringListSPBDetail}";
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
        context, "Upload SPB", "Gagal mengupload data");
  }

  uploadImage(BuildContext context) async {
    List<OPHSupervise> listSPB =
        await DatabaseOPHSupervise().selectOPHSupervise();
    List<OPHSuperviseAncak> listSPBDetail =
        await DatabaseOPHSuperviseAncak().selectOPHSuperviseAncak();
    for (int i = 0; i < listSPB.length; i++) {
      UploadImageOPHRepository().doUploadPhoto(
          context,
          listSPB[i].supervisiPhoto!,
          listSPB[i].ophSupervisiId!,
          "oph_supervise",
          onSuccessUploadImage,
          onErrorUploadImage);
    }
    for (int i = 0; i < listSPB.length; i++) {
      UploadImageOPHRepository().doUploadPhoto(
          context,
          listSPBDetail[i].supervisiAncakPhoto!,
          listSPBDetail[i].supervisiAncakId!,
          "oph_supervise_ancak",
          onSuccessUploadImage,
          onErrorUploadImage);
    }
    DatabaseOPHSupervise().deleteOPHSupervise();
    DatabaseOPHSuperviseAncak().deleteOPHSuperviseAncak();
    _dialogService.popDialog();
    FlushBarManager.showFlushBarSuccess(
        context, "Upload SPB", "Berhasil mengupload data");
  }

  onSuccessUploadImage(BuildContext context, response) {}

  onErrorUploadImage(BuildContext context, String response) {
    _dialogService.popDialog();
    FlushBarManager.showFlushBarError(
        context, "Upload Foto SPB", "Gagal mengupload data");
  }

  dialogReLogin() {
    _dialogService.showNoOptionDialog(
        title: "Anda harus login ulang",
        subtitle: "untuk melanjutkan transaksi",
        onPress: _dialogService.popDialog);
  }

  void onClickMenu(int index) async {
    String dateNow = TimeManager.dateWithDash(DateTime.now());
    String dateLogin = await StorageManager.readData("lastSynchDate");
    switch (supervisorMenuEntries[index - 2].toUpperCase()) {
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
        } else {
          dialogReLogin();
        }
        break;
      case "SUPERVISI ANCAK PANEN":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.OPH_SUPERVISI_ANCAK_FORM_PAGE);
        } else {
          dialogReLogin();
        }
        break;
      case "BACA KARTU OPH":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.OPH_DETAIL_PAGE,
              arguments: {"method": "BACA", "oph": OPH(), "restan" : false});
        } else {
          dialogReLogin();
        }
        break;
      case "BACA KARTU SPB":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.SPB_DETAIL_PAGE,
              arguments: {"spb": SPB(), "method": 'BACA'});
        } else {
          dialogReLogin();
        }
        break;
      case "LAPORAN SUPERVISI PANEN":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.OPH_SUPERVISI_HISTORY_PAGE);
        } else {
          dialogReLogin();
        }
        break;
      case "LAPORAN SUPERVISI ANCAK PANEN":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.OPH_SUPERVISI_ANCAK_HISTORY_PAGE);
        } else {
          dialogReLogin();
        }
        break;
      case "LAPORAN RESTAN HARI INI":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.RESTAN_REPORT, arguments: "LIHAT");
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
      case "RENCANA PANEN HARI INI":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.HARVEST_PLAN);
        } else {
          dialogReLogin();
        }
        break;
      case "LIHAT WORKPLAN":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.WORK_PLAN);
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
}

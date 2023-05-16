import 'dart:convert';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/database/service/database_spb.dart';
import 'package:epms/database/service/database_spb_detail.dart';
import 'package:epms/database/service/database_spb_loader.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_detail.dart';
import 'package:epms/model/spb_loader.dart';
import 'package:epms/screen/home/home_notifier.dart';
import 'package:epms/screen/upload/upload_image_repository.dart';
import 'package:epms/screen/upload/upload_spb_repository.dart';
import 'package:flutter/material.dart';

class KeraniKirimNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  doUpload() async {
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
      FlushBarManager.showFlushBarError(
          _navigationService.navigatorKey.currentContext!,
          "Upload SPB",
          "Belum ada SPB dibuat");
    }
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
    List<SPB> listSPB = await DatabaseSPB().selectSPB();
    for (int i = 0; i < listSPB.length; i++) {
      UploadImageOPHRepository().doUploadPhoto(context, listSPB[i].spbPhoto!,
          listSPB[i].spbId!, "spb", onSuccessUploadImage, onErrorUploadImage);
    }
    DatabaseSPB().deleteSPB();
    DatabaseSPBDetail().deleteSPBDetail();
    DatabaseSPBLoader().deleteSPBLoader();
  }

  onSuccessUploadImage(BuildContext context, response) {
    _dialogService.popDialog();
    FlushBarManager.showFlushBarSuccess(
        context, "Upload SPB", "Berhasil mengupload data");
  }

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

  onClickMenu(List<String> deliveryMenuEntries, int index) async {
    String dateNow = TimeManager.dateWithDash(DateTime.now());
    String dateLogin = await StorageManager.readData("lastSynchDate");

    switch (deliveryMenuEntries[index - 2].toUpperCase()) {
      case "BUAT FORM SPB":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.SPB_FORM_PAGE);
        } else {
          dialogReLogin();
        }
        break;
      case "RIWAYAT SPB":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.SPB_HISTORY_PAGE, arguments: "DETAIL");
        } else {
          dialogReLogin();
        }
        break;
      case "LAPORAN SPB KEMARIN":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.REPORT_SPB_KEMARIN);
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
      case "BACA KARTU SPB":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.SPB_DETAIL_PAGE,
              arguments: {"spb": SPB(), "method": 'BACA'});
        } else {
          dialogReLogin();
        }
        break;
      case "ADMINISTRASI SPB":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.ADMIN_SPB);
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
}

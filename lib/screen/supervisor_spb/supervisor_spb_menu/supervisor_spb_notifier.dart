import 'dart:convert';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/database/service/database_spb_supervise.dart';
import 'package:epms/model/menu_entities.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_supervise.dart';
import 'package:epms/screen/home/home_notifier.dart';
import 'package:epms/screen/upload/upload_image_repository.dart';
import 'package:epms/screen/upload/upload_supervisi_spb_repository.dart';
import 'package:flutter/material.dart';

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

  doUpload() async {
    List<SPBSupervise> _listOPHSupervise =
        await DatabaseSPBSupervise().selectSPBSupervise();

    List<String> mapListOPHSupervise = [];

    for (int i = 0; i < _listOPHSupervise.length; i++) {
      String jsonString = jsonEncode(_listOPHSupervise[i]);
      mapListOPHSupervise.add("\"$i\":$jsonString");
    }

    var stringListSPB = mapListOPHSupervise.join(",");
    String listSPB = "{$stringListSPB}";
    UploadSupervisiSPBRepository().doPostUploadSupervisiSPB(
        _navigationService.navigatorKey.currentContext!,
        listSPB,
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
    List<SPBSupervise> listSPB =
        await DatabaseSPBSupervise().selectSPBSupervise();
    for (int i = 0; i < listSPB.length; i++) {
      UploadImageOPHRepository().doUploadPhoto(
          context,
          listSPB[i].supervisiSpbPhoto!,
          listSPB[i].spbId!,
          "spb",
          onSuccessUploadImage,
          onErrorUploadImage);
    }
    DatabaseSPBSupervise().deleteSPBSupervise();
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

  onClickMenu(int index) async {
    String dateNow = TimeManager.dateWithDash(DateTime.now());
    String dateLogin = await StorageManager.readData("lastSynchDate");

    switch (supervisorSPBMenuEntries[index - 2].toUpperCase()) {
      case "KELUAR":
        _dialogService.showOptionDialog(
            title: "Log Out",
            subtitle: "Anda yakin ingin Log Out?",
            buttonTextYes: "Ya",
            buttonTextNo: "Tidak",
            onPressYes: HomeNotifier().doLogOut,
            onPressNo: _dialogService.popDialog);
        break;
      case "SUPERVISI SPB":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.SPB_SUPERVISI_FORM_PAGE);
        } else {
          dialogReLogin();
        }
        break;
      case "HISTORY SUPERVISI SPB":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.SPB_SUPERVISI_HISTORY_PAGE);
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

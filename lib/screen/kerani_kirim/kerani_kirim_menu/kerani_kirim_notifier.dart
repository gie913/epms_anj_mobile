import 'dart:convert';
import 'dart:developer';
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
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_spb.dart';
import 'package:epms/database/service/database_spb_detail.dart';
import 'package:epms/database/service/database_spb_loader.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_detail.dart';
import 'package:epms/model/spb_loader.dart';
import 'package:epms/model/sync_response_revamp.dart';
import 'package:epms/screen/home/home_notifier.dart';
import 'package:epms/screen/synch/synch_repository.dart';
import 'package:epms/screen/upload/upload_image_repository.dart';
import 'package:epms/screen/upload/upload_spb_repository.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';
import 'package:provider/provider.dart';

class KeraniKirimNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  Future<void> doUpload() async {
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

      // typeTBS = 1 Inti, 2 Plasma, 3 Campuran
      int typeTBS = ValueService.checkTypeTBS(_listSPBDetail);
      List<String> mapListSPBInti = [];
      List<String> mapListSPBPlasma = [];
      List<String> mapListSPBDetailInti = [];
      List<String> mapListSPBDetailPlasma = [];

      List<SPBDetail> listSPBDetailInti = [];
      List<SPBDetail> listSPBDetailPlasma = [];

      String mostEstateCodeInti = '';
      String mostEstateCodePlasma = '';

      String mostDivisionCodeInti = '';
      String mostDivisionCodePlasma = '';

      for (int i = 0; i < _listSPBDetail.length; i++) {
        if (typeTBS == 3) {
          if (ValueService.plasmaValidator(_listSPBDetail[i].ophEstateCode!) ==
              1) {
            SPBDetail spbDetailTemp = _listSPBDetail[i];
            spbDetailTemp.spbId = '${spbDetailTemp.spbId}_2';
            listSPBDetailInti.add(spbDetailTemp);
            String jsonString = jsonEncode(spbDetailTemp);
            mapListSPBDetailInti
                .add("\"${mapListSPBDetailInti.length}\":$jsonString");
          } else {
            listSPBDetailPlasma.add(_listSPBDetail[i]);
            String jsonString = jsonEncode(_listSPBDetail[i]);
            mapListSPBDetailPlasma
                .add("\"${mapListSPBDetailPlasma.length}\":$jsonString");
          }
        }

        String jsonString = jsonEncode(_listSPBDetail[i]);
        mapListSPBDetail.add("\"$i\":$jsonString");
      }
      log('cek mapListSPBDetail : $mapListSPBDetail');
      log('cek mapListSPBDetailInti : $mapListSPBDetailInti');
      log('cek listSPBDetailPlasma : $listSPBDetailPlasma');

      // Check Most Estate & Division Inti
      int maxCountEstateInti = 0;
      for (int i = 0; i < listSPBDetailInti.length; i++) {
        int countEstateInti = 0;
        for (int j = 0; j < listSPBDetailInti.length; j++) {
          if (listSPBDetailInti[i].ophEstateCode ==
              listSPBDetailInti[j].ophEstateCode) {
            countEstateInti++;
          }
        }

        if (countEstateInti > maxCountEstateInti) {
          maxCountEstateInti = countEstateInti;
          mostEstateCodeInti = listSPBDetailInti[i].ophEstateCode!;
        }
      }

      List<SPBDetail> listSPBDetailMostEstateInti = [];
      for (int i = 0; i < listSPBDetailInti.length; i++) {
        if (listSPBDetailInti[i].ophEstateCode! == mostEstateCodeInti) {
          listSPBDetailMostEstateInti.add(listSPBDetailInti[i]);
        }
      }

      int maxCountDivisionInti = 0;
      for (int i = 0; i < listSPBDetailMostEstateInti.length; i++) {
        int countDivisionInti = 0;
        for (int j = 0; j < listSPBDetailMostEstateInti.length; j++) {
          if (listSPBDetailMostEstateInti[i].ophDivisionCode ==
              listSPBDetailMostEstateInti[j].ophDivisionCode) {
            countDivisionInti++;
          }
        }

        if (countDivisionInti > maxCountDivisionInti) {
          maxCountDivisionInti = countDivisionInti;
          mostDivisionCodeInti =
              listSPBDetailMostEstateInti[i].ophDivisionCode!;
        }
      }

      // Check Most Estate & Division Plasma
      int maxCountEstatePlasma = 0;
      for (int i = 0; i < listSPBDetailPlasma.length; i++) {
        int countEstatePlasma = 0;
        for (int j = 0; j < listSPBDetailPlasma.length; j++) {
          if (listSPBDetailPlasma[i].ophEstateCode ==
              listSPBDetailPlasma[j].ophEstateCode) {
            countEstatePlasma++;
          }
        }

        if (countEstatePlasma > maxCountEstatePlasma) {
          maxCountEstatePlasma = countEstatePlasma;
          mostEstateCodePlasma = listSPBDetailPlasma[i].ophEstateCode!;
        }
      }

      List<SPBDetail> listSPBDetailMostEstatePlasma = [];
      for (int i = 0; i < listSPBDetailPlasma.length; i++) {
        if (listSPBDetailPlasma[i].ophEstateCode! == mostEstateCodePlasma) {
          listSPBDetailMostEstatePlasma.add(listSPBDetailPlasma[i]);
        }
      }

      int maxCountDivisionPlasma = 0;
      for (int i = 0; i < listSPBDetailMostEstatePlasma.length; i++) {
        int countDivisionPlasma = 0;
        for (int j = 0; j < listSPBDetailMostEstatePlasma.length; j++) {
          if (listSPBDetailMostEstatePlasma[i].ophDivisionCode ==
              listSPBDetailMostEstatePlasma[j].ophDivisionCode) {
            countDivisionPlasma++;
          }
        }

        if (countDivisionPlasma > maxCountDivisionPlasma) {
          maxCountDivisionPlasma = countDivisionPlasma;
          mostDivisionCodePlasma =
              listSPBDetailMostEstatePlasma[i].ophDivisionCode!;
        }
      }

      for (int i = 0; i < _listSPB.length; i++) {
        if (typeTBS == 3) {
          SPB spbPlasmaTemp = _listSPB[i];
          spbPlasmaTemp.spbEstateCode = mostEstateCodePlasma;
          spbPlasmaTemp.spbDivisionCode = mostDivisionCodePlasma;
          String jsonStringPlasma = jsonEncode(spbPlasmaTemp);
          mapListSPBPlasma.add("\"0\":$jsonStringPlasma");
          log('spbPlasmaTemp : $spbPlasmaTemp');

          SPB spbIntiTemp = _listSPB[i];
          spbIntiTemp.spbId = '${spbIntiTemp.spbId}_2';
          spbIntiTemp.spbEstateCode = mostEstateCodeInti;
          spbIntiTemp.spbDivisionCode = mostDivisionCodeInti;
          String jsonString = jsonEncode(spbIntiTemp);
          mapListSPBInti.add("\"0\":$jsonString");
          log('spbIntiTemp : $spbIntiTemp');
        }

        String jsonString = jsonEncode(_listSPB[i]);
        mapListSPB.add("\"$i\":$jsonString");
      }

      for (int i = 0; i < _listSPBLoader.length; i++) {
        String jsonString = jsonEncode(_listSPBLoader[i]);
        mapListSPBLoader.add("\"$i\":$jsonString");
      }

      log('mapListSPBInti : $mapListSPBInti');
      // log('mapListSPBDetailInti : $mapListSPBDetailInti');

      log('mapListSPBPlasma : $mapListSPBPlasma');
      // log('mapListSPBDetailPlasma : $mapListSPBDetailPlasma');

      _dialogService.showLoadingDialog(title: "Mengupload SPB");

      if (typeTBS == 3) {
        var stringListSPBLoader = mapListSPBLoader.join(",");
        String listSPBLoader = "{$stringListSPBLoader}";

        var stringListSPBInti = mapListSPBInti.join(",");
        var stringListSPBDetailInti = mapListSPBDetailInti.join(",");
        String listSPBInti = "{$stringListSPBInti}";
        String listSPBDetailInti = "{$stringListSPBDetailInti}";

        var stringListSPBPlasma = mapListSPBPlasma.join(",");
        var stringListSPBDetailPlasma = mapListSPBDetailPlasma.join(",");
        String listSPBPlasma = "{$stringListSPBPlasma}";
        String listSPBDetailPlasma = "{$stringListSPBDetailPlasma}";

        log('cek stringListSPBInti : $stringListSPBInti');
        log('cek listSPBInti : $listSPBInti');

        log('cek stringListSPBPlasma : $stringListSPBPlasma');
        log('cek listSPBPlasma : $listSPBPlasma');

        UploadSPBRepository().doPostUploadSPB(
          _navigationService.navigatorKey.currentContext!,
          listSPBPlasma,
          listSPBDetailPlasma,
          listSPBLoader,
          (BuildContext context, response) async {
            List<SPB> listSPB = await DatabaseSPB().selectSPB();
            for (int i = 0; i < listSPB.length; i++) {
              if (listSPB[i].spbPhoto != null) {
                UploadImageOPHRepository().doUploadPhoto(
                    context,
                    listSPB[i].spbPhoto!,
                    listSPB[i].spbId!,
                    "spb",
                    onSuccessUploadImage,
                    onErrorUploadImage);
              }
            }
            FlushBarManager.showFlushBarSuccess(
                context, "Upload SPB", "Berhasil mengupload data");

            UploadSPBRepository().doPostUploadSPB(
              _navigationService.navigatorKey.currentContext!,
              listSPBInti,
              listSPBDetailInti,
              listSPBLoader,
              (BuildContext context, response) async {
                List<SPB> listSPB = await DatabaseSPB().selectSPB();
                for (int i = 0; i < listSPB.length; i++) {
                  if (listSPB[i].spbPhoto != null) {
                    UploadImageOPHRepository().doUploadPhoto(
                        context,
                        listSPB[i].spbPhoto!,
                        '${listSPB[i].spbId!}_2',
                        "spb",
                        onSuccessUploadImage,
                        onErrorUploadImage);
                  }
                }
                DatabaseSPB().deleteSPB();
                DatabaseSPBDetail().deleteSPBDetail();
                DatabaseSPBLoader().deleteSPBLoader();
                _dialogService.popDialog();
                FlushBarManager.showFlushBarSuccess(
                    context, "Upload SPB", "Berhasil mengupload data");
              },
              onErrorUploadSPB,
            );
          },
          onErrorUploadSPB,
        );
      } else {
        var stringListSPB = mapListSPB.join(",");
        var stringListSPBDetail = mapListSPBDetail.join(",");
        var stringListSPBLoader = mapListSPBLoader.join(",");

        String listSPB = "{$stringListSPB}";
        String listSPBDetail = "{$stringListSPBDetail}";
        String listSPBLoader = "{$stringListSPBLoader}";

        log('cek stringListSPB : $stringListSPB');
        log('cek listSPB : $listSPB');

        UploadSPBRepository().doPostUploadSPB(
          _navigationService.navigatorKey.currentContext!,
          listSPB,
          listSPBDetail,
          listSPBLoader,
          onSuccessUploadSPB,
          onErrorUploadSPB,
        );
      }
    } else {
      FlushBarManager.showFlushBarWarning(
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
    log('Error upload SPB : $response');
    FlushBarManager.showFlushBarError(
        context, "Upload SPB", "Gagal mengupload data");
  }

  uploadImage(BuildContext context) async {
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

  onSuccessUploadImage(BuildContext context, response) {}

  onErrorUploadImage(BuildContext context, String response) {
    _dialogService.popDialog();
    FlushBarManager.showFlushBarError(
        context, "Upload Foto SPB", "Gagal mengupload data Foto");
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

  onClickMenu(BuildContext context, String menu) async {
    final now = DateTime.now();
    String dateNow = TimeManager.dateWithDash(now);
    String? dateLogin = await StorageManager.readData("lastSynchDate");
    final dateLoginParse = DateTime.parse(dateLogin!);
    print('dateNow : $dateNow');
    print('dateLogin : $dateLogin');

    switch (menu.toUpperCase()) {
      case "INSPECTION":
        if (dateLoginParse.year != now.year) {
          dialogSettingDateTime();
        } else {
          await _navigationService.push(Routes.INSPECTION);
          await context.read<HomeNotifier>().updateCountInspection();
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
          _navigationService.push(Routes.RESTAN_REPORT, arguments: "LIHAT");
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
      case "ADMINISTRASI SPB":
        if (dateLogin == dateNow) {
          _navigationService.push(Routes.ADMIN_SPB);
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
    File? fileExport = await FileManagerJson().writeFileJsonSPB();
    if (fileExport != null) {
      FlushBarManager.showFlushBarSuccess(
          context, "Export Json Berhasil", "${fileExport.path}");
    } else {
      FlushBarManager.showFlushBarWarning(
          context, "Export Json Berhasil", "Belum ada Transaksi SPB");
    }
  }
}

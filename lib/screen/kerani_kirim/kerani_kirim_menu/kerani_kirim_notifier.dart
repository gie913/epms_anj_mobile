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
      List<Map<String, dynamic>> listFotoSPB = [];

      for (int i = 0; i < _listSPBLoader.length; i++) {
        final spbDetailByLoaderSpbId = _listSPBDetail
            .where((element) => element.spbId! == _listSPBLoader[i].spbId!);
        final listSPBDetailTemp =
            List<SPBDetail>.from(spbDetailByLoaderSpbId.map((e) {
          return SPBDetail.fromJson(e.toJson2());
        }));

        int typeTBS = ValueService.checkTypeTBS(listSPBDetailTemp);
        if (typeTBS == 3) {
          String jsonString2 = jsonEncode(
            SPBLoader(
              loaderDestinationType: _listSPBLoader[i].loaderDestinationType,
              loaderEmployeeCode: _listSPBLoader[i].loaderEmployeeCode,
              loaderEmployeeName: _listSPBLoader[i].loaderEmployeeName,
              loaderPercentage: _listSPBLoader[i].loaderPercentage,
              loaderType: _listSPBLoader[i].loaderType,
              spbId: "${_listSPBLoader[i].spbId}_2",
              spbLoaderId: _listSPBLoader[i].spbLoaderId,
            ),
          );
          mapListSPBLoader.add("\"${mapListSPBLoader.length}\":$jsonString2");
          String jsonString1 = jsonEncode(
            SPBLoader(
              loaderDestinationType: _listSPBLoader[i].loaderDestinationType,
              loaderEmployeeCode: _listSPBLoader[i].loaderEmployeeCode,
              loaderEmployeeName: _listSPBLoader[i].loaderEmployeeName,
              loaderPercentage: _listSPBLoader[i].loaderPercentage,
              loaderType: _listSPBLoader[i].loaderType,
              spbId: "${_listSPBLoader[i].spbId}_1",
              spbLoaderId: _listSPBLoader[i].spbLoaderId,
            ),
          );
          mapListSPBLoader.add("\"${mapListSPBLoader.length}\":$jsonString1");
        } else {
          String jsonString = jsonEncode(_listSPBLoader[i]);
          mapListSPBLoader.add("\"${mapListSPBLoader.length}\":$jsonString");
        }
      }
      log('cek mapListSPBLoader : $mapListSPBLoader');

      for (int i = 0; i < _listSPB.length; i++) {
        // Mapping listSPBDetail
        final spbDetailBySpbId = _listSPBDetail
            .where((element) => element.spbId! == _listSPB[i].spbId!);
        final listSPBDetailTemp =
            List<SPBDetail>.from(spbDetailBySpbId.map((e) {
          return SPBDetail.fromJson(e.toJson2());
        }));

        // Mapping listSPB by Checking TBS Type is Mix / Original
        // typeTBS = 1 Inti, 2 Plasma, 3 Campuran
        int typeTBS = ValueService.checkTypeTBS(listSPBDetailTemp);

        int totalOphInti = 0;
        int totalJanjangInti = 0;
        int totalBrondolanInti = 0;
        List<SPBDetail> listSPBDetailInti = [];
        String mostEstateCodeInti = '';
        String mostDivisionCodeInti = '';

        int totalOphPlasma = 0;
        int totalJanjangPlasma = 0;
        int totalBrondolanPlasma = 0;
        List<SPBDetail> listSPBDetailPlasma = [];
        String mostEstateCodePlasma = '';
        String mostDivisionCodePlasma = '';

        if (typeTBS == 3) {
          for (int i = 0; i < listSPBDetailTemp.length; i++) {
            if (ValueService.plasmaValidator(
                    listSPBDetailTemp[i].ophEstateCode!) ==
                1) {
              SPBDetail spbDetailTemp = listSPBDetailTemp[i];
              spbDetailTemp.spbId = '${listSPBDetailTemp[i].spbId}_2';
              totalOphInti = totalOphInti + 1;
              totalJanjangInti =
                  totalJanjangInti + listSPBDetailTemp[i].ophBunchesDelivered!;
              totalBrondolanInti = totalBrondolanInti +
                  listSPBDetailTemp[i].ophLooseFruitDelivered!;
              listSPBDetailInti.add(spbDetailTemp);
              String jsonString = jsonEncode(spbDetailTemp);
              mapListSPBDetail
                  .add("\"${mapListSPBDetail.length}\":$jsonString");
            } else if (ValueService.plasmaValidator(
                    listSPBDetailTemp[i].ophEstateCode!) ==
                2) {
              SPBDetail spbDetailTemp = listSPBDetailTemp[i];
              spbDetailTemp.spbId = '${listSPBDetailTemp[i].spbId}_1';
              totalOphPlasma = totalOphPlasma + 1;
              totalJanjangPlasma = totalJanjangPlasma +
                  listSPBDetailTemp[i].ophBunchesDelivered!;
              totalBrondolanPlasma = totalBrondolanPlasma +
                  listSPBDetailTemp[i].ophLooseFruitDelivered!;
              listSPBDetailPlasma.add(spbDetailTemp);
              String jsonString = jsonEncode(spbDetailTemp);
              mapListSPBDetail
                  .add("\"${mapListSPBDetail.length}\":$jsonString");
            }
          }
        } else {
          for (int i = 0; i < listSPBDetailTemp.length; i++) {
            String jsonString = jsonEncode(listSPBDetailTemp[i]);
            mapListSPBDetail.add("\"${mapListSPBDetail.length}\":$jsonString");
          }
        }

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

        if (typeTBS == 3) {
          SPB spbPlasmaTemp = _listSPB[i];
          spbPlasmaTemp.spbId = '${_listSPB[i].spbId}_1';
          spbPlasmaTemp.spbEstateCode = mostEstateCodePlasma;
          spbPlasmaTemp.spbDivisionCode = mostDivisionCodePlasma;
          spbPlasmaTemp.spbTotalOph = totalOphPlasma;
          spbPlasmaTemp.spbTotalBunches = totalJanjangPlasma;
          spbPlasmaTemp.spbTotalLooseFruit = totalBrondolanPlasma;
          String jsonStringPlasma = jsonEncode(spbPlasmaTemp);
          mapListSPB.add("\"${mapListSPB.length}\":$jsonStringPlasma");
          listFotoSPB.add(
            {
              'id': '${_listSPB[i].spbId!.replaceAll(RegExp(r'_1'), '_1')}',
              'foto': _listSPB[i].spbPhoto,
            },
          );

          SPB spbIntiTemp = _listSPB[i];
          spbIntiTemp.spbId =
              '${_listSPB[i].spbId!.replaceAll(RegExp(r'_1'), '_2')}';
          spbIntiTemp.spbEstateCode = mostEstateCodeInti;
          spbPlasmaTemp.spbTotalOph = totalOphInti;
          spbPlasmaTemp.spbTotalBunches = totalJanjangInti;
          spbPlasmaTemp.spbTotalLooseFruit = totalBrondolanInti;
          spbIntiTemp.spbDivisionCode = mostDivisionCodeInti;
          String jsonStringInti = jsonEncode(spbIntiTemp);
          mapListSPB.add("\"${mapListSPB.length}\":$jsonStringInti");
          listFotoSPB.add(
            {
              'id': '${_listSPB[i].spbId!.replaceAll(RegExp(r'_1'), '_2')}',
              'foto': _listSPB[i].spbPhoto,
            },
          );
        } else {
          String jsonString = jsonEncode(_listSPB[i]);
          mapListSPB.add("\"${mapListSPB.length}\":$jsonString");
          listFotoSPB.add(
            {
              'id': '${_listSPB[i].spbId!}',
              'foto': _listSPB[i].spbPhoto,
            },
          );
        }
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
        (BuildContext context, response) {
          onSuccessUploadSPB(context, listFotoSPB);
        },
        onErrorUploadSPB,
      );
    } else {
      FlushBarManager.showFlushBarWarning(
        _navigationService.navigatorKey.currentContext!,
        "Upload SPB",
        "Belum ada SPB dibuat",
      );
    }
  }

  onSuccessUploadSPB(
    BuildContext context,
    List<Map<String, dynamic>> listFotoSPB,
  ) {
    uploadImage(context, listFotoSPB);
  }

  onErrorUploadSPB(BuildContext context, String response) {
    _dialogService.popDialog();
    log('Error upload SPB : $response');
    FlushBarManager.showFlushBarError(
        context, "Upload SPB", "Gagal mengupload data\n$response");
  }

  uploadImage(
    BuildContext context,
    List<Map<String, dynamic>> listFotoSPB,
  ) async {
    for (int i = 0; i < listFotoSPB.length; i++) {
      if (listFotoSPB[i]['foto'] != null) {
        UploadImageOPHRepository().doUploadPhoto(
          context,
          listFotoSPB[i]['foto'],
          listFotoSPB[i]['id'],
          "spb",
          onSuccessUploadImage,
          onErrorUploadImage,
        );
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
    log('Error upload Image : $response');
    FlushBarManager.showFlushBarError(
        context, "Upload Foto SPB", "Gagal mengupload data Foto\n$response");
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
          SynchRepository().synchEpms(
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

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/spb_card_manager.dart';
import 'package:epms/database/service/database_m_employee.dart';
import 'package:epms/database/service/database_m_vendor.dart';
import 'package:epms/database/service/database_mc_spb.dart';
import 'package:epms/database/service/database_spb.dart';
import 'package:epms/database/service/database_spb_detail.dart';
import 'package:collection/collection.dart';
import 'package:epms/database/service/database_spb_loader.dart';
import 'package:epms/model/m_c_spb_card_schema.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/m_vendor_schema.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_detail.dart';
import 'package:epms/model/spb_loader.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class DetailSPBNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  SPB? _spb;

  SPB? get spb => _spb;

  List<SPBDetail> _listSPBDetail = [];

  List<SPBDetail> get listSPBDetail => _listSPBDetail;

  List<SPBLoader> _listSPBLoader = [];

  List<SPBLoader> get listSPBLoader => _listSPBLoader;

  int _percentageLoader = 0;

  int get percentageLoader => _percentageLoader;

  bool _isSPBExist = false;

  bool get isSPBExist => _isSPBExist;

  List<MVendorSchema> _listMVendorSchema = [];

  List<MVendorSchema> get listMVendorSchema => _listMVendorSchema;

  List<MEmployeeSchema> _listDriver = [];

  List<MEmployeeSchema> get listDriver => _listDriver;

  checkSPBExist(SPB spb) async {
    SPB? spbGet = await DatabaseSPB().selectSPBByID(spb.spbId!);
    if (spbGet != null) {
      _isSPBExist = true;
      _spb = spbGet;
      _listSPBDetail = await DatabaseSPBDetail().selectSPBDetailBySPBID(spb);
      _listSPBLoader = await DatabaseSPBLoader().selectSPBLoaderBySPBID(spb);
      for (int i = 0; i < listSPBLoader.length; i++) {
        _percentageLoader =
            _percentageLoader + _listSPBLoader[i].loaderPercentage!;
      }
    } else {
      _spb = spb;
      if (spb.spbType == 3) {
        MVendorSchema? mVendorSchema = _listMVendorSchema.firstWhereOrNull(
            (element) => element.vendorCode == spb.spbDriverEmployeeCode);
        if (mVendorSchema != null) {
          _spb?.spbDriverEmployeeName = mVendorSchema.vendorName;
        }
      } else {
        _spb?.spbDriverEmployeeName = _listDriver
            .firstWhere(
                (element) => element.employeeCode == spb.spbDriverEmployeeCode)
            .employeeName;
      }
    }
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
    _dialogService.popDialog();
    notifyListeners();
  }

  onInit(BuildContext context, SPB spb, String method) async {
    _listMVendorSchema = await DatabaseMVendorSchema().selectMVendorSchema();
    _listDriver = await DatabaseMEmployeeSchema().selectMEmployeeSchema();
    if (method == "BACA") {
      await Future.delayed(Duration(milliseconds: 50));
      SPBCardManager().readSPBCard(context, onSuccessRead, onErrorRead);
      _dialogService.showNFCDialog(
          title: "Tempel Kartu NFC",
          subtitle: "Untuk membaca data",
          buttonText: "Batal",
          onPress: onPressCancelRead);
      _isSPBExist = false;
    } else {
      _isSPBExist = true;
      _spb = spb;
      _listSPBDetail = await DatabaseSPBDetail().selectSPBDetailBySPBID(spb);
      _listSPBLoader = await DatabaseSPBLoader().selectSPBLoaderBySPBID(spb);
      for (int i = 0; i < listSPBLoader.length; i++) {
        _percentageLoader =
            _percentageLoader + _listSPBLoader[i].loaderPercentage!;
      }
      notifyListeners();
    }
  }

  onSuccessRead(BuildContext context, SPB spb) {
    checkSPBExist(spb);
  }

  onErrorRead(BuildContext context, String message) {
    _dialogService.popDialog();
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
    FlushBarManager.showFlushBarWarning(context, "Gagal Membaca", message);
  }

  onPressCancelRead() {
    _dialogService.popDialog();
    _navigationService.push(Routes.HOME_PAGE);
    Future.delayed(Duration(seconds: 2), () {
      NfcManager.instance.stopSession();
    });
  }

  onClickChangeSPB() {
    _navigationService.push(Routes.EDIT_SPB, arguments: {
      "spb": _spb,
      "spb_detail": _listSPBDetail,
      "spb_loader": _listSPBLoader
    });
  }

  bool _onChangeCard = false;

  bool get onChangeCard => _onChangeCard;

  TextEditingController spbNumber = TextEditingController();

  MCSPBCardSchema? _mcspbCardSchema;

  MCSPBCardSchema? get mcspbCardSchema => _mcspbCardSchema;

  onClickChangeCard() {
    _onChangeCard = true;
    spbNumber.text = _spb!.spbCardId!;
    notifyListeners();
  }

  checkSPBCard(BuildContext context, String spbCardID) async {
    if (spbCardID.isNotEmpty) {
      _mcspbCardSchema =
          await DatabaseMCSPBCardSchema().selectMCSPBCardSchema(spbCardID);
      if (_mcspbCardSchema != null) {
        // _spb?.spbCardId = _mcspbCardSchema?.spbCardId;
      } else {
        FlushBarManager.showFlushBarWarning(
            context, "No Kartu SPB", "Tidak sesuai");
      }
      notifyListeners();
    }
  }

  showDialogQuestion(BuildContext context) {
    onClickYesCard();
    // _dialogService.showOptionDialog(
    //     title: "Memakai Kartu",
    //     subtitle: "Apakah anda ingin memakai kartu",
    //     buttonTextYes: "Ya",
    //     buttonTextNo: "Tidak",
    //     onPressYes: onClickYesCard,
    //     onPressNo: onClickNoCard);
  }

  onClickYesCard() {
    // _dialogService.popDialog();
    SPBCardManager().writeSPBCard(
        _navigationService.navigatorKey.currentContext!,
        _spb!,
        _listSPBDetail,
        onSuccessWrite,
        onErrorWrite);
    _dialogService.showNFCDialog(
        title: "Tempel Kartu SPB",
        subtitle: "Untuk memasukkan data",
        buttonText: "Batal",
        onPress: onPressCancelScan);
  }

  onSuccessWrite(BuildContext context) {
    saveSPBtoDatabase(context);
  }

  onErrorWrite(BuildContext context) {
    _dialogService.popDialog();
    NfcManager.instance.stopSession();
    FlushBarManager.showFlushBarWarning(context, "SPB", "Gagal menyimpan SPB");
  }

  onPressCancelScan() {
    _dialogService.popDialog();
    NfcManager.instance.stopSession();
  }

  onClickNoCard() {
    _dialogService.popDialog();
    saveSPBtoDatabase(_navigationService.navigatorKey.currentContext!);
  }

  void saveSPBtoDatabase(BuildContext context) async {
    _spb?.spbCardId = _mcspbCardSchema?.spbCardId;
    int countSaved = await DatabaseSPB().updateSPBByID(_spb!);
    if (countSaved > 0) {
      _dialogService.popDialog();
      _navigationService.push(Routes.HOME_PAGE);
      FlushBarManager.showFlushBarSuccess(
          context, "Simpan SPB", "Berhasil menyimpan SPB");
    } else {
      FlushBarManager.showFlushBarWarning(
          context, "Simpan SPB", "Gagal menyimpan SPB");
    }
  }

  onClickSaveSPB(BuildContext context) {
    if (spbNumber.text.isNotEmpty) {
      if (_spb?.spbCardId != spbNumber.text) {
        if (_mcspbCardSchema != null) {
          showDialogQuestion(context);
        } else {
          FlushBarManager.showFlushBarWarning(
              context, "Kartu SPB", "Tidak Sesuai");
        }
      } else {
        FlushBarManager.showFlushBarWarning(
            context, "Kartu SPB", "Kartu SPB Belum Diganti");
      }
    } else {
      FlushBarManager.showFlushBarWarning(
          context, "Kartu SPB", "Belum menginput kartu SPB");
    }
  }
}

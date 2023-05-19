import 'dart:async';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/common_manager/tbs_luar_card_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_m_vendor.dart';
import 'package:epms/database/service/database_tbs_luar.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/m_vendor_schema.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/tbs_luar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nfc_manager/nfc_manager.dart';

class SupervisorTBSLuarNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  String _supervisiTBSID = "";

  String get supervisiTBSID => _supervisiTBSID;

  Position? _position;

  Position? get position => _position;

  String _date = "";

  String get date => _date;

  String _time = "";

  String get time => _time;

  String _gpsLocation = "";

  String get gpsLocation => _gpsLocation;

  MConfigSchema? _mConfigSchema;

  MConfigSchema? get mConfigSchema => _mConfigSchema;

  MVendorSchema? _vendor;

  MVendorSchema? get vendor => _vendor;

  List<MVendorSchema> _listVendor = [];

  List<MVendorSchema> get listVendor => _listVendor;

  TextEditingController contractNumber = TextEditingController();

  TextEditingController quantity = TextEditingController();

  TextEditingController vehicleNumber = TextEditingController();

  TextEditingController driver = TextEditingController();

  TextEditingController _rubbish = TextEditingController();

  TextEditingController get rubbish => _rubbish;

  TextEditingController _vendorOther = TextEditingController();

  TextEditingController get vendorOther => _vendorOther;

  TextEditingController _deliveryID = TextEditingController();

  TextEditingController get deliveryID => _deliveryID;

  bool _activeText = false;

  bool get activeText => _activeText;

  bool _isChecked = false;

  bool get isChecked => _isChecked;

  String? _pickedFile;

  String? get pickedFile => _pickedFile;

  TextEditingController _bunchesUnRipe = TextEditingController();

  TextEditingController get bunchesUnRipe => _bunchesUnRipe;

  TextEditingController _bunchesHalfRipe = TextEditingController();

  TextEditingController get bunchesHalfRipe => _bunchesHalfRipe;

  TextEditingController _bunchesOverRipe = TextEditingController();

  TextEditingController get bunchesOverRipe => _bunchesOverRipe;

  TextEditingController _bunchesRotten = TextEditingController();

  TextEditingController get bunchesRotten => _bunchesRotten;

  TextEditingController _bunchesAbnormal = TextEditingController();

  TextEditingController get bunchesAbnormal => _bunchesAbnormal;

  TextEditingController _bunchesEmpty = TextEditingController();

  TextEditingController get bunchesEmpty => _bunchesEmpty;

  TextEditingController _water = TextEditingController();

  TextEditingController get water => _water;

  TextEditingController _longStalk = TextEditingController();

  TextEditingController get longStalk => _longStalk;

  TextEditingController _looseFruits = TextEditingController();

  TextEditingController get looseFruits => _looseFruits;

  TextEditingController _bunchesTotal = TextEditingController();

  TextEditingController get bunchesTotal => _bunchesTotal;

  TextEditingController _deduction = TextEditingController();

  TextEditingController get deduction => _deduction;

  TextEditingController _bunchesLarge = TextEditingController();

  TextEditingController get bunchesLarge => _bunchesLarge;

  TextEditingController _bunchesMedium = TextEditingController();

  TextEditingController get bunchesMedium => _bunchesMedium;

  TextEditingController _bunchesSmall = TextEditingController();

  TextEditingController get bunchesSmall => _bunchesSmall;

  TextEditingController _bunchesLess4Kg = TextEditingController();

  TextEditingController get bunchesLess4Kg => _bunchesLess4Kg;

  TextEditingController _bunchesCengkeh = TextEditingController();

  TextEditingController get bunchesCengkeh => _bunchesCengkeh;

  TextEditingController _brondolanRotten = TextEditingController();

  TextEditingController get brondolanRotten => _brondolanRotten;

  TextEditingController _notesOPH = TextEditingController();

  TextEditingController get notesOPH => _notesOPH;

  SPB? _scannedSPB;

  SPB? get scannedSPB => _scannedSPB;

  TBSLuar? _tbsLuar;

  TBSLuar? get tbsLuar => _tbsLuar;

  int _formType = 2;

  int get formType => _formType;

  onInit() async {
    _listVendor = await DatabaseMVendorSchema().selectMVendorSchema();
    generateVariable();
    getLocation();
  }

  getCamera(BuildContext context) async {
    String? picked = await CameraService.getImageByCamera(context);
    if (picked != null) {
      _pickedFile = picked;
      notifyListeners();
    }
  }

  getLocation() async {
    try {
      _position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .timeout(const Duration(seconds: 4));
      _gpsLocation = "${position?.latitude},${position?.longitude}";
    } on TimeoutException catch (_) {
      _gpsLocation = "";
    } catch (e) {
      _gpsLocation = "";
    }
    notifyListeners();
  }

  onChangeActiveText(bool checked) {
    _activeText = checked;
    notifyListeners();
  }

  onChangeVendor(MVendorSchema mVendorSchema) {
    _vendor = mVendorSchema;
    notifyListeners();
  }

  onCancelScanSPB() {
    _dialogService.popDialog();
    NfcManager.instance.stopSession();
  }

  onChangeFormType(int value) {
    _formType = value;
    notifyListeners();
  }

  setQRResult(String result) {
    var tag = result.split(',');
    int totalBunches = 0;
    _deliveryID.text = tag[0];
    _listVendor.forEach((element) {
      if (tag[1] == element.vendorCode) {
        _vendor = element;
        notifyListeners();
      }
    });
    driver.text = tag[2];
    vehicleNumber.text = tag[3].split('[').first;
    String farmer = result.split('[').last.split(']').first;
    farmer.split('#').forEach((element) {
      int total = int.parse(element.split(',')[1]);
      totalBunches = totalBunches + total;
    }); // brow
    _bunchesTotal.text = totalBunches.toString();
    quantity.text = totalBunches.toString();
  }

  generateVariable() async {
    DateTime now = DateTime.now();
    _mConfigSchema = await DatabaseMConfig().selectMConfig();
    String millCode = await StorageManager.readData("millCode");
    int formType = await StorageManager.readData("formType");
    NumberFormat formatterNumber = new NumberFormat("000");
    String number = formatterNumber.format(mConfigSchema?.userId);
    _date = TimeManager.dateWithDash(now);
    _time = TimeManager.timeWithColon(now);
    _formType = formType;
    _supervisiTBSID =
        "$millCode" + ValueService.generateIDFromDateTime(now) + "$number" "SM";
    _bunchesUnRipe.text = "0";
    _bunchesHalfRipe.text = "0";
    _bunchesOverRipe.text = "0";
    _bunchesRotten.text = "0";
    _bunchesAbnormal.text = "0";
    _bunchesEmpty.text = "0";
    _rubbish.text = "0";
    _water.text = "0";
    _longStalk.text = "0";
    _bunchesTotal.text = "0";
    _deduction.text = "0";
    _bunchesLarge.text = "0";
    _bunchesSmall.text = "0";
    _bunchesMedium.text = "0";
    _brondolanRotten.text = "0";
    _bunchesCengkeh.text = "0";
    _bunchesLess4Kg.text = "0";
    notifyListeners();
  }

  countBunches(
      BuildContext context, TextEditingController textEditingController) {
    if (textEditingController.text.isEmpty ||
        textEditingController.text == "0" ||
        textEditingController.text == "00") {
      textEditingController.value = TextEditingValue(text: "0");
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
      _deduction.text = (int.parse(_bunchesUnRipe.text) +
              int.parse(_bunchesHalfRipe.text) +
              int.parse(_bunchesOverRipe.text) +
              int.parse(_bunchesRotten.text) +
              int.parse(_brondolanRotten.text) +
              int.parse(_bunchesAbnormal.text) +
              int.parse(_bunchesEmpty.text) +
              int.parse(_rubbish.text) +
              int.parse(_water.text) +
              int.parse(_longStalk.text) +
              int.parse(_bunchesCengkeh.text) +
              int.parse(_bunchesLess4Kg.text))
          .toString();
    } else {
      textEditingController.text =
          textEditingController.text.replaceFirst(RegExp(r'^0+'), "");
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
      _deduction.text = (int.parse(_bunchesUnRipe.text) +
              int.parse(_bunchesHalfRipe.text) +
              int.parse(_bunchesOverRipe.text) +
              int.parse(_bunchesRotten.text) +
              int.parse(_brondolanRotten.text) +
              int.parse(_bunchesAbnormal.text) +
              int.parse(_bunchesEmpty.text) +
              int.parse(_rubbish.text) +
              int.parse(_water.text) +
              int.parse(_longStalk.text) +
              int.parse(_bunchesCengkeh.text) +
              int.parse(_bunchesLess4Kg.text))
          .toString();
      notifyListeners();
    }
  }

  showDialogQuestion(BuildContext context) {
    generateTBSLuar(context);
  }

  generateTBSLuar(BuildContext context) {
    if (_vendor != null) {
      if (driver.text.isNotEmpty) {
        if (vehicleNumber.text.isNotEmpty) {
          if (_deliveryID.text.isNotEmpty) {
            if (_pickedFile != null) {
              if ((_bunchesTotal.text != "0" && _bunchesSmall.text == "0") ||
                  (_bunchesTotal.text == "0" && _bunchesSmall.text != "0")) {
                _tbsLuar = TBSLuar();
                _tbsLuar?.formType = _formType;
                _tbsLuar?.spdID = _deliveryID.text;
                _tbsLuar?.supplierCode = _vendor?.vendorCode;
                _tbsLuar?.supplierName = _vendor?.vendorName;
                _tbsLuar?.supervisiName = _mConfigSchema?.employeeName;
                _tbsLuar?.createdDate = _date;
                _tbsLuar?.createdTime = _time;
                _tbsLuar?.createdBy = _mConfigSchema?.employeeCode;
                _tbsLuar?.contractNumber = contractNumber.text;
                _tbsLuar?.gpsLat = _position?.latitude;
                _tbsLuar?.gpsLong = _position?.longitude;
                _tbsLuar?.driverName = driver.text;
                _tbsLuar?.licenseNumber = vehicleNumber.text;
                _tbsLuar?.sortasiID = _supervisiTBSID;
                _tbsLuar?.quantity = int.parse(quantity.text);
                _tbsLuar?.bunchesUnripe = int.parse(_bunchesUnRipe.text);
                _tbsLuar?.bunchesUnripe = int.parse(_bunchesUnRipe.text);
                _tbsLuar?.bunchesHalfripe = int.parse(_bunchesHalfRipe.text);
                _tbsLuar?.bunchesOverripe = int.parse(_bunchesOverRipe.text);
                _tbsLuar?.bunchesRotten = int.parse(_bunchesRotten.text);
                _tbsLuar?.bunchesAbnormal = int.parse(_bunchesAbnormal.text);
                _tbsLuar?.bunchesEmpty = int.parse(_bunchesEmpty.text);
                _tbsLuar?.rubbish = int.parse(_rubbish.text);
                _tbsLuar?.water = int.parse(_water.text);
                _tbsLuar?.bunchesTotal = int.parse(_bunchesTotal.text);
                _tbsLuar?.deduction = int.parse(_deduction.text);
                _tbsLuar?.small = int.parse(_bunchesSmall.text);
                _tbsLuar?.medium = int.parse(_bunchesMedium.text);
                _tbsLuar?.large = int.parse(_bunchesLarge.text);
                _tbsLuar?.longStalk = int.parse(_longStalk.text);
                _tbsLuar?.bunchesCengkeh = int.parse(_bunchesCengkeh.text);
                _tbsLuar?.brondolanRotten = int.parse(_brondolanRotten.text);
                _tbsLuar?.bunchesLess4Kg = int.parse(_bunchesLess4Kg.text);
                _tbsLuar?.gradingPhoto = _pickedFile;
                notifyListeners();
                _dialogService.showOptionDialog(
                    title: "Simpan Supervisi SPB",
                    subtitle: "Anda yakin ingin menyimpan Supervisi SPB?",
                    buttonTextYes: "Iya",
                    buttonTextNo: "Tidak",
                    onPressYes: onPressYes,
                    onPressNo: onPressNo);
              } else {
                FlushBarManager.showFlushBarWarning(
                    context,
                    "Sortasi atau Grading",
                    "Komidal dan Total janjang hanya diisi salah satu");
              }
            } else {
              FlushBarManager.showFlushBarWarning(
                  context, "Foto Grading", "Anda belum mengambil foto grading");
            }
          } else {
            FlushBarManager.showFlushBarWarning(context, "Delivery Order ID",
                "Anda belum scan QR Delivery Order");
          }
        } else {
          FlushBarManager.showFlushBarWarning(
              context, "Nomor Kendaraan", "Nomor Kendaraan belum terisi");
        }
      } else {
        FlushBarManager.showFlushBarWarning(
            context, "Nama Supir", "Nama Supier belum terisi");
      }
    } else {
      FlushBarManager.showFlushBarWarning(
          context, "Supplier", "Nama Supplier belum terpilih");
    }
  }

  onPressYes() {
    _dialogService.popDialog();
    TBSLuarCardManager().writeTBSLuarCard(
        _navigationService.navigatorKey.currentContext!,
        _tbsLuar!,
        onSuccessWrite,
        onErrorWrite);
    _dialogService.showNFCDialog(
        title: "Tempel Kartu NFC",
        subtitle: "Untuk memasukkan data",
        buttonText: "Batal",
        onPress: onPressBatal);
  }

  onSuccessWrite(BuildContext context, TBSLuar tbsLuar) {
    saveToDatabase(tbsLuar);
  }

  onErrorWrite(BuildContext context) {
    FlushBarManager.showFlushBarWarning(
        context, "Supplier", "Nama Supplier belum terpilih");
  }

  onPressBatal() {
    NfcManager.instance.stopSession();
    _dialogService.popDialog();
  }

  onPressNo() {
    _dialogService.popDialog();
  }

  saveToDatabase(TBSLuar tbsLuar) async {
    _dialogService.popDialog();
    int count = await DatabaseTBSLuar().insertTBSLuar(tbsLuar);
    if (count > 0) {
      _navigationService.push(Routes.HOME_PAGE);
      FlushBarManager.showFlushBarSuccess(
          _navigationService.navigatorKey.currentContext!,
          "Supervisi SPB",
          "Berhasil tersimpan");
    } else {
      FlushBarManager.showFlushBarError(
          _navigationService.navigatorKey.currentContext!,
          "Supervisi SPB",
          "Gagal tersimpan");
    }
  }
}

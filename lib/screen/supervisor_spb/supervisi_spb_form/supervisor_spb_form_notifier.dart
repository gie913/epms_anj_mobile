import 'dart:async';

import 'package:collection/collection.dart';
import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/spb_card_manager.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/common_manager/tbs_luar_card_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_m_division.dart';
import 'package:epms/database/service/database_m_employee.dart';
import 'package:epms/database/service/database_m_estate.dart';
import 'package:epms/database/service/database_m_vendor.dart';
import 'package:epms/database/service/database_spb_supervise.dart';
import 'package:epms/database/service/database_tbs_luar.dart';
import 'package:epms/database/service/database_tbs_luar_one_month.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/m_division_schema.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/m_estate_schema.dart';
import 'package:epms/model/m_vendor_schema.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_supervise.dart';
import 'package:epms/model/supervisi_3rd_party.dart';
import 'package:epms/model/tbs_luar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nfc_manager/nfc_manager.dart';

class SupervisorSPBFormNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  String _supervisiID = "";

  String get supervisiID => _supervisiID;

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

  MEstateSchema? _mEstateSchemaValue;

  MEstateSchema? get mEstateSchemaValue => _mEstateSchemaValue;

  List<MEstateSchema> _listMEstateSchema = [];

  List<MEstateSchema> get listMEstateSchema => _listMEstateSchema;

  List<String> _sourceSPB = ["Internal", "External"];

  List<String> get sourceSPB => _sourceSPB;

  String _sourceSPBValue = "Internal";

  String get sourceSPBValue => _sourceSPBValue;

  List<String> _employeeType = ["Internal", "Kontrak"];

  List<String> get employeeType => _employeeType;

  String _employeeTypeValue = "Internal";

  String get employeeTypeValue => _employeeTypeValue;

  MEmployeeSchema? _driver;

  MEmployeeSchema? get driver => _driver;

  List<MEmployeeSchema> _listDriver = [];

  List<MEmployeeSchema> get listDriver => _listDriver;

  MDivisionSchema? _division;

  MDivisionSchema? get division => _division;

  List<MDivisionSchema> _listDivision = [];

  List<MDivisionSchema> get listDivision => _listDivision;

  List<MDivisionSchema> _listDivisionResult = [];

  List<MDivisionSchema> get listDivisionResult => _listDivisionResult;

  MVendorSchema? _vendor;

  MVendorSchema? get vendor => _vendor;

  List<MVendorSchema> _listVendor = [];

  List<MVendorSchema> get listVendor => _listVendor;

  TextEditingController _estate = TextEditingController();

  TextEditingController get estate => _estate;

  TextEditingController vehicleNumber = TextEditingController();

  TextEditingController _janjangTangkaiPanjang = TextEditingController();

  TextEditingController get janjangTangkaiPanjang => _janjangTangkaiPanjang;

  TextEditingController _noteJanjangTangkaiPanjang = TextEditingController();

  TextEditingController get noteJanjangTangkaiPanjang =>
      _noteJanjangTangkaiPanjang;

  TextEditingController _sampah = TextEditingController();

  TextEditingController get sampah => _sampah;

  TextEditingController _batu = TextEditingController();

  TextEditingController get batu => _batu;

  TextEditingController _vendorOther = TextEditingController();

  TextEditingController get vendorOther => _vendorOther;

  TextEditingController _spbID = TextEditingController();

  TextEditingController get spbID => _spbID;

  bool _activeText = false;

  bool get activeText => _activeText;

  bool _isChecked = false;

  bool get isChecked => _isChecked;

  String? _pickedFile;

  String? get pickedFile => _pickedFile;

  TextEditingController _bunchesRipe = TextEditingController();

  TextEditingController get bunchesRipe => _bunchesRipe;

  TextEditingController _bunchesOverRipe = TextEditingController();

  TextEditingController get bunchesOverRipe => _bunchesOverRipe;

  TextEditingController _bunchesHalfRipe = TextEditingController();

  TextEditingController get bunchesHalfRipe => _bunchesHalfRipe;

  TextEditingController _bunchesUnRipe = TextEditingController();

  TextEditingController get bunchesUnRipe => _bunchesUnRipe;

  TextEditingController _bunchesAbnormal = TextEditingController();

  TextEditingController get bunchesAbnormal => _bunchesAbnormal;

  TextEditingController _bunchesEmpty = TextEditingController();

  TextEditingController get bunchesEmpty => _bunchesEmpty;

  TextEditingController _looseFruits = TextEditingController();

  TextEditingController get looseFruits => _looseFruits;

  TextEditingController _bunchesTotal = TextEditingController();

  TextEditingController get bunchesTotal => _bunchesTotal;

  TextEditingController _bunchesNormalTotal = TextEditingController();

  TextEditingController get bunchesNormalTotal => _bunchesNormalTotal;

  TextEditingController _notesOPH = TextEditingController();

  TextEditingController get notesOPH => _notesOPH;

  SPB? _scannedSPB;

  SPB? get scannedSPB => _scannedSPB;

  TextEditingController _driverTBSLuar = TextEditingController();

  TextEditingController get driverTBSLuar => _driverTBSLuar;

  TextEditingController _bunchesRotten = TextEditingController();

  TextEditingController get bunchesRotten => _bunchesRotten;

  TextEditingController _water = TextEditingController();

  TextEditingController get water => _water;

  TextEditingController _longStalk = TextEditingController();

  TextEditingController get longStalk => _longStalk;

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

  TextEditingController _rubbish = TextEditingController();

  TextEditingController get rubbish => _rubbish;

  TBSLuar? _tbsLuar;

  TBSLuar? get tbsLuar => _tbsLuar;

  int _formType = 2;

  int get formType => _formType;

  TextEditingController _deliveryID = TextEditingController();

  TextEditingController get deliveryID => _deliveryID;

  onInit() async {
    _listDriver = await DatabaseMEmployeeSchema().selectMEmployeeSchema();
    _listVendor = await DatabaseMVendorSchema().selectMVendorSchema();
    _listDivision = await DatabaseMDivisionSchema().selectMDivisionSchema();
    _listMEstateSchema = await DatabaseMEstateSchema().selectMEstateSchema();
    generateVariable();
    getLocation();
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

  onChangeSourceSPB(String value) {
    _sourceSPBValue = value;
    notifyListeners();
  }

  onChangeTypeEmployee(String value) {
    _employeeTypeValue = value;
    notifyListeners();
  }

  onChangeEstateSchema(MEstateSchema estateSchema) {
    _mEstateSchemaValue = estateSchema;
    _listDivision.clear();
    _division = null;
    DatabaseMDivisionSchema().selectMDivisionSchema().then((value) {
      for (int i = 0; i < value.length; i++) {
        if (value[i].divisionEstateCode == estateSchema.estateCode) {
          _listDivision.add(value[i]);
        }
      }
      notifyListeners();
    });
    notifyListeners();
  }

  onChangeVendor(MVendorSchema mVendorSchema) {
    _vendor = mVendorSchema;
    notifyListeners();
  }

  dialogNFC(BuildContext context) {
    SPBCardManager().readSPBCard(context, onSuccessRead, onErrorRead);
    _dialogService.showNFCDialog(
        title: "Tempel Kartu SPB",
        subtitle: "untuk membaca data",
        buttonText: "Selesai",
        onPress: onCancelScanSPB);
  }

  onSuccessRead(BuildContext context, SPB spb) {
    checkSPBExist(spb);
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
  }

  checkSPBExist(SPB spb) async {
    List spbSupervise =
        await DatabaseSPBSupervise().selectSPBSuperviseByID(spb.spbId!);
    if (spbSupervise.isEmpty) {
      if (spb.spbType == 3) {
        _employeeTypeValue = "Kontrak";
        _vendor = _listVendor.firstWhereOrNull(
            (element) => element.vendorCode == spb.spbDriverEmployeeCode);
        if (_vendor == null) {
          _isChecked = true;
          _vendorOther.text = spb.spbDriverEmployeeCode!;
          notifyListeners();
        }
      } else {
        _employeeTypeValue = "Internal";
        _driver = _listDriver.firstWhere(
            (element) => element.employeeCode == spb.spbDriverEmployeeCode);
      }
      _scannedSPB = spb;
      _dialogService.popDialog();
      _spbID.text = spb.spbId!;
      vehicleNumber.text = spb.spbLicenseNumber!;
      _mEstateSchemaValue = _listMEstateSchema
          .where((element) => element.estateCode == spb.spbEstateCode)
          .first;
      _listDivision.clear();
      DatabaseMDivisionSchema().selectMDivisionSchema().then((value) {
        for (int i = 0; i < value.length; i++) {
          if (value[i].divisionEstateCode == spb.spbEstateCode) {
            _listDivision.add(value[i]);
          }
        }
        if (_listDivision.isNotEmpty) {
          _division = _listDivision.firstWhere(
              (element) => element.divisionCode == spb.spbDivisionCode);
        }
        notifyListeners();
      });
    } else {
      onStopNFC();
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Scan SPB",
          "SPB ini sudah pernah discan");
    }
    notifyListeners();
  }

  onStopNFC() {
    _dialogService.popDialog();
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
  }

  onErrorRead(BuildContext context, String response) {
    _dialogService.popDialog();
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
    FlushBarManager.showFlushBarWarning(context, "Gagal Membaca", response);
  }

  onCancelScanSPB() {
    _dialogService.popDialog();
    NfcManager.instance.stopSession();
  }

  generateVariable() async {
    _mConfigSchema = await DatabaseMConfig().selectMConfig();
    _formType = await StorageManager.readData('formType');
    DateTime now = DateTime.now();
    String millCode = await StorageManager.readData("millCode");
    NumberFormat formatterNumber = new NumberFormat("000");
    String number = formatterNumber.format(mConfigSchema?.userId);
    _date = TimeManager.dateWithDash(now);
    _time = TimeManager.timeWithColon(now);
    _supervisiID =
        "$millCode" + ValueService.generateIDFromDateTime(now) + "$number" "SM";
    _bunchesRipe.text = "0";
    _bunchesOverRipe.text = "0";
    _bunchesHalfRipe.text = "0";
    _bunchesUnRipe.text = "0";
    _bunchesAbnormal.text = "0";
    _bunchesEmpty.text = "0";
    _looseFruits.text = "0";
    _bunchesTotal.text = "0";
    _bunchesNormalTotal.text = "0";
    _janjangTangkaiPanjang.text = "0";
    _sampah.text = "0";
    _batu.text = "0";
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

  onChangeFormType(int value) {
    _formType = value;
    notifyListeners();
  }

  getCamera(BuildContext context) async {
    String? picked = await CameraService.getImageByCamera(context);
    if (picked != null) {
      _pickedFile = picked;
      notifyListeners();
    }
  }

  onSetDriver(MEmployeeSchema mEmployeeSchema) {
    if (_listDriver.contains(mEmployeeSchema)) {
      _driver = mEmployeeSchema;
      notifyListeners();
    } else {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Supir Kendaraan",
          "Pekerja yang dipilih bukan supir");
    }
  }

  onChangeDivision(MDivisionSchema mDivisionSchema) {
    _division = mDivisionSchema;
    _estate.text = _division!.divisionEstateCode!;
    notifyListeners();
  }

  onChangeChecked(bool checked) {
    _isChecked = checked;
    notifyListeners();
  }

  onChangeActiveText(bool checked) {
    _activeText = checked;
    notifyListeners();
  }

  countBunches(
      BuildContext context, TextEditingController textEditingController) {
    if (textEditingController.text.isEmpty ||
        textEditingController.text == "0") {
      textEditingController.value = TextEditingValue(text: "0");
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    } else {
      textEditingController.text =
          textEditingController.text.replaceFirst(RegExp(r'^0+'), "");
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    }
    try {
      bunchesTotal.text = (int.parse(bunchesRipe.text) +
              int.parse(bunchesOverRipe.text) +
              int.parse(bunchesHalfRipe.text) +
              int.parse(bunchesUnRipe.text) +
              int.parse(bunchesAbnormal.text) +
              int.parse(bunchesEmpty.text))
          .toString();
    } catch (e) {
      print(e);
    }
    try {
      bunchesNormalTotal.text = (int.parse(bunchesRipe.text) +
              int.parse(bunchesOverRipe.text) +
              int.parse(bunchesHalfRipe.text) +
              int.parse(bunchesUnRipe.text) +
              int.parse(bunchesEmpty.text))
          .toString();
    } catch (e) {
      print(e);
    }
  }

  showDialogQuestion(BuildContext context) {
    if (_sourceSPBValue == "Internal") {
      _dialogService.showOptionDialog(
          title: "Simpan Supervisi SPB",
          subtitle: "Anda yakin ingin menyimpan Supervisi SPB?",
          buttonTextYes: "Iya",
          buttonTextNo: "Tidak",
          onPressYes: checkFormSaveSourceSPB,
          onPressNo: onPressNo);
    } else {
      generateTBSLuar(context);
    }
  }

  onPressNo() {
    _dialogService.popDialog();
  }

  checkFormSaveSourceSPB() {
    switch (_sourceSPBValue) {
      case "Internal":
        checkFormSaveTypeEmployeeInternal();
        break;
      case "External":
        checkFormSaveTypeExternal();
        break;
    }
  }

  checkFormSaveTypeExternal() {
    if (!_isChecked) {
      if (_vendor != null) {
        if (vehicleNumber.text.isNotEmpty) {
          if (_spbID.text.isNotEmpty) {
            SPBSupervise spbSupervise = SPBSupervise();
            spbSupervise.spbSuperviseId = _supervisiID;
            spbSupervise.spbId = _spbID.text;
            spbSupervise.supervisiSpbEmployeeCode =
                _mConfigSchema?.employeeCode;
            spbSupervise.supervisiSpbEmployeeName =
                _mConfigSchema?.employeeName;
            spbSupervise.supervisiSpbLat = _position?.latitude.toString();
            spbSupervise.supervisiSpbLong = _position?.longitude.toString();
            spbSupervise.supervisiSpbDriverEmployeeCode = _vendor?.vendorCode;
            spbSupervise.supervisiSpbDriverEmployeeName =
                ValueService.rightTrimVendor(_vendor!.vendorName!);
            spbSupervise.supervisiSpbDivisionCode =
                _scannedSPB!.spbDivisionCode;
            spbSupervise.supervisiSpbLicenseNumber = vehicleNumber.text;
            spbSupervise.supervisiSpbType =
                ValueService.spbSourceData(_sourceSPBValue);
            spbSupervise.supervisiSpbMethod =
                ValueService.typeOfFormToInt(_employeeTypeValue);
            spbSupervise.supervisiSpbPhoto = _pickedFile;
            spbSupervise.bunchesRipe = int.parse(_bunchesRipe.text);
            spbSupervise.bunchesOverripe = int.parse(_bunchesOverRipe.text);
            spbSupervise.bunchesHalfripe = int.parse(_bunchesHalfRipe.text);
            spbSupervise.bunchesUnripe = int.parse(_bunchesUnRipe.text);
            spbSupervise.bunchesAbnormal = int.parse(_bunchesAbnormal.text);
            spbSupervise.bunchesEmpty = int.parse(_bunchesEmpty.text);
            spbSupervise.looseFruits = int.parse(_looseFruits.text);
            spbSupervise.bunchesTotal = int.parse(_bunchesTotal.text);
            spbSupervise.supervisiEstateCode = _mEstateSchemaValue?.estateCode;
            spbSupervise.bunchesTotalNormal =
                int.parse(_bunchesNormalTotal.text);
            spbSupervise.bunchesTangkaiPanjang =
                int.parse(_janjangTangkaiPanjang.text);
            spbSupervise.bunchesSampah = int.parse(_sampah.text);
            spbSupervise.bunchesBatu = int.parse(_batu.text);
            spbSupervise.catatanBunchesTangkaiPanjang =
                noteJanjangTangkaiPanjang.text;
            spbSupervise.supervisiNotes = _notesOPH.text;
            spbSupervise.createdBy = _mConfigSchema?.employeeName;
            spbSupervise.supervisiSpbDate = _date;
            spbSupervise.createdDate = _date;
            spbSupervise.createdTime = _time;
            saveToDatabase(spbSupervise);
          } else {
            FlushBarManager.showFlushBarWarning(
                _navigationService.navigatorKey.currentContext!,
                "SPB ID",
                "Anda belum memasukkan spb id");
          }
        } else {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Nomor Kendaraan",
              "Anda belum memasukkan vendor");
        }
      } else {
        FlushBarManager.showFlushBarWarning(
            _navigationService.navigatorKey.currentContext!,
            "Vendor",
            "Anda belum memilih vendor");
      }
    } else {
      if (_vendorOther.text.isNotEmpty) {
        if (vehicleNumber.text.isNotEmpty) {
          if (_spbID.text.isNotEmpty) {
            SPBSupervise spbSupervise = SPBSupervise();
            spbSupervise.spbSuperviseId = _supervisiID;
            spbSupervise.spbId = _spbID.text;
            spbSupervise.supervisiSpbEmployeeCode =
                _mConfigSchema?.employeeCode;
            spbSupervise.supervisiSpbEmployeeName =
                _mConfigSchema?.employeeName;
            spbSupervise.supervisiEstateCode = _mEstateSchemaValue?.estateCode;
            spbSupervise.supervisiSpbLat = _position?.latitude.toString();
            spbSupervise.supervisiSpbLong = _position?.longitude.toString();
            spbSupervise.supervisiSpbDriverEmployeeCode = "";
            spbSupervise.supervisiSpbDriverEmployeeName = _vendorOther.text;
            spbSupervise.supervisiSpbDivisionCode =
                _scannedSPB!.spbDivisionCode;
            spbSupervise.supervisiSpbLicenseNumber = vehicleNumber.text;
            spbSupervise.supervisiSpbType =
                ValueService.spbSourceData(_sourceSPBValue);
            spbSupervise.supervisiSpbMethod =
                ValueService.typeOfFormToInt(_employeeTypeValue);
            spbSupervise.supervisiSpbPhoto = _pickedFile;
            spbSupervise.bunchesRipe = int.parse(_bunchesRipe.text);
            spbSupervise.bunchesOverripe = int.parse(_bunchesOverRipe.text);
            spbSupervise.bunchesHalfripe = int.parse(_bunchesHalfRipe.text);
            spbSupervise.bunchesUnripe = int.parse(_bunchesUnRipe.text);
            spbSupervise.bunchesAbnormal = int.parse(_bunchesAbnormal.text);
            spbSupervise.bunchesEmpty = int.parse(_bunchesEmpty.text);
            spbSupervise.looseFruits = int.parse(_looseFruits.text);
            spbSupervise.bunchesTotal = int.parse(_bunchesTotal.text);
            spbSupervise.bunchesTotalNormal =
                int.parse(_bunchesNormalTotal.text);
            spbSupervise.bunchesTangkaiPanjang =
                int.parse(_janjangTangkaiPanjang.text);
            spbSupervise.bunchesSampah = int.parse(_sampah.text);
            spbSupervise.bunchesBatu = int.parse(_batu.text);
            spbSupervise.catatanBunchesTangkaiPanjang =
                noteJanjangTangkaiPanjang.text;
            spbSupervise.supervisiNotes = _notesOPH.text;
            spbSupervise.createdBy = _mConfigSchema?.employeeName;
            spbSupervise.supervisiSpbDate = _date;
            spbSupervise.createdDate = _date;
            spbSupervise.createdTime = _time;
            saveToDatabase(spbSupervise);
          } else {
            FlushBarManager.showFlushBarWarning(
                _navigationService.navigatorKey.currentContext!,
                "SPB ID",
                "Anda belum memasukkan spb id");
          }
        } else {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Nomor Kendaraan",
              "Anda belum memasukkan vendor");
        }
      } else {
        FlushBarManager.showFlushBarWarning(
            _navigationService.navigatorKey.currentContext!,
            "Vendor",
            "Anda belum memasukkan vendor");
      }
    }
  }

  checkFormSaveTypeEmployeeInternal() {
    switch (_employeeTypeValue) {
      case "Internal":
        if (_driver != null) {
          if (_division != null) {
            if (_mEstateSchemaValue != null) {
              if (vehicleNumber.text.isNotEmpty) {
                if (_spbID.text.isNotEmpty) {
                  if (_bunchesTotal.text != "0" || _looseFruits.text != "0") {
                    SPBSupervise spbSupervise = SPBSupervise();
                    spbSupervise.spbSuperviseId = _supervisiID;
                    spbSupervise.spbId = _spbID.text;
                    spbSupervise.supervisiEstateCode =
                        _mEstateSchemaValue?.estateCode;
                    spbSupervise.supervisiSpbEmployeeCode =
                        _mConfigSchema?.employeeCode;
                    spbSupervise.supervisiSpbEmployeeName =
                        _mConfigSchema?.employeeName;
                    spbSupervise.supervisiSpbLat =
                        _position?.latitude.toString();
                    spbSupervise.supervisiSpbLong =
                        _position?.longitude.toString();
                    spbSupervise.supervisiSpbDriverEmployeeCode =
                        _driver?.employeeCode;
                    spbSupervise.supervisiSpbDriverEmployeeName =
                        _driver?.employeeName;
                    spbSupervise.supervisiSpbDivisionCode =
                        _division?.divisionCode;
                    spbSupervise.supervisiSpbLicenseNumber = vehicleNumber.text;
                    spbSupervise.supervisiSpbType =
                        ValueService.spbSourceData(_sourceSPBValue);
                    spbSupervise.supervisiSpbMethod =
                        ValueService.typeOfFormToInt(_employeeTypeValue);
                    spbSupervise.supervisiSpbPhoto = _pickedFile;
                    spbSupervise.bunchesRipe = int.parse(_bunchesRipe.text);
                    spbSupervise.bunchesOverripe =
                        int.parse(_bunchesOverRipe.text);
                    spbSupervise.bunchesHalfripe =
                        int.parse(_bunchesHalfRipe.text);
                    spbSupervise.bunchesUnripe = int.parse(_bunchesUnRipe.text);
                    spbSupervise.bunchesTangkaiPanjang =
                        int.parse(_janjangTangkaiPanjang.text);
                    spbSupervise.bunchesAbnormal =
                        int.parse(_bunchesAbnormal.text);
                    spbSupervise.bunchesEmpty = int.parse(_bunchesEmpty.text);
                    spbSupervise.looseFruits = int.parse(_looseFruits.text);
                    spbSupervise.bunchesTotal = int.parse(_bunchesTotal.text);
                    spbSupervise.bunchesTotalNormal =
                        int.parse(_bunchesNormalTotal.text);
                    spbSupervise.bunchesSampah = int.parse(_sampah.text);
                    spbSupervise.bunchesBatu = int.parse(_batu.text);
                    spbSupervise.catatanBunchesTangkaiPanjang =
                        noteJanjangTangkaiPanjang.text;
                    spbSupervise.supervisiNotes = _notesOPH.text;
                    spbSupervise.createdBy = _mConfigSchema?.employeeName;
                    spbSupervise.supervisiSpbDate = _date;
                    spbSupervise.createdDate = _date;
                    spbSupervise.createdTime = _time;
                    saveToDatabase(spbSupervise);
                  } else {
                    FlushBarManager.showFlushBarWarning(
                        _navigationService.navigatorKey.currentContext!,
                        "Grading",
                        "Anda belum mengisi grading");
                  }
                } else {
                  FlushBarManager.showFlushBarWarning(
                      _navigationService.navigatorKey.currentContext!,
                      "SPB ID",
                      "Anda belum mengisi SPB ID");
                }
              } else {
                FlushBarManager.showFlushBarWarning(
                    _navigationService.navigatorKey.currentContext!,
                    "Nomor Kendaraan",
                    "Anda belum mengisi nomor kendaraan");
              }
            } else {
              FlushBarManager.showFlushBarWarning(
                  _navigationService.navigatorKey.currentContext!,
                  "Estate",
                  "Anda belum mengisi estate");
            }
          } else {
            FlushBarManager.showFlushBarWarning(
                _navigationService.navigatorKey.currentContext!,
                "Divisi",
                "Anda belum memilih divisi");
          }
        } else {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Nama Supir",
              "Anda belum memilih supir");
        }
        break;
      case "Kontrak":
        if (!_isChecked) {
          if (_vendor != null) {
            if (_division != null) {
              if (_mEstateSchemaValue != null) {
                if (vehicleNumber.text.isNotEmpty) {
                  if (_spbID.text.isNotEmpty) {
                    SPBSupervise spbSupervise = SPBSupervise();
                    spbSupervise.spbSuperviseId = _supervisiID;
                    spbSupervise.spbId = _spbID.text;
                    spbSupervise.supervisiSpbEmployeeCode =
                        _mConfigSchema?.employeeCode;
                    spbSupervise.supervisiSpbEmployeeName =
                        _mConfigSchema?.employeeName;
                    spbSupervise.supervisiEstateCode =
                        _mEstateSchemaValue?.estateCode;
                    spbSupervise.supervisiSpbLat =
                        _position?.latitude.toString();
                    spbSupervise.supervisiSpbLong =
                        _position?.longitude.toString();
                    spbSupervise.supervisiSpbDriverEmployeeCode =
                        _vendor?.vendorCode;
                    spbSupervise.supervisiSpbDriverEmployeeName =
                        ValueService.rightTrimVendor(_vendor!.vendorName!);
                    spbSupervise.supervisiSpbDivisionCode =
                        _division?.divisionCode;
                    spbSupervise.supervisiSpbLicenseNumber = vehicleNumber.text;
                    spbSupervise.supervisiSpbType =
                        ValueService.spbSourceData(_sourceSPBValue);
                    spbSupervise.supervisiSpbMethod =
                        ValueService.typeOfFormToInt(_employeeTypeValue);
                    spbSupervise.supervisiSpbPhoto = _pickedFile;
                    spbSupervise.bunchesRipe = int.parse(_bunchesRipe.text);
                    spbSupervise.bunchesOverripe =
                        int.parse(_bunchesOverRipe.text);
                    spbSupervise.bunchesHalfripe =
                        int.parse(_bunchesHalfRipe.text);
                    spbSupervise.bunchesUnripe = int.parse(_bunchesUnRipe.text);
                    spbSupervise.bunchesAbnormal =
                        int.parse(_bunchesAbnormal.text);
                    spbSupervise.bunchesTangkaiPanjang =
                        int.parse(_janjangTangkaiPanjang.text);
                    spbSupervise.bunchesEmpty = int.parse(_bunchesEmpty.text);
                    spbSupervise.looseFruits = int.parse(_looseFruits.text);
                    spbSupervise.bunchesTotal = int.parse(_bunchesTotal.text);
                    spbSupervise.bunchesTotalNormal =
                        int.parse(_bunchesNormalTotal.text);
                    spbSupervise.bunchesSampah = int.parse(_sampah.text);
                    spbSupervise.bunchesBatu = int.parse(_batu.text);
                    spbSupervise.catatanBunchesTangkaiPanjang =
                        noteJanjangTangkaiPanjang.text;
                    spbSupervise.supervisiNotes = _notesOPH.text;
                    spbSupervise.createdBy = _mConfigSchema?.employeeName;
                    spbSupervise.supervisiSpbDate = _date;
                    spbSupervise.createdDate = _date;
                    spbSupervise.createdTime = _time;
                    saveToDatabase(spbSupervise);
                  } else {
                    FlushBarManager.showFlushBarWarning(
                        _navigationService.navigatorKey.currentContext!,
                        "SPB ID",
                        "Anda belum mengisi nomor SPB");
                  }
                } else {
                  FlushBarManager.showFlushBarWarning(
                      _navigationService.navigatorKey.currentContext!,
                      "Nomor Kendaraan",
                      "Anda belum mengisi nomor kendaraan");
                }
              } else {
                FlushBarManager.showFlushBarWarning(
                    _navigationService.navigatorKey.currentContext!,
                    "Estate",
                    "Anda belum memasukkan estate");
              }
            } else {
              FlushBarManager.showFlushBarWarning(
                  _navigationService.navigatorKey.currentContext!,
                  "Divisi",
                  "Anda belum memilih divisi");
            }
          } else {
            FlushBarManager.showFlushBarWarning(
                _navigationService.navigatorKey.currentContext!,
                "Vendor",
                "Anda belum memilih vendor");
          }
        } else {
          if (_vendorOther.text.isNotEmpty) {
            if (_division != null) {
              if (_mEstateSchemaValue != null) {
                if (vehicleNumber.text.isNotEmpty) {
                  if (_spbID.text.isNotEmpty) {
                    SPBSupervise spbSupervise = SPBSupervise();
                    spbSupervise.spbSuperviseId = _supervisiID;
                    spbSupervise.spbId = _spbID.text;
                    spbSupervise.supervisiSpbEmployeeCode =
                        _mConfigSchema?.employeeCode;
                    spbSupervise.supervisiSpbEmployeeName =
                        _mConfigSchema?.employeeName;
                    spbSupervise.supervisiEstateCode =
                        _mEstateSchemaValue?.estateCode;
                    spbSupervise.supervisiSpbLat =
                        _position?.latitude.toString();
                    spbSupervise.supervisiSpbLong =
                        _position?.longitude.toString();
                    spbSupervise.supervisiSpbDriverEmployeeCode =
                        _vendorOther.text;
                    spbSupervise.supervisiSpbDriverEmployeeName =
                        _vendorOther.text;
                    spbSupervise.supervisiSpbDivisionCode =
                        _division?.divisionCode;
                    spbSupervise.supervisiSpbLicenseNumber = vehicleNumber.text;
                    spbSupervise.supervisiSpbType =
                        ValueService.spbSourceData(_sourceSPBValue);
                    spbSupervise.supervisiSpbMethod =
                        ValueService.typeOfFormToInt(_employeeTypeValue);
                    spbSupervise.supervisiSpbPhoto = _pickedFile;
                    spbSupervise.bunchesRipe = int.parse(_bunchesRipe.text);
                    spbSupervise.bunchesOverripe =
                        int.parse(_bunchesOverRipe.text);
                    spbSupervise.bunchesHalfripe =
                        int.parse(_bunchesHalfRipe.text);
                    spbSupervise.bunchesUnripe = int.parse(_bunchesUnRipe.text);
                    spbSupervise.bunchesAbnormal =
                        int.parse(_bunchesAbnormal.text);
                    spbSupervise.bunchesEmpty = int.parse(_bunchesEmpty.text);
                    spbSupervise.looseFruits = int.parse(_looseFruits.text);
                    spbSupervise.bunchesTotal = int.parse(_bunchesTotal.text);
                    spbSupervise.bunchesTotalNormal =
                        int.parse(_bunchesNormalTotal.text);
                    spbSupervise.bunchesTangkaiPanjang =
                        int.parse(_janjangTangkaiPanjang.text);
                    spbSupervise.bunchesSampah = int.parse(_sampah.text);
                    spbSupervise.bunchesBatu = int.parse(_batu.text);
                    spbSupervise.catatanBunchesTangkaiPanjang =
                        noteJanjangTangkaiPanjang.text;
                    spbSupervise.supervisiNotes = _notesOPH.text;
                    spbSupervise.createdBy = _mConfigSchema?.employeeName;
                    spbSupervise.supervisiSpbDate = _date;
                    spbSupervise.createdDate = _date;
                    spbSupervise.createdTime = _time;
                    saveToDatabase(spbSupervise);
                  } else {
                    FlushBarManager.showFlushBarWarning(
                        _navigationService.navigatorKey.currentContext!,
                        "SPB ID",
                        "Anda belum mengisi nomor SPB");
                  }
                } else {
                  FlushBarManager.showFlushBarWarning(
                      _navigationService.navigatorKey.currentContext!,
                      "Nomor Kendaraan",
                      "Anda belum mengisi nomor kendaraan");
                }
              } else {
                FlushBarManager.showFlushBarWarning(
                    _navigationService.navigatorKey.currentContext!,
                    "Estate",
                    "Anda belum memasukkan estate");
              }
            } else {
              FlushBarManager.showFlushBarWarning(
                  _navigationService.navigatorKey.currentContext!,
                  "Divisi",
                  "Anda belum memilih divisi");
            }
          } else {
            FlushBarManager.showFlushBarWarning(
                _navigationService.navigatorKey.currentContext!,
                "Vendor",
                "Anda belum memasukkan nama vendor");
          }
        }
        break;
    }
  }

  saveToDatabase(SPBSupervise spbSupervise) async {
    _dialogService.popDialog();
    int count = await DatabaseSPBSupervise().insertSPBSupervise(spbSupervise);
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

  countBunchesTBSLuar(
      BuildContext context, TextEditingController textEditingController) {
    if (textEditingController.text.isEmpty ||
        textEditingController.text == "0" ||
        textEditingController.text == "00") {
      textEditingController.value = TextEditingValue(text: "0");
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
      String deductionText = (double.parse(_bunchesUnRipe.text) +
              double.parse(_bunchesHalfRipe.text) +
              double.parse(_bunchesOverRipe.text) +
              double.parse(_bunchesRotten.text) +
              double.parse(_brondolanRotten.text) +
              double.parse(_bunchesAbnormal.text) +
              double.parse(_bunchesEmpty.text) +
              double.parse(_rubbish.text) +
              double.parse(_water.text) +
              double.parse(_longStalk.text) +
              double.parse(_bunchesCengkeh.text) +
              double.parse(_bunchesLess4Kg.text))
          .toString();
      if (deductionText == "0.0") {
        _deduction.text = "0";
      } else {
        _deduction.text = deductionText;
      }
    } else {
      if (textEditingController != _bunchesTotal) {
        if (double.parse(textEditingController.text) > 1) {
          textEditingController.text =
              textEditingController.text.replaceFirst(RegExp(r'^0+'), "");
        }
      } else {
        textEditingController.text =
            textEditingController.text.replaceFirst(RegExp(r'^0+'), "");
      }
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
      String deductionText = (double.parse(_bunchesUnRipe.text) +
              double.parse(_bunchesHalfRipe.text) +
              double.parse(_bunchesOverRipe.text) +
              double.parse(_bunchesRotten.text) +
              double.parse(_brondolanRotten.text) +
              double.parse(_bunchesAbnormal.text) +
              double.parse(_bunchesEmpty.text) +
              double.parse(_rubbish.text) +
              double.parse(_water.text) +
              double.parse(_longStalk.text) +
              double.parse(_bunchesCengkeh.text) +
              double.parse(_bunchesLess4Kg.text))
          .toString();
      if (deductionText == "0.0") {
        _deduction.text = "0";
      } else {
        _deduction.text = deductionText;
      }
      notifyListeners();
    }
  }

  showDialogQuestionTBSLuar(BuildContext context) {
    generateTBSLuar(context);
  }

  generateTBSLuar(BuildContext context) {
    if (_vendor != null) {
      if (driverTBSLuar.text.isNotEmpty) {
        if (vehicleNumber.text.isNotEmpty) {
          if (_spbID.text.isNotEmpty) {
            if (_pickedFile != null) {
              if ((_bunchesTotal.text != "0" && _bunchesSmall.text == "0") ||
                  (_bunchesTotal.text == "0" && _bunchesSmall.text != "0")) {
                _tbsLuar = TBSLuar();
                _tbsLuar?.formType = _formType;
                _tbsLuar?.spdID = _spbID.text;
                _tbsLuar?.supplierCode = _vendor?.vendorCode;
                _tbsLuar?.supplierName = _vendor?.vendorName;
                _tbsLuar?.supervisiName = _mConfigSchema?.employeeName;
                _tbsLuar?.createdDate = _date;
                _tbsLuar?.createdTime = _time;
                _tbsLuar?.createdBy = _mConfigSchema?.employeeCode;
                _tbsLuar?.gpsLat = _position?.latitude;
                _tbsLuar?.gpsLong = _position?.longitude;
                _tbsLuar?.driverName = _driverTBSLuar.text;
                _tbsLuar?.licenseNumber = vehicleNumber.text;
                _tbsLuar?.sortasiID = _supervisiID;
                _tbsLuar?.bunchesUnripe = double.parse(_bunchesUnRipe.text);
                _tbsLuar?.bunchesUnripe = double.parse(_bunchesUnRipe.text);
                _tbsLuar?.bunchesHalfripe = double.parse(_bunchesHalfRipe.text);
                _tbsLuar?.bunchesOverripe = double.parse(_bunchesOverRipe.text);
                _tbsLuar?.bunchesRotten = double.parse(_bunchesRotten.text);
                _tbsLuar?.bunchesAbnormal = double.parse(_bunchesAbnormal.text);
                _tbsLuar?.bunchesEmpty = double.parse(_bunchesEmpty.text);
                _tbsLuar?.rubbish = double.parse(_rubbish.text);
                _tbsLuar?.water = double.parse(_water.text);
                _tbsLuar?.bunchesTotal = double.parse(_bunchesTotal.text);
                _tbsLuar?.deduction = double.parse(_deduction.text);
                _tbsLuar?.small = double.parse(_bunchesSmall.text);
                _tbsLuar?.medium = double.parse(_bunchesMedium.text);
                _tbsLuar?.large = double.parse(_bunchesLarge.text);
                _tbsLuar?.longStalk = double.parse(_longStalk.text);
                _tbsLuar?.bunchesCengkeh = double.parse(_bunchesCengkeh.text);
                _tbsLuar?.brondolanRotten = double.parse(_brondolanRotten.text);
                _tbsLuar?.bunchesLess4Kg = double.parse(_bunchesLess4Kg.text);
                _tbsLuar?.gradingPhoto = _pickedFile;
                _tbsLuar?.notes = _notesOPH.text;
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
    saveToDatabaseTBSLuar(tbsLuar);
  }

  onErrorWrite(BuildContext context) {
    FlushBarManager.showFlushBarWarning(
        context, "Supplier", "Nama Supplier belum terpilih");
  }

  onPressBatal() {
    NfcManager.instance.stopSession();
    _dialogService.popDialog();
  }

  onPressNoTBSLuar() {
    _dialogService.popDialog();
  }

  saveToDatabaseTBSLuar(TBSLuar tbsLuar) async {
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

  setQRResult(String result) async {
    var tag = result.split(',');
    TBSLuar? tbsLuar = await DatabaseTBSLuar().selectTBSLuarByID(tag[0]);
    Supervisi3rdParty? supervisi3rdParty =
        await DatabaseTBSLuarOneMonth().selectTBSLuarOneMonthByID(tag[0]);
    if (tbsLuar == null && supervisi3rdParty == null) {
      int totalBunches = 0;
      _spbID.text = tag[0];
      _listVendor.forEach((element) {
        if (tag[1] == element.vendorCode) {
          _vendor = element;
          notifyListeners();
        }
      });
      _driverTBSLuar.text = tag[2];
      vehicleNumber.text = tag[3].split('[').first;
      String farmer = result.split('[').last.split(']').first;
      farmer.split('#').forEach((element) {
        int total = int.parse(element.split(',')[1]);
        totalBunches = totalBunches + total;
      }); // brow
    } else {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "QR DO",
          "Sudah pernah scan Grading");
    }
  }

  checkDONumber(String idDO) async {
    TBSLuar? tbsLuar = await DatabaseTBSLuar().selectTBSLuarByID(idDO);
    if (tbsLuar != null) {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "QR DO",
          "Sudah pernah scan Grading");
    }
  }
}

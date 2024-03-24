import 'dart:convert';

import 'package:epms/base/common/locator.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/location_service.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/oph_card_manager.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/common_manager/validation_service.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/database/service/database_harvesting_plan.dart';
import 'package:epms/database/service/database_laporan_panen_kemarin.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_m_customer_code.dart';
import 'package:epms/database/service/database_m_division.dart';
import 'package:epms/database/service/database_m_employee.dart';
import 'package:epms/database/service/database_m_estate.dart';
import 'package:epms/database/service/database_m_vendor.dart';
import 'package:epms/database/service/database_oph.dart';
import 'package:epms/database/service/database_supervisor.dart';
import 'package:epms/database/service/database_t_abw.dart';
import 'package:epms/model/laporan_panen_kemarin.dart';
import 'package:epms/model/m_block_schema.dart';
import 'package:epms/model/m_c_oph_card_schema.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/m_customer_code_schema.dart';
import 'package:epms/model/m_division_schema.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/m_estate_schema.dart';
import 'package:epms/model/m_tph_schema.dart';
import 'package:epms/model/m_vendor_schema.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/supervisor.dart';
import 'package:epms/model/t_abw_schema.dart';
import 'package:epms/model/t_harvesting_plan_schema.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nfc_manager/nfc_manager.dart';

class FormOPHNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  OPH oph = OPH();

  bool _isChecked = false;

  bool get isChecked => _isChecked;

  String _ophID = "";

  String get ophID => _ophID;

  String _date = "";

  String get date => _date;

  String _time = "";

  String get time => _time;

  String _gpsLocation = "";

  String get gpsLocation => _gpsLocation;

  String _employeeType = "Internal";

  String get employeeType => _employeeType;

  Position? _position;

  Position? get position => _position;

  TextEditingController tphNumber = TextEditingController();

  TextEditingController _blockNumber = TextEditingController();

  TextEditingController get blockNumber => _blockNumber;

  TextEditingController ophNumber = TextEditingController();

  String? _pickedFile;

  String? get pickedFile => _pickedFile;

  List<String> _listEmployeeType = ["Internal", "Pinjam", "Kontrak"];

  List<String> get listEmployeeType => _listEmployeeType;

  MEmployeeSchema? _valueEmployee;

  MEmployeeSchema? get valueEmployee => _valueEmployee;

  List<MEmployeeSchema> _listEmployee = [];

  List<MEmployeeSchema> get listEmployee => _listEmployee;

  MEmployeeSchema? _valueMandorKontrak;

  MEmployeeSchema? get valueMandorKontrak => _valueMandorKontrak;

  List<MEmployeeSchema> _listMandorKontrak = [];

  List<MEmployeeSchema> get listMandorKontrak => _listMandorKontrak;

  List<MCustomerCodeSchema> _listMCustomer = [];

  List<MCustomerCodeSchema> get listMCustomer => _listMCustomer;

  List<MEstateSchema> _listEstate = [];

  List<MEstateSchema> get listEstate => _listEstate;

  MEstateSchema? _valueEstate;

  MEstateSchema? get valueEstate => _valueEstate;

  MCustomerCodeSchema? _valueMCustomer;

  MCustomerCodeSchema? get valueMCustomer => _valueMCustomer;

  MConfigSchema? _mConfigSchema;

  MConfigSchema? get mConfigSchema => _mConfigSchema;

  List<MDivisionSchema> _listDivision = [];

  List<MDivisionSchema> get listDivision => _listDivision;

  MDivisionSchema? _valueDivision;

  MDivisionSchema? get valueDivision => _valueDivision;

  List<MVendorSchema> _listVendor = [];

  List<MVendorSchema> get listVendor => _listVendor;

  MVendorSchema? _valueVendor;

  MVendorSchema? get valueVendor => _valueVendor;

  Supervisor? _supervisor;

  Supervisor? get supervisor => _supervisor;

  TextEditingController _notesOPH = TextEditingController();

  TextEditingController get notesOPH => _notesOPH;

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

  TextEditingController _bunchesNotSent = TextEditingController();

  TextEditingController get bunchesNotSent => _bunchesNotSent;

  double? _ophEstimationWeight = 0;

  double? get ophEstimationWeight => _ophEstimationWeight;

  MBlockSchema? _mBlockSchema;

  MBlockSchema? get mBlockSchema => _mBlockSchema;

  MCOPHCardSchema? _mcophCardSchema;

  MCOPHCardSchema? get mcophCardSchema => _mcophCardSchema;

  MTPHSchema? _mtphSchema;

  MTPHSchema? get mtphSchema => _mtphSchema;

  TABWSchema? _tabwSchema;

  TABWSchema? get tabwSchema => _tabwSchema;

  OPH? _ophLast;

  OPH? get ophLast => _ophLast;

  List<THarvestingPlanSchema> _listHarvestingPlan = [];

  List<THarvestingPlanSchema> get listHarvestingPlan => _listHarvestingPlan;

  generateVariable() async {
    MConfigSchema mConfigSchema = await DatabaseMConfig().selectMConfig();
    DateTime now = DateTime.now();
    NumberFormat formatterNumber = new NumberFormat("000");
    String number = formatterNumber.format(mConfigSchema.userId);
    _date = TimeManager.dateWithDash(now);
    _time = TimeManager.timeWithColon(now);
    _ophID = "${mConfigSchema.estateCode}" +
        ValueService.generateIDFromDateTime(now) +
        "$number" +
        "M";
    _mConfigSchema = mConfigSchema;
    bunchesRipe.text = "0";
    bunchesOverRipe.text = "0";
    bunchesHalfRipe.text = "0";
    bunchesUnRipe.text = "0";
    bunchesAbnormal.text = "0";
    bunchesEmpty.text = "0";
    looseFruits.text = "0";
    bunchesTotal.text = "0";
    bunchesNotSent.text = "0";
    notifyListeners();
  }

  onInitFormOPH(BuildContext context) async {
    _listEmployee = await DatabaseMEmployeeSchema().selectMEmployeeSchema();
    _listMandorKontrak =
        await DatabaseMEmployeeSchema().selectMEmployeeSchema();
    _listEstate = await DatabaseMEstateSchema().selectMEstateSchema();
    _listVendor = await DatabaseMVendorSchema().selectMVendorSchema();
    _supervisor = await DatabaseSupervisor().selectSupervisor();
    _listMCustomer =
        await DatabaseMCustomerCodeSchema().selectMCustomerCodeSchema();
    _listHarvestingPlan =
        await DatabaseTHarvestingPlan().selectTHarvestingPlan();
    _listEmployee.forEach((element) {
      if (element.employeeCode == _mConfigSchema?.employeeCode) {
        ophNumber.text = element.employeeDivisionCode!;
      }
    });
    final userRoles = await StorageManager.readData("userRoles");
    if (userRoles != null) {
      if (userRoles != 'KR') {
        getOPHLast();
      }
    }

    notifyListeners();
  }

  getOPHLast() async {
    _ophLast = await DatabaseOPH().selectOPHLast();
    if (_ophLast != null) {
      _employeeType =
          ValueService.typeOfFormToText(_ophLast!.ophHarvestingType!)!;
      _valueEmployee = MEmployeeSchema(
          employeeCode: _ophLast?.employeeCode,
          employeeName: _ophLast?.employeeName);
      if (_ophLast!.ophHarvestingType == 3) {
        _valueMandorKontrak = MEmployeeSchema(
            employeeCode: _supervisor?.mandorCode,
            employeeName: _supervisor?.mandorName);
        _valueVendor = MVendorSchema(
            vendorCode: _ophLast!.employeeCode,
            vendorName: ophLast!.employeeName);
        _mBlockSchema = await ValidationService.checkBlockSchema(
            _ophLast!.ophBlockCode!, _mConfigSchema!.estateCode!);
        _mBlockSchema ??
            FlushBarManager.showFlushBarWarning(
                _navigationService.navigatorKey.currentContext!,
                "Kode Blok",
                "Tidak sesuai dengan estate");
      } else if (_ophLast!.ophHarvestingType == 2) {
        for (int i = 0; i < _listMCustomer.length; i++) {
          if (_listMCustomer[i].customerCode == _ophLast!.ophCustomerCode) {
            _valueMCustomer = _listMCustomer[i];
            notifyListeners();
          }
        }
        _mBlockSchema = await ValidationService.checkBlockSchema(
            _ophLast!.ophBlockCode!,
            _valueMCustomer!.customerPlantCode!.substring(2));
        _mBlockSchema ??
            FlushBarManager.showFlushBarWarning(
                _navigationService.navigatorKey.currentContext!,
                "Kode Blok",
                "Tidak sesuai dengan estate");
      }
    }
  }

  getLocation() async {
    // _position = await LocationService.getGPSLocation();
    // if (_position != null) {
    //   _gpsLocation = "${_position?.longitude}, ${_position?.latitude}";
    // } else {
    //   _gpsLocation = "";
    // }
    // notifyListeners();
    while (_gpsLocation.isEmpty) {
      final _position = await LocationService.getGPSLocation();
      if (_position != null) {
        _gpsLocation = "${_position.longitude}, ${_position.latitude}";
        notifyListeners();
      }
    }
  }

  getEstimationTonnage() async {
    if (_mBlockSchema != null) {
      if (_employeeType == "Pinjam") {
        TABWSchema? tabwSchema = await DatabaseTABWSchema()
            .selectTABWSchemaByBlock(_mBlockSchema!.blockCode!,
                _valueMCustomer!.customerPlantCode!.substring(2));
        _ophEstimationWeight = (tabwSchema?.bunchWeight != null
            ? tabwSchema?.bunchWeight * int.parse(_bunchesTotal.text)
            : 0.0);
        _ophEstimationWeight =
            double.parse(_ophEstimationWeight!.toStringAsFixed(3));
        notifyListeners();
      } else {
        TABWSchema? tabwSchema = await DatabaseTABWSchema()
            .selectTABWSchemaByBlock(
                _mBlockSchema!.blockCode!, _mConfigSchema!.estateCode!);
        _ophEstimationWeight = (tabwSchema?.bunchWeight != null
            ? tabwSchema?.bunchWeight * int.parse(_bunchesTotal.text)
            : 0.0);
        _ophEstimationWeight =
            double.parse(_ophEstimationWeight!.toStringAsFixed(3));
        notifyListeners();
      }
    }
  }

  void tPHNumberCheck(BuildContext context, String tphCode) async {
    if (tphCode.isNotEmpty) {
      if (_employeeType == "Pinjam") {
        _mtphSchema = await ValidationService.checkMTPHSchema(
            tphCode,
            _valueMCustomer!.customerPlantCode!.substring(2),
            _blockNumber.text);
        _mtphSchema ??
            FlushBarManager.showFlushBarWarning(
                context, "Kode TPH", "Tidak sesuai");
      } else {
        _mtphSchema = await ValidationService.checkMTPHSchema(
            tphCode, _mConfigSchema!.estateCode!, _blockNumber.text);
        _mtphSchema ??
            FlushBarManager.showFlushBarWarning(
                context, "Kode TPH", "Tidak sesuai");
      }
      getEstimationTonnage();
    }
    notifyListeners();
  }

  void blockNumberCheck(BuildContext context, String block) async {
    if (block.isNotEmpty) {
      if (_employeeType == "Pinjam") {
        block.toUpperCase();
        _mBlockSchema = await ValidationService.checkBlockSchema(
            block, _valueMCustomer!.customerPlantCode!.substring(2));
        _mBlockSchema ??
            FlushBarManager.showFlushBarWarning(
                context, "Kode Blok", "Tidak sesuai dengan estate");
      } else {
        block.toUpperCase();
        _mBlockSchema = await ValidationService.checkBlockSchema(
            block, _mConfigSchema!.estateCode!);
        _mBlockSchema ??
            FlushBarManager.showFlushBarWarning(
                context, "Kode Blok", "Tidak sesuai dengan estate");
      }
      getEstimationTonnage();
    } else {
      _mBlockSchema = null;
    }
    notifyListeners();
  }

  void cardOPHNumberCheck(BuildContext context, String ophCard) async {
    if (ophCard.isNotEmpty) {
      ophCard.toUpperCase();
      _mcophCardSchema = await ValidationService.checkMCOPHCardSchema(ophCard);
      _mcophCardSchema ??
          FlushBarManager.showFlushBarWarning(
              context, "Kode Kartu OPH", "Tidak sesuai");
      notifyListeners();
    }
  }

  getCamera(BuildContext context) async {
    String? picked = await CameraService.getImageByCamera(context);
    if (picked != null) {
      _pickedFile = picked;
      notifyListeners();
    }
  }

  countBunches() {
    try {
      bunchesTotal.text = (int.parse(bunchesRipe.text) +
              int.parse(bunchesOverRipe.text) +
              int.parse(bunchesHalfRipe.text) +
              int.parse(bunchesUnRipe.text) +
              int.parse(bunchesAbnormal.text) +
              int.parse(bunchesEmpty.text))
          .toString();
      getEstimationTonnage();
    } catch (e) {
      print('cek error $e');
      print(e);
    }
  }

  onSaveClicked(BuildContext context) async {
    try {
      oph.ophId = _ophID;
      oph.createdDate = _date;
      oph.createdTime = _time;
      oph.ophLat = _position?.latitude.toString();
      oph.ophLong = _position?.longitude.toString();
      oph.ophHarvestingType = ValueService.typeOfFormToInt(_employeeType);
      oph.ophHarvestingMethod = isChecked ? 2 : 1;
      if (_listHarvestingPlan
          .any((item) => item.harvestingPlanBlockCode == _blockNumber.text)) {
        oph.isPlanned = 1;
      } else {
        oph.isPlanned = 0;
      }
      if (_employeeType == "Internal") {
        oph.employeeName = _valueEmployee?.employeeName;
        oph.employeeCode = _valueEmployee?.employeeCode;
        oph.ophEstateCode = _mConfigSchema?.estateCode;
        oph.ophDivisionCode = _mBlockSchema?.blockDivisionCode;
        oph.mandor1EmployeeName = _supervisor?.mandor1Name;
        oph.mandor1EmployeeCode = _supervisor?.mandor1Code;
        oph.keraniKirimEmployeeCode = _supervisor?.keraniKirimCode;
        oph.keraniKirimEmployeeName = _supervisor?.keraniKirimName;
        oph.keraniPanenEmployeeName = _supervisor?.keraniPanenName;
        oph.keraniPanenEmployeeCode = _supervisor?.keraniPanenCode;
        oph.mandorEmployeeCode = _supervisor?.mandorCode;
        oph.mandorEmployeeName = _supervisor?.mandorName;
      }
      if (_employeeType == "Pinjam") {
        oph.employeeName = _valueEmployee?.employeeName;
        oph.employeeCode = _valueEmployee?.employeeCode;
        oph.ophCustomerCode = _valueMCustomer?.customerCode;
        oph.ophEstateCode = _valueMCustomer?.customerPlantCode?.substring(2);
        oph.ophDivisionCode = _mBlockSchema?.blockDivisionCode;
        oph.mandor1EmployeeName = _supervisor?.mandor1Name;
        oph.mandor1EmployeeCode = _supervisor?.mandor1Code;
        oph.keraniKirimEmployeeCode = _supervisor?.keraniKirimCode;
        oph.keraniKirimEmployeeName = _supervisor?.keraniKirimName;
        oph.keraniPanenEmployeeName = _supervisor?.keraniPanenName;
        oph.keraniPanenEmployeeCode = _supervisor?.keraniPanenCode;
        oph.mandorEmployeeCode = _supervisor?.mandorCode;
        oph.mandorEmployeeName = _supervisor?.mandorName;
        oph.ophCustomerCode = _valueMCustomer?.customerCode;
      }
      if (_employeeType == "Kontrak") {
        oph.employeeName = _valueEmployee?.employeeName;
        oph.employeeCode = _valueEmployee?.employeeCode;
        oph.ophEstateCode = _mConfigSchema?.estateCode;
        oph.ophDivisionCode = _mBlockSchema?.blockDivisionCode;
        oph.mandor1EmployeeName = _supervisor?.mandor1Name;
        oph.mandor1EmployeeCode = _supervisor?.mandor1Code;
        oph.keraniKirimEmployeeCode = _supervisor?.keraniKirimCode;
        oph.keraniKirimEmployeeName = _supervisor?.keraniKirimName;
        oph.keraniPanenEmployeeName = _supervisor?.keraniPanenName;
        oph.keraniPanenEmployeeCode = _supervisor?.keraniPanenCode;
        oph.mandorEmployeeCode = _valueMandorKontrak?.employeeCode;
        oph.mandorEmployeeName = _valueMandorKontrak?.employeeName;
        oph.employeeName =
            ValueService.rightTrimVendor(_valueVendor!.vendorName!);
        oph.employeeCode = _valueVendor?.vendorCode;
      }
      oph.ophBlockCode = _mBlockSchema?.blockCode;
      oph.ophTphCode = _mtphSchema?.tphCode;
      oph.ophCardId = _mcophCardSchema?.ophCardId;
      oph.ophPlantCode = _mConfigSchema?.plantCode;
      oph.ophNotes = _notesOPH.text;
      oph.ophPhoto = _pickedFile;
      oph.bunchesRipe = int.parse(_bunchesRipe.text);
      oph.bunchesOverripe = int.parse(_bunchesOverRipe.text);
      oph.bunchesHalfripe = int.parse(_bunchesHalfRipe.text);
      oph.bunchesUnripe = int.parse(_bunchesUnRipe.text);
      oph.bunchesAbnormal = int.parse(_bunchesAbnormal.text);
      oph.bunchesEmpty = int.parse(_bunchesEmpty.text);
      oph.looseFruits = int.parse(_looseFruits.text);
      oph.bunchesTotal = int.parse(_bunchesTotal.text);
      oph.bunchesNotSent = int.parse(_bunchesNotSent.text);
      oph.isApproved = 0;
      oph.isRestantPermanent = 0;
      oph.ophEstimateTonnage = _ophEstimationWeight;
      oph.createdBy = _mConfigSchema?.employeeCode;
      notifyListeners();
      showDialogQuestion();
    } catch (e) {
      _dialogService.showNoOptionDialog(
          title: "OPH Belum lengkap",
          subtitle: "Pastikan menginput dengan lengkap",
          onPress: _dialogService.popDialog);
    }
  }

  showDialogQuestion() {
    dialogNFC();
    // _dialogService.showOptionDialog(
    //     title: "Memakai Kartu NFC",
    //     subtitle: "Apakah ingin menyimpan data dengan NFC?",
    //     buttonTextYes: "Ya",
    //     buttonTextNo: "Tidak",
    //     onPressYes: dialogNFC,
    //     onPressNo: saveOPHtoDatabase);
  }

  saveOPHtoDatabase() async {
    int count = await DatabaseOPH().insertOPH(oph);
    if (count > 0) {
      try {
        Future.delayed(Duration(seconds: 1), () {
          NfcManager.instance.stopSession();
        });
        // addLaporanPanenKemarin();
        _dialogService.popDialog();
        _navigationService.pop();
        FlushBarManager.showFlushBarSuccess(
            _navigationService.navigatorKey.currentContext!,
            "OPH Tersimpan",
            "Berhasil menyimpan OPH");
        StorageManager.saveData("blockDefault", oph.ophBlockCode);
      } catch (e) {
        FlushBarManager.showFlushBarWarning(
            _navigationService.navigatorKey.currentContext!,
            "OPH Tersimpan",
            "Gagal menyimpan OPH");
      }
    } else {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "OPH Tersimpan",
          "Gagal menyimpan OPH");
    }
  }

  addLaporanPanenKemarin() async {
    Map<String, dynamic> map = jsonDecode(jsonEncode(oph));
    LaporanPanenKemarin laporanPanenKemarin = LaporanPanenKemarin.fromJson(map);
    List<LaporanPanenKemarin> listLaporanPanenKemarin = [];
    listLaporanPanenKemarin.add(laporanPanenKemarin);
    await DatabaseLaporanPanenKemarin()
        .insertLaporanPanenKemarin(listLaporanPanenKemarin);
  }

  dialogNFC() {
    // _dialogService.popDialog();
    OPHCardManager().writeOPHCard(
        _navigationService.navigatorKey.currentContext!,
        oph,
        onSuccessWrite,
        onErrorWrite);
    _dialogService.showNFCDialog(
        title: "Tempel Kartu NFC",
        subtitle: "Untuk memasukkan data",
        buttonText: "Batal",
        onPress: onPressBatal);
  }

  onSuccessWrite(BuildContext context, OPH oph) {
    saveOPHtoDatabase();
  }

  onErrorWrite(BuildContext context) {
    _dialogService.popDialog();
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
    FlushBarManager.showFlushBarWarning(context, "OPH", "Gagal menyimpan OPH");
  }

  onPressBatal() {
    NfcManager.instance.stopSession();
    _dialogService.popDialog();
  }

  onSetEmployeeType(String value) {
    _employeeType = value;
    _valueEmployee = null;
    _mBlockSchema = null;
    _mtphSchema = null;
    blockNumber.clear();
    tphNumber.clear();
    if (_employeeType == "Kontrak") {
      MEmployeeSchema mandorKontrak = MEmployeeSchema(
          employeeCode: _supervisor?.mandorCode,
          employeeName: _supervisor?.mandorName);
      _valueMandorKontrak = mandorKontrak;
    }
    getEstimationTonnage();
    notifyListeners();
  }

  onSetHarvestingMethod(bool value) {
    _isChecked = value;
    notifyListeners();
  }

  onSetMandorKontrak(MEmployeeSchema value) {
    _valueMandorKontrak = value;
    notifyListeners();
  }

  onSetEmployee(MEmployeeSchema value) {
    if (_listEmployee.contains(value)) {
      _valueEmployee = value;
      notifyListeners();
    } else {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Pekerja",
          "Pekerja yang dipilih diluar kemandoran");
    }
  }

  onSetCustomer(MCustomerCodeSchema value) {
    if (_valueMCustomer == value) {
      _valueMCustomer = value;
      onSetListDivision(value.customerPlantCode!.substring(2));
    } else {
      _valueMCustomer = value;
      _valueDivision = null;
      onSetListDivision(value.customerPlantCode!.substring(2));
    }
    getEstimationTonnage();
    notifyListeners();
  }

  onSetListDivision(String estateCode) async {
    _listDivision = await DatabaseMDivisionSchema()
        .selectMDivisionSchemaByEstate(estateCode);
    notifyListeners();
  }

  onSetEstate(MEstateSchema value) {
    _valueEstate = value;
    notifyListeners();
  }

  onSetDivision(MDivisionSchema value) {
    _valueDivision = value;
    notifyListeners();
  }

  onSetVendor(MVendorSchema value) {
    _valueVendor = value;
    notifyListeners();
  }

  checkFormGenerator(BuildContext context) {
    tPHNumberCheck(context, tphNumber.text);
    blockNumberCheck(context, _blockNumber.text);
    switch (_employeeType) {
      case "Internal":
        if (_valueEmployee != null) {
          if (_blockNumber.text.isNotEmpty) {
            if (_mBlockSchema != null) {
              if (tphNumber.text.isNotEmpty) {
                if (mtphSchema != null) {
                  if (ophNumber.text.isNotEmpty) {
                    if (_mcophCardSchema != null) {
                      if (_pickedFile != null) {
                        if (_bunchesTotal.text != "0" ||
                            _looseFruits.text != "0") {
                          if (!(int.parse(_bunchesNotSent.text) >
                              int.parse(_bunchesTotal.text))) {
                            onSaveClicked(context);
                          } else {
                            FlushBarManager.showFlushBarWarning(
                                context,
                                "Janjang Grading",
                                "Jumlah janjang tidak dikirim lebih besar dari total janjang");
                          }
                        } else {
                          FlushBarManager.showFlushBarWarning(
                              context,
                              "Janjang Grading",
                              "Anda belum memasukkan Grading");
                        }
                      } else {
                        FlushBarManager.showFlushBarWarning(
                            context, "Foto OPH", "Anda belum memasukkan Foto");
                      }
                    } else {
                      FlushBarManager.showFlushBarWarning(context,
                          "Nomor Kartu OPH", "Nomor Kartu OPH tidak sesuai");
                    }
                  } else {
                    FlushBarManager.showFlushBarWarning(
                        context,
                        "Nomor Kartu OPH",
                        "Anda belum memasukkan nomor Kartu OPH");
                  }
                } else {
                  FlushBarManager.showFlushBarWarning(
                      context, "Kode TPH", "Kode TPH tidak sesuai");
                }
              } else {
                FlushBarManager.showFlushBarWarning(
                    context, "Kode TPH", "Anda belum memasukkan nomor TPH");
              }
            } else {
              FlushBarManager.showFlushBarWarning(
                  context, "Kode Blok", "Kode Blok tidak sesuai");
            }
          } else {
            FlushBarManager.showFlushBarWarning(
                context, "Kode Blok", "Anda belum memasukkan block");
          }
        } else {
          FlushBarManager.showFlushBarWarning(
              context, "Pekerja", "Anda belum memilih pekerja");
        }
        break;
      case "Pinjam":
        if (_valueEmployee != null) {
          if (_valueMCustomer != null) {
            if (_valueMCustomer?.customerPlantCode!.substring(2) !=
                _mConfigSchema?.estateCode) {
              if (_blockNumber.text.isNotEmpty) {
                if (_mBlockSchema != null) {
                  if (tphNumber.text.isNotEmpty) {
                    if (mtphSchema != null) {
                      if (ophNumber.text.isNotEmpty) {
                        if (_mcophCardSchema != null) {
                          if (_pickedFile != null) {
                            if (_bunchesTotal.text != "0" ||
                                _looseFruits.text != "0") {
                              if (!(int.parse(_bunchesNotSent.text) >
                                  int.parse(_bunchesTotal.text))) {
                                onSaveClicked(context);
                              } else {
                                FlushBarManager.showFlushBarWarning(
                                    context,
                                    "Janjang Grading",
                                    "Jumlah janjang tidak dikirim lebih besar dari total janjang");
                              }
                            } else {
                              FlushBarManager.showFlushBarWarning(
                                  context,
                                  "Janjang Grading",
                                  "Anda belum memasukkan Grading");
                            }
                          } else {
                            FlushBarManager.showFlushBarWarning(context,
                                "Foto OPH", "Anda belum memasukkan Foto");
                          }
                        } else {
                          FlushBarManager.showFlushBarWarning(
                              context,
                              "Nomor Kartu OPH",
                              "Nomor Kartu OPH tidak sesuai");
                        }
                      } else {
                        FlushBarManager.showFlushBarWarning(
                            context,
                            "Nomor Kartu OPH",
                            "Anda belum memasukkan nomor Kartu OPH");
                      }
                    } else {
                      FlushBarManager.showFlushBarWarning(
                          context, "Kode TPH", "Kode TPH tidak sesuai");
                    }
                  } else {
                    FlushBarManager.showFlushBarWarning(
                        context, "Kode TPH", "Anda belum memasukkan nomor TPH");
                  }
                } else {
                  FlushBarManager.showFlushBarWarning(
                      context, "Kode Blok", "Kode Blok tidak sesuai");
                }
              } else {
                FlushBarManager.showFlushBarWarning(
                    context, "Kode Blok", "Anda belum memasukkan block");
              }
            } else {
              FlushBarManager.showFlushBarWarning(context, "Estate",
                  "Estate tidak boleh sama dengan estate sekarang");
            }
          } else {
            FlushBarManager.showFlushBarWarning(
                context, "Customer", "Anda belum mengisi customer");
          }
        } else {
          FlushBarManager.showFlushBarWarning(
              context, "Pekerja", "Anda belum memilih pekerja");
        }
        break;
      case "Kontrak":
        if (_valueMandorKontrak != null) {
          if (_blockNumber.text.isNotEmpty) {
            if (_mBlockSchema != null) {
              if (tphNumber.text.isNotEmpty) {
                if (mtphSchema != null) {
                  if (ophNumber.text.isNotEmpty) {
                    if (_mcophCardSchema != null) {
                      if (_pickedFile != null) {
                        if (_bunchesTotal.text != "0" ||
                            _looseFruits.text != "0") {
                          if (!(int.parse(_bunchesNotSent.text) >
                              int.parse(_bunchesTotal.text))) {
                            onSaveClicked(context);
                          } else {
                            FlushBarManager.showFlushBarWarning(
                                context,
                                "Janjang Grading",
                                "Jumlah janjang tidak dikirim lebih besar dari total janjang");
                          }
                        } else {
                          FlushBarManager.showFlushBarWarning(
                              context,
                              "Janjang Grading",
                              "Anda belum memasukkan Grading");
                        }
                      } else {
                        FlushBarManager.showFlushBarWarning(
                            context, "Foto OPH", "Anda belum memasukkan Foto");
                      }
                    } else {
                      FlushBarManager.showFlushBarWarning(context,
                          "Nomor Kartu OPH", "Nomor Kartu OPH tidak sesuai");
                    }
                  } else {
                    FlushBarManager.showFlushBarWarning(
                        context,
                        "Nomor Kartu OPH",
                        "Anda belum memasukkan nomor Kartu OPH");
                  }
                } else {
                  FlushBarManager.showFlushBarWarning(
                      context, "Nomor TPH", "Kode TPH tidak sesuai");
                }
              } else {
                FlushBarManager.showFlushBarWarning(
                    context, "Nomor TPH", "Anda belum memasukkan nomor TPH");
              }
            } else {
              FlushBarManager.showFlushBarWarning(
                  context, "Kode Blok", "Kode Blok tidak sesuai");
            }
          } else {
            FlushBarManager.showFlushBarWarning(
                context, "Kode Blok", "Anda belum memasukkan blok");
          }
        } else {
          FlushBarManager.showFlushBarWarning(
              context, "Kemandoran", "Anda belum memilih kemandoran");
        }
        break;
    }
  }
}

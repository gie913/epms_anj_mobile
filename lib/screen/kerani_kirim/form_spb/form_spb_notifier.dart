import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:epms/base/common/locator.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/location_service.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/oph_card_manager.dart';
import 'package:epms/common_manager/spb_card_manager.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/database/service/database_destination.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_m_employee.dart';
import 'package:epms/database/service/database_m_estate.dart';
import 'package:epms/database/service/database_m_vendor.dart';
import 'package:epms/database/service/database_m_vra.dart';
import 'package:epms/database/service/database_mc_spb.dart';
import 'package:epms/database/service/database_spb.dart';
import 'package:epms/database/service/database_spb_detail.dart';
import 'package:epms/database/service/database_spb_loader.dart';
import 'package:epms/model/m_c_spb_card_schema.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/m_destination_schema.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/m_estate_schema.dart';
import 'package:epms/model/m_vendor_schema.dart';
import 'package:epms/model/m_vras_schema.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_detail.dart';
import 'package:epms/model/spb_loader.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nfc_manager/nfc_manager.dart';

class FormSPBNotifier extends ChangeNotifier {
  ScrollController _scrollController = new ScrollController();

  ScrollController get scrollController => _scrollController;

  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  int _countOPH = 0;

  int get countOPH => _countOPH;

  String? _date;

  String? get date => _date;

  String? _time;

  String? get time => _time;

  String? _spbID;

  String? get spbID => _spbID;

  MConfigSchema? _mConfigSchema;

  MConfigSchema? get mConfigSchema => _mConfigSchema;

  MEstateSchema? _mEstateSchema;

  MEstateSchema? get mEstateSchema => _mEstateSchema;

  String _gpsLocation = "";

  String get gpsLocation => _gpsLocation;

  String _typeDeliverValue = "Internal";

  String get typeDeliverValue => _typeDeliverValue;

  Position? _position;

  Position? get position => _position;

  List<String> typeDeliver = ["Internal", "Kontrak"];

  List<MDestinationSchema> _destinationList = [];

  List<MDestinationSchema> get destinationList => _destinationList;

  MDestinationSchema? _destinationValue;

  MDestinationSchema? get destinationValue => _destinationValue;

  MEmployeeSchema? _driverNameValue;

  MEmployeeSchema? get driverNameValue => _driverNameValue;

  List<MEmployeeSchema> _driverNameList = [];

  List<MEmployeeSchema> get driverNameList => _driverNameList;

  List<MEmployeeSchema> _listLoader = [];

  List<MEmployeeSchema> get listLoader => _listLoader;

  List<MVendorSchema> _vendorList = [];

  List<MVendorSchema> get vendorList => _vendorList;

  MVendorSchema? _vendorSchemaValue;

  MVendorSchema? get vendorSchemaValue => _vendorSchemaValue;

  bool _isCheckedOther = false;

  bool get isCheckedOther => _isCheckedOther;

  TextEditingController _vendorOther = TextEditingController();

  TextEditingController get vendorOther => _vendorOther;

  TextEditingController vehicleNumber = TextEditingController();

  TextEditingController spbCardNumber = TextEditingController();

  TextEditingController _notesSPB = TextEditingController();

  TextEditingController get notesSPB => _notesSPB;

  List<SPBLoader> _spbLoaderList = [];

  List<SPBLoader> get spbLoaderList => _spbLoaderList;

  String? _pickedFile;

  String? get pickedFile => _pickedFile;

  int _countOPHList = 0;

  int get countOPHList => _countOPHList;

  List<String> _loaderType = [];

  List<String> get loaderType => _loaderType;

  List<MVendorSchema?> _vendorName = [];

  List<MVendorSchema?> get vendorName => _vendorName;

  List<MEmployeeSchema?> _loaderName = [];

  List<MEmployeeSchema?> get loaderName => _loaderName;

  List<MEmployeeSchema> _loaderTypeList = [];

  List<MEmployeeSchema> get loaderTypeList => _loaderTypeList;

  List<String> _jenisAngkut = ["TPH-PKS", "TPB-PKS"];

  List<String> get jenisAngkut => _jenisAngkut;

  List<String> _jenisAngkutValue = [];

  List<String> get jenisAngkutValue => _jenisAngkutValue;

  List<TextEditingController> _percentageAngkut = [];

  List<TextEditingController> get percentageAngkut => _percentageAngkut;

  int _totalPercentageAngkut = 0;

  int get totalPercentageAngkut => _totalPercentageAngkut;

  List<SPBDetail> _listSPBDetail = [];

  List<SPBDetail> get listSPBDetail => _listSPBDetail;

  int _totalBunches = 0;

  int get totalBunches => _totalBunches;

  int _totalLooseFruits = 0;

  int get totalLooseFruits => _totalLooseFruits;

  double _totalWeightEstimation = 0;

  double get totalWeightEstimation => _totalWeightEstimation;

  double _totalCapacityTruck = 0;

  double get totalCapacityTruck => _totalCapacityTruck;

  int _totalWeightActual = 0;

  int get totalWeightActual => _totalWeightActual;

  SPB _globalSPB = SPB();

  SPB get globalSPB => _globalSPB;

  String? _messageThis;

  String? get messageThis => _messageThis;

  MVRASchema? _mvraSchema;

  MVRASchema? get mvraSchema => _mvraSchema;

  MCSPBCardSchema? _mcspbCardSchema;

  MCSPBCardSchema? get mcspbCardSchema => _mcspbCardSchema;

  bool _isOthersVendor = false;

  bool get isOthersVendor => _isOthersVendor;

  String _lastOPH = "";

  String get lastOPH => _lastOPH;

  String? _mDivisionCode;

  String? get mDivisionCode => _mDivisionCode;

  String? _estateCode;

  String? get estateCode => _estateCode;

  bool _isLoaderExist = false;

  bool get isLoaderExist => _isLoaderExist;

  bool _isLoaderZero = false;

  bool get isLoaderZero => _isLoaderZero;

  List<OPH> _listOPHScanned = [];

  List<OPH> get listOPHScanned => _listOPHScanned;

  /*On init Form SPB*/

  onInitFormSPB() async {
    generateVariable();
    _driverNameList =
        await DatabaseMEmployeeSchema().selectMEmployeeSchemaDriver();
    _listLoader = await DatabaseMEmployeeSchema().selectMEmployeeSchema();
    _destinationList =
        await DatabaseMDestinationSchema().selectMDestinationSchema();
    _vendorList = await DatabaseMVendorSchema().selectMVendorSchema();
    _listLoader.forEach((element) {
      if (element.employeeCode == _mConfigSchema?.employeeCode) {
        spbCardNumber.text = element.employeeDivisionCode!;
      }
    });
    // addOPH();
    notifyListeners();
  }

  generateVariable() async {
    _mConfigSchema = await DatabaseMConfig().selectMConfig();
    DateTime now = DateTime.now();
    NumberFormat formatterNumber = new NumberFormat("000");
    String number = formatterNumber.format(_mConfigSchema?.userId!);
    _date = TimeManager.dateWithDash(now);
    _time = TimeManager.timeWithColon(now);
    _spbID = "${_mConfigSchema?.estateCode}" +
        ValueService.generateIDFromDateTime(now) +
        "$number" +
        "M";
    getLocation();
    notifyListeners();
  }

  addOPH() {
    for (int i = 0; i < 100; i++) {
      SPBDetail spbDetail = SPBDetail(
          spbId: "01100110011010${i}M",
          ophId: "02020202020010${i}M",
          ophBunchesDelivered: 10,
          ophLooseFruitDelivered: 20,
          ophBlockCode: "C10",
          ophTphCode: '10',
          ophCardId: 'A001');
      listSPBDetail.add(spbDetail);
    }
  }

  getLocation() async {
    _position = await LocationService.getGPSLocation();
    if (_position != null) {
      _gpsLocation = "${_position?.longitude}, ${_position?.latitude}";
    } else {
      _gpsLocation = "";
    }
    notifyListeners();
  }

  /*on Change Variable*/

  onChangeDeliveryType(String value) {
    _typeDeliverValue = value;
    notifyListeners();
  }

  onChangeDestination(MDestinationSchema mDestinationSchema) {
    _destinationValue = mDestinationSchema;
    notifyListeners();
  }

  onChangeVendor(MVendorSchema mVendorSchema) {
    _vendorSchemaValue = mVendorSchema;
    notifyListeners();
  }

  onChangeDriver(MEmployeeSchema mEmployeeSchema) {
    if (_driverNameList.contains(mEmployeeSchema)) {
      _driverNameValue = mEmployeeSchema;
      notifyListeners();
    } else {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Supir Kendaraan",
          "Pekerja yang dipilih bukan supir");
    }
  }

  onCheckOtherVendor(bool value) {
    _isOthersVendor = value;
    notifyListeners();
  }

  Future getCamera(BuildContext context) async {
    String? picked = await CameraService.getImageByCamera(context);
    if (picked != null) {
      _pickedFile = picked;
      notifyListeners();
    }
  }

  checkVehicle(BuildContext context, String vehicleNumber) async {
    if (vehicleNumber.isNotEmpty) {
      if (_typeDeliverValue != "Kontrak") {
        _mvraSchema =
            await DatabaseMVRASchema().selectMVRASchemaByNumber(vehicleNumber);
        _mvraSchema ??
            FlushBarManager.showFlushBarWarning(
                context, "Nomor Kendaraan", "Tidak sesuai");
        _totalCapacityTruck = _mvraSchema!.vraMaxCap!.toDouble();
        if (_mvraSchema != null) {
          _totalCapacityTruck = _totalCapacityTruck - _totalWeightEstimation;
        }
      } else {
        _mvraSchema =
            await DatabaseMVRASchema().selectMVRASchemaByNumber(vehicleNumber);
        if (_mvraSchema != null) {
          _totalCapacityTruck = _mvraSchema!.vraMaxCap!.toDouble();
        }
      }
    }
    notifyListeners();
  }

  checkLoaderExist() {
    int count = 0;
    for (int i = 0; i < _spbLoaderList.length; i++) {
      count = _spbLoaderList
          .where((c) =>
              c.loaderEmployeeName == _spbLoaderList[i].loaderEmployeeName)
          .length;
    }
    if (count > 1) {
      _isLoaderExist = true;
    } else {
      _isLoaderExist = false;
    }
  }

  checkLoaderPercentageValue() {
    int count = 0;
    for (int i = 0; i < _spbLoaderList.length; i++) {
      count = _spbLoaderList.where((c) => c.loaderPercentage! <= 0).length;
    }
    if (count >= 1) {
      _isLoaderZero = true;
    } else {
      _isLoaderZero = false;
    }
  }

  checkSPBCard(BuildContext context, String spbCardID) async {
    if (spbCardID.isNotEmpty) {
      _mcspbCardSchema =
          await DatabaseMCSPBCardSchema().selectMCSPBCardSchema(spbCardID);
      _mcspbCardSchema ??
          FlushBarManager.showFlushBarWarning(
              context, "No Kartu SPB", "Tidak sesuai");
    }
    notifyListeners();
  }

  /*on OPH Add*/

  onClickScanOPH(BuildContext context) {
    OPHCardManager().readOPHCard(context, onSuccessRead, onErrorRead);
    _dialogService.showDialogScanOPH(
        title: "Tempel Kartu OPH",
        subtitle: "untuk membaca data",
        ophCount: _countOPH,
        lastOPH: _lastOPH,
        buttonText: "Selesai",
        onPress: onCancelScanOPH);
  }

  String generate4Digits() {
    var rng = Random();
    String generatedNumber = '';
    for (int i = 0; i < 4; i++) {
      generatedNumber += (rng.nextInt(9) + 1).toString();
    }
    return generatedNumber;
  }

  onCancelScanOPH() {
    _dialogService.popDialog();
    NfcManager.instance.stopSession();
  }

  onSuccessRead(BuildContext context, OPH oph) {
    print('cek oph card id : ${oph.ophCardId}');
    onCheckOPHExist(context, oph);
  }

  onCheckOPHExist(BuildContext context, OPH oph) async {
    SPBDetail? ophExist =
        await DatabaseSPBDetail().selectSPBDetailByOPHID(oph.ophId!);
    SPBDetail spbDetail = SPBDetail();

    final dataOphHistory = await StorageManager.readData('ophHistory');
    print('cek ophHistory : ${jsonDecode(dataOphHistory)}');
    bool isOPhHistoryExist = false;

    if (dataOphHistory != null) {
      final ophHistoryDecode = jsonDecode(dataOphHistory);
      final ophHistory = ophHistoryDecode as List;
      isOPhHistoryExist = ophHistory.contains(oph.ophId);
    }
    print('cek isOPHHistoryExist : $isOPhHistoryExist');

    // print('test spb');
    //  print(json.encode(spbDetail));

    print('test oph');
    print(json.encode(oph));

    // _mDivisionCode = oph.ophDivisionCode;
    // _estateCode = oph.ophEstateCode;
    // _mEstateSchema = await DatabaseMEstateSchema()
    //     .selectMEstateSchemaByEstateCode(oph.ophEstateCode!);
    spbDetail.spbId = _spbID;
    spbDetail.ophCardId = oph.ophCardId;
    spbDetail.ophId = oph.ophId;
    spbDetail.ophEstateCode = oph.ophEstateCode;
    spbDetail.ophDivisionCode = oph.ophDivisionCode;
    spbDetail.ophBlockCode = oph.ophBlockCode;
    spbDetail.ophTphCode = oph.ophTphCode;
    spbDetail.ophLooseFruitDelivered = oph.looseFruits;
    spbDetail.ophBunchesDelivered =
        calculateJanjangSent(oph.bunchesTotal!, oph.bunchesNotSent!);

    if (isOPhHistoryExist) {
      _dialogService.popDialog();
      FlushBarManager.showFlushBarWarning(
          context, "Scan OPH", "OPH sudah dimuat di SPB Lain");
    } else if (ophExist != null) {
      FlushBarManager.showFlushBarWarning(
          context, "Scan OPH", "OPH ini sudah pernah discan");
    } else {
      if (listSPBDetail.contains(spbDetail)) {
        _dialogService.popDialog();
        FlushBarManager.showFlushBarWarning(
            context, "Scan OPH", "OPH ini sudah masuk SPB");
      } else {
        //  print("spb");
        // print(json.encode(spbDetail));
        _listSPBDetail.add(spbDetail);
        _listOPHScanned.add(oph);
        print(json.encode(_listSPBDetail)); // check : ok
        //  print("oph");
        print(json.encode(_listOPHScanned)); //check : ok
        _lastOPH = _listSPBDetail.last.ophCardId!;
        _countOPH = _listSPBDetail.length;

        _estateCode = getMostEstateCodeValue(_listOPHScanned);
        _mDivisionCode =
            getMostDivisionCodeValue(_listOPHScanned, _estateCode!);
        _mEstateSchema = await DatabaseMEstateSchema()
            .selectMEstateSchemaByEstateCode(_estateCode!);

        /*  original */
        _totalBunches = _totalBunches + spbDetail.ophBunchesDelivered!;
        _totalLooseFruits =
            _totalLooseFruits + spbDetail.ophLooseFruitDelivered!;
        _totalWeightEstimation =
            _totalWeightEstimation + oph.ophEstimateTonnage!;

        /*_totalBunches = _totalBunches + oph.bunchesTotal!;
        _totalLooseFruits = _totalLooseFruits + oph.looseFruits!;
        _totalWeightEstimation = _totalWeightEstimation + oph.ophEstimateTonnage!;*/

        _dialogService.popDialog();
        _dialogService.showDialogScanOPH(
            title: "Tempel Kartu OPH",
            subtitle: "untuk membaca data",
            ophCount: _countOPH,
            lastOPH: _lastOPH,
            buttonText: "Selesai",
            onPress: onCancelScanOPH);
      }
    }
    if (_mvraSchema != null) {
      _totalCapacityTruck = _mvraSchema!.vraMaxCap - _totalWeightEstimation;
    }
    notifyListeners();
  }

  onErrorRead(BuildContext context, String response) {
    _dialogService.popDialog();
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
    FlushBarManager.showFlushBarWarning(context, "Gagal Membaca", response);
  }

  int calculateJanjangSent(int total, int tidakDikirim) {
    return total - tidakDikirim;
  }

  onDeleteOPH(int index) async {
    _totalBunches = _totalBunches - listSPBDetail[index].ophBunchesDelivered!;
    _totalLooseFruits =
        _totalLooseFruits - listSPBDetail[index].ophLooseFruitDelivered!;
    if (_mvraSchema != null) {
      _totalWeightEstimation =
          _totalWeightEstimation - _listOPHScanned[index].ophEstimateTonnage!;
      if (_totalWeightEstimation == 0.0) {
        _totalCapacityTruck = _mvraSchema!.vraMaxCap;
      } else {
        _totalCapacityTruck =
            (_totalCapacityTruck + _listOPHScanned[index].ophEstimateTonnage!);
      }
    }

    _listSPBDetail.removeAt(index);
    _listOPHScanned.removeAt(index);
    _lastOPH = _listSPBDetail.isNotEmpty ? _listSPBDetail.last.ophCardId! : "";
    _countOPH = _listSPBDetail.length;
    // azis
    _estateCode = _listSPBDetail.isNotEmpty
        ? getMostEstateCodeValue(_listOPHScanned)
        : '';
    _mDivisionCode = _listSPBDetail.isNotEmpty
        ? getMostDivisionCodeValue(_listOPHScanned, _estateCode!)
        : '';
    _mEstateSchema = _listSPBDetail.isNotEmpty
        ? await DatabaseMEstateSchema().selectMEstateSchemaByEstateCode(
            getMostEstateCodeValue(_listOPHScanned))
        : MEstateSchema();
    notifyListeners();
  }

  /*on Add Loader*/

  onAddLoader(BuildContext context) {
    if (_spbLoaderList.isNotEmpty) {
      SPBLoader newLoader = SPBLoader(
          spbId: _spbID,
          spbLoaderId: ValueService().generateIDLoader(DateTime.now()),
          loaderType: 1,
          loaderDestinationType: 1,
          loaderEmployeeCode: _listLoader.first.employeeCode,
          loaderPercentage: 0,
          loaderEmployeeName: _listLoader.first.employeeName);
      if (_spbLoaderList.any(
          (item) => item.loaderEmployeeName == newLoader.loaderEmployeeName)) {
        FlushBarManager.showFlushBarWarning(context,
            "Loader sudah ada dimasukkan", "Silahkan ganti loader untuk spb");
        _isLoaderExist = true;
      } else {
        _isLoaderExist = false;
      }
      _spbLoaderList.add(newLoader);
      _loaderType.add("Internal");
      _loaderName.add(_listLoader.first);
      _vendorName.add(_vendorList.first);
      _jenisAngkutValue.add("TPH-PKS");
      _percentageAngkut.add(TextEditingController(text: "0"));
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 320,
          duration: Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
        );
      }
      notifyListeners();
    } else {
      _spbLoaderList.add(SPBLoader(
          spbId: _spbID,
          spbLoaderId: ValueService().generateIDLoader(DateTime.now()),
          loaderType: 1,
          loaderDestinationType: 1,
          loaderEmployeeCode: _listLoader.first.employeeCode,
          loaderPercentage: 0,
          loaderEmployeeName: _listLoader.first.employeeName));
      _loaderType.add("Internal");
      _loaderName.add(_listLoader.first);
      _vendorName.add(_vendorList.first);
      _jenisAngkutValue.add("TPH-PKS");
      _percentageAngkut.add(TextEditingController(text: "0"));
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 320,
          duration: Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
        );
      }
      notifyListeners();
    }
    checkLoaderExist();
    checkLoaderPercentageValue();
  }

  onDeleteLoader(int index) {
    _totalPercentageAngkut = 0;
    if (_spbLoaderList.contains(_spbLoaderList[index])) {
      _isLoaderExist = false;
    }
    _spbLoaderList.removeAt(index);
    _loaderType.removeAt(index);
    _loaderName.removeAt(index);
    _jenisAngkutValue.removeAt(index);
    _percentageAngkut.removeAt(index);
    _spbLoaderList.forEach((element) {
      _totalPercentageAngkut =
          _totalPercentageAngkut + (element.loaderPercentage!);
    });
    checkLoaderExist();
    checkLoaderPercentageValue();
    notifyListeners();
  }

  onChangeLoaderType(int index, String loader) {
    loaderType[index] = loader;
    _spbLoaderList[index].loaderType = ValueService.typeOfFormToInt(loader);
    if (_spbLoaderList[index].loaderType == 3) {
      _spbLoaderList[index].loaderEmployeeName =
          ValueService.rightTrimVendor(_vendorList.first.vendorName!);
      _spbLoaderList[index].loaderEmployeeCode = _vendorList.first.vendorCode;
    }
    checkLoaderExist();
    checkLoaderPercentageValue();
    notifyListeners();
  }

  onChangeLoaderName(int index, MEmployeeSchema loaderName) {
    SPBLoader spbLoader =
        SPBLoader(loaderEmployeeCode: loaderName.employeeCode);
    if (_spbLoaderList.any(
        (item) => item.loaderEmployeeCode == spbLoader.loaderEmployeeCode)) {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Loader sudah ada dimasukkan",
          "Silahkan ganti loader untuk spb");
      _isLoaderExist = true;
    } else {
      _isLoaderExist = false;
    }
    _loaderName[index] = loaderName;
    _spbLoaderList[index].loaderEmployeeName = loaderName.employeeName;
    _spbLoaderList[index].loaderEmployeeCode = loaderName.employeeCode;
    checkLoaderExist();
    checkLoaderPercentageValue();
    notifyListeners();
  }

  onChangeVendorName(int index, MVendorSchema mVendorSchema) {
    SPBLoader spbLoader =
        SPBLoader(loaderEmployeeCode: mVendorSchema.vendorCode);
    if (_spbLoaderList.any(
        (item) => item.loaderEmployeeCode == spbLoader.loaderEmployeeCode)) {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Loader sudah ada dimasukkan",
          "Silahkan ganti loader untuk spb");
      _isLoaderExist = true;
    } else {
      _isLoaderExist = false;
    }
    _vendorName[index] = mVendorSchema;
    _spbLoaderList[index].loaderEmployeeName =
        ValueService.rightTrimVendor(mVendorSchema.vendorName!);
    _spbLoaderList[index].loaderEmployeeCode = mVendorSchema.vendorCode;
    checkLoaderExist();
    checkLoaderPercentageValue();
    notifyListeners();
  }

  onChangeJenisAngkut(int index, String loaderName) {
    _jenisAngkutValue[index] = loaderName;
    _spbLoaderList[index].loaderDestinationType =
        loaderName == "TPH-PKS" ? 1 : 2;
    checkLoaderExist();
    checkLoaderPercentageValue();
    notifyListeners();
  }

  onChangePercentageAngkut(BuildContext context, int index, String percent) {
    if (percent.isNotEmpty) {
      spbLoaderList[index].loaderPercentage = int.tryParse(percent);
      _totalPercentageAngkut = 0;
      _spbLoaderList.forEach((element) {
        _totalPercentageAngkut =
            _totalPercentageAngkut + element.loaderPercentage!;
      });
      notifyListeners();
      if (_totalPercentageAngkut > 100) {
        FlushBarManager.showFlushBarWarning(
            context, "Jumlah Percent", "Tidak boleh lebih dari 100");
      }
    }
    checkLoaderPercentageValue();
  }

  generateSPB() {
    SPB spbTemp = SPB();
    spbTemp.spbId = spbID;
    spbTemp.createdTime = _time;
    spbTemp.createdDate = _date;
    spbTemp.spbLat = _position != null ? _position!.latitude.toString() : null;
    spbTemp.spbLong =
        _position != null ? _position!.longitude.toString() : null;
    spbTemp.spbType = typeDeliverValue == "Internal" ? 1 : 3;
    spbTemp.spbDeliverToCode = _destinationValue?.destinationCode;
    spbTemp.spbDeliverToName = _destinationValue?.destinationName;
    if (_typeDeliverValue == "Internal") {
      spbTemp.spbVendorOthers = 0;
      spbTemp.spbDriverEmployeeCode = _driverNameValue?.employeeCode;
      spbTemp.spbDriverEmployeeName = _driverNameValue?.employeeName;
    } else {
      if (_isOthersVendor) {
        spbTemp.spbVendorOthers = 1;
        spbTemp.spbDriverEmployeeCode = _vendorOther.text;
        spbTemp.spbDriverEmployeeName = "";
      } else {
        spbTemp.spbVendorOthers = 0;
        spbTemp.spbDriverEmployeeCode = _vendorSchemaValue?.vendorCode;
        spbTemp.spbDriverEmployeeName =
            ValueService.rightTrimVendor(_vendorSchemaValue!.vendorName!);
      }
    }
    spbTemp.spbEstateVendorCode = _mEstateSchema?.estateVendorCode;
    spbTemp.spbLicenseNumber =
        _mvraSchema?.vraLicenseNumber ?? vehicleNumber.text;
    spbTemp.spbCardId = _mcspbCardSchema?.spbCardId;
    spbTemp.spbTotalOph = _countOPH;
    spbTemp.spbEstateCode = _estateCode;
    spbTemp.spbDivisionCode = _mDivisionCode;
    spbTemp.spbType = ValueService.typeOfFormToInt(_typeDeliverValue);
    spbTemp.spbDeliverToCode = _destinationValue?.destinationCode;
    spbTemp.spbDeliverToName = _destinationValue?.destinationName;
    spbTemp.spbDeliveryNote = _notesSPB.text;
    spbTemp.spbLat = _position?.latitude.toString();
    spbTemp.spbLong = _position?.longitude.toString();
    spbTemp.spbPhoto = _pickedFile;
    spbTemp.spbKeraniTransportEmployeeCode = _mConfigSchema?.employeeCode;
    spbTemp.spbKeraniTransportEmployeeName = _mConfigSchema?.employeeName;
    spbTemp.spbTotalBunches = _totalBunches;
    spbTemp.spbTotalOph = _listSPBDetail.length;
    spbTemp.spbTotalLooseFruit = _totalLooseFruits;
    spbTemp.spbCapacityTonnage = _totalCapacityTruck;
    spbTemp.spbEstimateTonnage = _totalWeightEstimation;
    spbTemp.spbActualTonnage = _totalWeightActual;
    spbTemp.spbActualWeightDate = _date;
    spbTemp.spbActualWeightTime = _time;
    spbTemp.createdBy = _mConfigSchema?.employeeCode;
    spbTemp.updatedBy = "";
    spbTemp.updatedDate = "";
    spbTemp.updatedTime = "";
    spbTemp.spbIsClosed = 0;
    _globalSPB = spbTemp;
    notifyListeners();
  }

  showDialogQuestion(BuildContext context) {
    generateSPB();
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
        _globalSPB,
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
    saveSPBtoDatabase(_navigationService.navigatorKey.currentContext!);
  }

  onClickSaveSPB(BuildContext context) {
    checkVehicle(context, vehicleNumber.text);
    checkLoaderExist();
    checkLoaderPercentageValue();
    switch (_typeDeliverValue) {
      case "Internal":
        if (_destinationValue != null) {
          if (_driverNameValue != null) {
            if (vehicleNumber.text.isNotEmpty) {
              if (_mvraSchema != null) {
                if (spbCardNumber.text.isNotEmpty) {
                  if (_mcspbCardSchema != null) {
                    if (_countOPH != 0) {
                      if (_spbLoaderList.isNotEmpty) {
                        if (!_isLoaderExist) {
                          if (!_isLoaderZero) {
                            if (_totalPercentageAngkut == 100) {
                              if (_totalPercentageAngkut >= 100) {
                                showDialogQuestion(context);
                              } else {
                                FlushBarManager.showFlushBarWarning(context,
                                    "Daftar Loader", "Lebih dari dari 100 %");
                              }
                            } else {
                              FlushBarManager.showFlushBarWarning(context,
                                  "Daftar Loader", "Harus memuat 100 %");
                            }
                          } else {
                            FlushBarManager.showFlushBarWarning(
                                context,
                                "Daftar Loader",
                                "Anda belum menginput percentase loader");
                          }
                        } else {
                          FlushBarManager.showFlushBarWarning(
                              context,
                              "Daftar Loader",
                              "Anda menginput loader yang sama");
                        }
                      } else {
                        FlushBarManager.showFlushBarWarning(
                            context, "Daftar Loader", "Belum menginput Loader");
                      }
                    } else {
                      FlushBarManager.showFlushBarWarning(
                          context, "Daftar OPH", "Belum menginput OPH");
                    }
                  } else {
                    FlushBarManager.showFlushBarWarning(
                        context, "No Kartu SPB", "Tidak sesuai");
                  }
                } else {
                  FlushBarManager.showFlushBarWarning(context, "No Kartu SPB",
                      "Anda belum mengisi nomor Kartu SPB");
                }
              } else {
                FlushBarManager.showFlushBarWarning(
                    context, "No Kendaraan", "Tidak  sesuai");
              }
            } else {
              FlushBarManager.showFlushBarWarning(context, "No Kendaraan",
                  "Anda belum mengisi nomor kendaraan");
            }
          } else {
            FlushBarManager.showFlushBarWarning(
                context, "Supir", "Anda belum memilih supir");
          }
        } else {
          FlushBarManager.showFlushBarWarning(
              context, "Tujuan", "Anda belum memilih tujuan");
        }
        break;
      case "Kontrak":
        if (_destinationValue != null) {
          if (_isOthersVendor) {
            if (_vendorOther.text.isNotEmpty) {
              if (vehicleNumber.text.isNotEmpty) {
                if (spbCardNumber.text.isNotEmpty) {
                  if (_mcspbCardSchema != null) {
                    if (_countOPH != 0) {
                      if (_spbLoaderList.isNotEmpty) {
                        if (!_isLoaderExist) {
                          if (!_isLoaderZero) {
                            if (_totalPercentageAngkut == 100) {
                              if (_totalPercentageAngkut >= 100) {
                                showDialogQuestion(context);
                              } else {
                                FlushBarManager.showFlushBarWarning(context,
                                    "Daftar Loader", "Lebih dari dari 100 %");
                              }
                            } else {
                              FlushBarManager.showFlushBarWarning(context,
                                  "Daftar Loader", "Harus memuat 100 %");
                            }
                          } else {
                            FlushBarManager.showFlushBarWarning(
                                context,
                                "Daftar Loader",
                                "Anda belum menginput percentase loader");
                          }
                        } else {
                          FlushBarManager.showFlushBarWarning(
                              context,
                              "Daftar Loader",
                              "Anda menginput loader yang sama");
                        }
                      } else {
                        FlushBarManager.showFlushBarWarning(
                            context, "Daftar Loader", "Belum menginput Loader");
                      }
                    } else {
                      FlushBarManager.showFlushBarWarning(
                          context, "Daftar OPH", "Belum menginput OPH");
                    }
                  } else {
                    FlushBarManager.showFlushBarWarning(
                        context, "No Kartu SPB", "Tidak sesuai");
                  }
                } else {
                  FlushBarManager.showFlushBarWarning(context, "No Kartu SPB",
                      "Anda belum mengisi nomor Kartu SPB");
                }
              } else {
                FlushBarManager.showFlushBarWarning(context, "No Kendaraan",
                    "Anda belum mengisi nomor kendaraan");
              }
            } else {
              FlushBarManager.showFlushBarWarning(
                  context, "Vendor lain", "Anda belum mengisi vendor lain");
            }
          } else {
            if (vendorSchemaValue != null) {
              if (vehicleNumber.text.isNotEmpty) {
                if (spbCardNumber.text.isNotEmpty) {
                  if (_mcspbCardSchema != null) {
                    if (_countOPH != 0) {
                      if (_spbLoaderList.isNotEmpty) {
                        if (!_isLoaderExist) {
                          if (!_isLoaderZero) {
                            if (_totalPercentageAngkut == 100) {
                              if (_totalPercentageAngkut >= 100) {
                                showDialogQuestion(context);
                              } else {
                                FlushBarManager.showFlushBarWarning(context,
                                    "Daftar Loader", "Lebih dari dari 100 %");
                              }
                            } else {
                              FlushBarManager.showFlushBarWarning(context,
                                  "Daftar Loader", "Harus memuat 100 %");
                            }
                          } else {
                            FlushBarManager.showFlushBarWarning(
                                context,
                                "Daftar Loader",
                                "Anda belum menginput percentase loader");
                          }
                        } else {
                          FlushBarManager.showFlushBarWarning(
                              context,
                              "Daftar Loader",
                              "Anda menginput loader yang sama");
                        }
                      } else {
                        FlushBarManager.showFlushBarWarning(
                            context, "Daftar Loader", "Belum menginput Loader");
                      }
                    } else {
                      FlushBarManager.showFlushBarWarning(
                          context, "Daftar OPH", "Belum menginput OPH");
                    }
                  } else {
                    FlushBarManager.showFlushBarWarning(
                        context, "No Kartu SPB", "Tidak sesuai");
                  }
                } else {
                  FlushBarManager.showFlushBarWarning(context, "No Kartu SPB",
                      "Anda belum mengisi nomor Kartu SPB");
                }
              } else {
                FlushBarManager.showFlushBarWarning(context, "No Kendaraan",
                    "Anda belum mengisi nomor kendaraan");
              }
            } else {
              FlushBarManager.showFlushBarWarning(
                  context, "Vendor", "Anda belum memilih vendor");
            }
          }
        } else {
          FlushBarManager.showFlushBarWarning(
              context, "Tujuan", "Anda belum memilih tujuan");
        }
        break;
    }
  }

  void saveSPBtoDatabase(BuildContext context) async {
    print("insert spb detail "); //check : value is wrong
    print(json.encode(_listSPBDetail));
    int countSaved = await DatabaseSPB().insertSPB(_globalSPB);
    if (countSaved > 0) {
      for (int i = 0; i < _listSPBDetail.length; i++) {
        await DatabaseSPBDetail().insertSPBDetail(_listSPBDetail[i]);
      }
      for (int i = 0; i < _spbLoaderList.length; i++) {
        await DatabaseSPBLoader().insertSPBLoader(_spbLoaderList[i]);
      }
      _dialogService.popDialog();
      _navigationService.pop();
      Future.delayed(const Duration(seconds: 2), () {
        NfcManager.instance.stopSession();
      });
      FlushBarManager.showFlushBarSuccess(
          context, "Simpan SPB", "Berhasil menyimpan SPB");
    } else {
      FlushBarManager.showFlushBarWarning(
          context, "Simpan SPB", "Gagal menyimpan SPB");
    }
  }

  // azis
  String getMostEstateCodeValue(List<OPH> list) {
    int maxCount = 0;
    String maxFreq = '';

    for (int i = 0; i < list.length; i++) {
      int count = 0;
      for (int j = 0; j < list.length; j++) {
        if (list[i].ophEstateCode == list[j].ophEstateCode) {
          count++;
        }
      }

      if (count > maxCount) {
        maxCount = count;
        maxFreq = list[i].ophEstateCode!;
      }
    }
    return maxFreq;
  }

  String getMostDivisionCodeValue(List<OPH> list, String estateCode) {
    int maxCount = 0;
    String maxFreq = '';
    List<OPH> listOPHMostEstate = [];

    for (int i = 0; i < list.length; i++) {
      if (list[i].ophEstateCode! == estateCode) {
        listOPHMostEstate.add(list[i]);
      }
    }

    for (int i = 0; i < listOPHMostEstate.length; i++) {
      int count = 0;
      for (int j = 0; j < listOPHMostEstate.length; j++) {
        if (listOPHMostEstate[i].ophDivisionCode ==
            listOPHMostEstate[j].ophDivisionCode) {
          count++;
        }
      }

      if (count > maxCount) {
        maxCount = count;
        maxFreq = listOPHMostEstate[i].ophDivisionCode!;
      }
    }
    return maxFreq;
  }

  String getMDivisionCode(List<OPH> list, String estateCode) {
    String mDivisionCode = '';
    for (int i = 0; i < list.length; i++) {
      if (list[i].ophEstateCode! == estateCode) {
        mDivisionCode = list[i].ophDivisionCode!;
        break;
      }
    }
    return mDivisionCode;
  }
}

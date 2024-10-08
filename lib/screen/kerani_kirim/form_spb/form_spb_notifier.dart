import 'dart:async';
import 'dart:math';

import 'package:epms/base/common/locator.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/location_service.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/oph_card_manager.dart';
import 'package:epms/common_manager/spb_card_manager.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nfc_manager/nfc_manager.dart';

class FormSPBNotifier extends ChangeNotifier {
  ScrollController _scrollController = new ScrollController();

  ScrollController get scrollController => _scrollController;

  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  ImagePicker _picker = ImagePicker();

  ImagePicker get picker => _picker;

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

  bool _isLoaderExist = false;

  bool get isLoaderExist => _isLoaderExist;

  bool _isLoaderZero = false;

  bool get isLoaderZero => _isLoaderZero;

  /*On init Form SPB*/

  onInitFormSPB() async {
    generateVariable();
    _driverNameList = await DatabaseMEmployeeSchema().selectMEmployeeSchema();
    _destinationList =
        await DatabaseMDestinationSchema().selectMDestinationSchema();
    _vendorList = await DatabaseMVendorSchema().selectMVendorSchema();
    addOPH();
    notifyListeners();
  }

  generateVariable() async {
    _mConfigSchema = await DatabaseMConfig().selectMConfig();
    _mEstateSchema = await DatabaseMEstateSchema()
        .selectMEstateSchemaByEstateCode(_mConfigSchema!.estateCode!);
    DateTime now = DateTime.now();
    NumberFormat formatterNumber = new NumberFormat("000");
    String number = formatterNumber.format(_mConfigSchema?.userId!);
    _date = TimeManager.dateWithDash(now);
    _time = TimeManager.timeWithColon(now);
    _spbID = "${_mConfigSchema?.estateCode}" +
        ValueService.generateIDFromDateTime(now) +
        "$number" "M";
    getLocation();
    notifyListeners();
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
    _driverNameValue = mEmployeeSchema;
    notifyListeners();
  }

  onCheckOtherVendor(bool value) {
    _isOthersVendor = value;
    notifyListeners();
  }

  Future getCamera(BuildContext context) async {
    String? picked = await CameraService.getImageByCamera();
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
        List list = await DatabaseMVRASchema().selectMVRASchema();
        print(list);
        _mvraSchema ??
            FlushBarManager.showFlushBarWarning(
                context, "Nomor Kendaraan", "Tidak sesuai");
        _totalCapacityTruck = _mvraSchema!.vraMaxCap!.toDouble();
        if (_mvraSchema != null) {
          _totalCapacityTruck =
              (_totalCapacityTruck - _totalWeightEstimation.toInt());
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

  addOPH() {
    for(int i=0; i<500; i++) {
      SPBDetail spbDetail = SPBDetail();
      spbDetail.spbId = _spbID;
      spbDetail.ophId = ValueService().generateIDLoader(DateTime.now());
      spbDetail.ophBlockCode =  "C24";
      spbDetail.ophLooseFruitDelivered = 9;
      spbDetail.ophTphCode = "10";
      spbDetail.ophCardId = "A" + generate4Digits();
      spbDetail.ophBunchesDelivered = 80;
      _listSPBDetail.add(spbDetail);
      _lastOPH = _listSPBDetail.last.ophCardId!;
      _countOPH = _listSPBDetail.length;
      _totalBunches = _totalBunches + spbDetail.ophBunchesDelivered!;
      _totalLooseFruits =
          _totalLooseFruits + spbDetail.ophLooseFruitDelivered!;
      _totalWeightEstimation =
          _totalWeightEstimation + 1.2;
      _totalWeightEstimation =
          double.parse(_totalWeightEstimation.toStringAsFixed(3));
    }
  }

  String generate4Digits() {
    var rng = Random();
    String generatedNumber = '';
    for(int i=0;i<4;i++){
      generatedNumber += (rng.nextInt(9)+1).toString();

    }
    return generatedNumber;
  }

  onCancelScanOPH() {
    _dialogService.popDialog();
    NfcManager.instance.stopSession();
  }

  onSuccessRead(BuildContext context, OPH oph) {
    onCheckOPHExist(context, oph);
  }

  onCheckOPHExist(BuildContext context, OPH oph) async {
    SPBDetail? ophExist =
        await DatabaseSPBDetail().selectSPBDetailByOPHID(oph.ophId!);
    SPBDetail spbDetail = SPBDetail();
    _mDivisionCode = oph.ophDivisionCode;
    spbDetail.spbId = _spbID;
    spbDetail.ophCardId = oph.ophCardId;
    spbDetail.ophId = oph.ophId;
    spbDetail.ophBlockCode = oph.ophBlockCode;
    spbDetail.ophTphCode = oph.ophTphCode;
    spbDetail.ophLooseFruitDelivered = oph.looseFruits;
    spbDetail.ophBunchesDelivered =
        calculateJanjangSent(oph.bunchesTotal!, oph.bunchesNotSent!);
    if (ophExist != null) {
      FlushBarManager.showFlushBarWarning(
          context, "Scan OPH", "OPH ini sudah pernah discan");
    } else {
      if (listSPBDetail.contains(spbDetail)) {
        _dialogService.popDialog();
        Future.delayed(const Duration(seconds: 2), () {
          NfcManager.instance.stopSession();
        });
        FlushBarManager.showFlushBarWarning(
            context, "Scan OPH", "OPH ini sudah masuk SPB");
      } else {
        _listSPBDetail.add(spbDetail);
        _lastOPH = _listSPBDetail.last.ophCardId!;
        _countOPH = _listSPBDetail.length;
        _totalBunches = _totalBunches + spbDetail.ophBunchesDelivered!;
        _totalLooseFruits =
            _totalLooseFruits + spbDetail.ophLooseFruitDelivered!;
        _totalWeightEstimation =
            _totalWeightEstimation + oph.ophEstimateTonnage!;
        _totalWeightEstimation =
            double.parse(_totalWeightEstimation.toStringAsFixed(3));
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
      _totalCapacityTruck = (_mvraSchema!.vraMaxCap! - _totalWeightEstimation);
    }
    notifyListeners();
  }

  onErrorRead(BuildContext context, String response) {
    _dialogService.popDialog();
    Future.delayed(const Duration(seconds: 2), () {
      NfcManager.instance.stopSession();
    });
    FlushBarManager.showFlushBarWarning(context, "Gagal Membaca", response);
  }

  int calculateJanjangSent(int total, int tidakDikirim) {
    return total - tidakDikirim;
  }

  onDeleteOPH(int index) {
    _totalBunches = _totalBunches - listSPBDetail[index].ophBunchesDelivered!;
    _totalLooseFruits =
        _totalLooseFruits - listSPBDetail[index].ophLooseFruitDelivered!;
    _listSPBDetail.removeAt(index);
    _lastOPH = _listSPBDetail.isNotEmpty ? _listSPBDetail.last.ophCardId! : "";
    _countOPH = _listSPBDetail.length;
    if (_mvraSchema != null) {
      _totalCapacityTruck =
          (_totalCapacityTruck + _totalWeightEstimation.toInt());
    }
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
          loaderEmployeeCode: _driverNameList.first.employeeCode,
          loaderPercentage: 0,
          loaderEmployeeName: _driverNameList.first.employeeName);
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
      _loaderName.add(_driverNameList.first);
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
          loaderEmployeeCode: _driverNameList.first.employeeCode,
          loaderPercentage: 0,
          loaderEmployeeName: _driverNameList.first.employeeName));
      _loaderType.add("Internal");
      _loaderName.add(_driverNameList.first);
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
      _spbLoaderList[index].loaderEmployeeName = _vendorList.first.vendorName;
      _spbLoaderList[index].loaderEmployeeCode = _vendorList.first.vendorCode;
    }
    checkLoaderExist();
    checkLoaderPercentageValue();
    notifyListeners();
  }

  onChangeLoaderName(int index, MEmployeeSchema loaderName) {
    SPBLoader spbLoader =
        SPBLoader(loaderEmployeeName: loaderName.employeeName);
    if (_spbLoaderList.any(
        (item) => item.loaderEmployeeName == spbLoader.loaderEmployeeName)) {
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
        SPBLoader(loaderEmployeeName: mVendorSchema.vendorName);
    if (_spbLoaderList.any(
        (item) => item.loaderEmployeeName == spbLoader.loaderEmployeeName)) {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Loader sudah ada dimasukkan",
          "Silahkan ganti loader untuk spb");
      _isLoaderExist = true;
    } else {
      _isLoaderExist = false;
    }
    _vendorName[index] = mVendorSchema;
    _spbLoaderList[index].loaderEmployeeName = mVendorSchema.vendorName;
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
        spbTemp.spbDriverEmployeeName = _vendorOther.text;
      } else {
        spbTemp.spbVendorOthers = 0;
        spbTemp.spbDriverEmployeeCode = _vendorSchemaValue?.vendorCode;
        spbTemp.spbDriverEmployeeName = _vendorSchemaValue?.vendorName;
      }
    }
    spbTemp.spbEstateVendorCode = _mEstateSchema?.estateVendorCode;
    spbTemp.spbLicenseNumber =
        _mvraSchema?.vraLicenseNumber ?? vehicleNumber.text;
    spbTemp.spbCardId = _mcspbCardSchema?.spbCardId;
    spbTemp.spbTotalOph = _countOPH;
    spbTemp.spbEstateCode = _mConfigSchema?.estateCode;
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
    _dialogService.showOptionDialog(
        title: "Memakai Kartu",
        subtitle: "Apakah anda ingin memakai kartu",
        buttonTextYes: "Ya",
        buttonTextNo: "Tidak",
        onPressYes: onClickYesCard,
        onPressNo: onClickNoCard);
  }

  onClickYesCard() {
    _dialogService.popDialog();
    SPBCardManager().writeSPBCard(
        _navigationService.navigatorKey.currentContext!,
        _globalSPB,
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
}

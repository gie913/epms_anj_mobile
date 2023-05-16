import 'dart:async';

import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/encryption_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_m_division.dart';
import 'package:epms/database/service/database_m_employee.dart';
import 'package:epms/database/service/database_m_vendor.dart';
import 'package:epms/database/service/database_spb_supervise.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/m_division_schema.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/m_vendor_schema.dart';
import 'package:epms/model/spb_supervise.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nfc_manager/nfc_manager.dart';

class SupervisorSPBFormNotifier extends ChangeNotifier {
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

  ImagePicker _picker = ImagePicker();

  ImagePicker get picker => _picker;

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

  onInit() async {
    _listDivision = await DatabaseMDivisionSchema().selectMDivisionSchema();
    _listDriver = await DatabaseMEmployeeSchema().selectMEmployeeSchema();
    _listVendor = await DatabaseMVendorSchema().selectMVendorSchema();
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

  onChangeVendor(MVendorSchema mVendorSchema) {
    _vendor = mVendorSchema;
    notifyListeners();
  }

  void _tagRead(BuildContext context) {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      splitSPB(context, tag);
      Future.delayed(Duration(milliseconds: 1300), () {
        NfcManager.instance.stopSession();
      });
      Navigator.pop(context);
    });
  }

  splitSPB(BuildContext context, NfcTag oph) async {
    ValueService.tagReader(oph).then((value) {
      String decryptData = EncryptionManager.decryptData(value);
      if (decryptData.characters.first == "S") {
        final split = decryptData.split(',');
        final Map<int, String> values = {
          for (int i = 0; i < split.length; i++) i: split[i]
        };
        _spbID.text = values[1].toString();
        vehicleNumber.text = values[7].toString();
        _estate.text = values[8].toString();
        notifyListeners();
      } else {
        // FlushBarManager(
        //         title: "Baca Kartu",
        //         message: "Bukan Kartu SPB",
        //         context: context)
        //     .showFlushBarWarning();
      }
    });
  }

  dialogNFC(BuildContext context) {
    _tagRead(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Center(
                child: Text("Tempel Kartu NFC",
                    style: TextStyle(color: Colors.black))),
            content: Container(
              height: 240,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      width: 140,
                      child: Image.asset("assets/tempel-kartu.gif"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Untuk Membaca Data",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Card(
                    color: Palette.redColorLight,
                    child: InkWell(
                      onTap: () {
                        NfcManager.instance.stopSession();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        child: Center(
                            child: Text("BATAL",
                                style: Style.whiteBold16)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  generateVariable() async {
    _mConfigSchema = await DatabaseMConfig().selectMConfig();
    DateTime now = DateTime.now();
    NumberFormat formatterNumber = new NumberFormat("000");
    String number = formatterNumber.format(mConfigSchema?.userId);
    _date = TimeManager.dateWithDash(now);
    _time = TimeManager.timeWithColon(now);
    _supervisiID = "${mConfigSchema?.estateCode}" +
        ValueService.generateIDFromDateTime(now) +
        "$number" "SM";
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
    notifyListeners();
  }

  Future getCamera(BuildContext context) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 20,
      );
      if (pickedFile != null) {
        this._pickedFile = pickedFile.path;
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  onSetDriver(MEmployeeSchema mEmployeeSchema) {
    _driver = mEmployeeSchema;
    notifyListeners();
  }

  onChangeDivision(MDivisionSchema mDivisionSchema) {
    _division = mDivisionSchema;
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
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            title: Center(
                child: Text(
              "Apakah anda yakin ingin menyimpan?",
              textAlign: TextAlign.center,
            )),
            actions: <Widget>[
              Row(
                children: [
                  Flexible(
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          saveToDatabase(context);
                        },
                        child: Card(
                          color: Palette.primaryColorProd,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(14),
                            child: Text("Ya",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Card(
                          color: Palette.redColorLight,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(14),
                            child: Text("Tidak",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  saveToDatabase(BuildContext context) async {
    SPBSupervise spbSupervise = SPBSupervise();
    spbSupervise.spbId = _supervisiID;
    spbSupervise.supervisiSpbEmployeeCode = _mConfigSchema?.employeeCode;
    spbSupervise.supervisiSpbEmployeeName = _mConfigSchema?.employeeName;
    spbSupervise.supervisiSpbLat = _position?.latitude.toString();
    spbSupervise.supervisiSpbLong = _position?.longitude.toString();
    spbSupervise.supervisiSpbDriverEmployeeCode = _driver?.employeeCode;
    spbSupervise.supervisiSpbDriverEmployeeName = _driver?.employeeName;
    spbSupervise.supervisiSpbDivisionCode = _division?.divisionCode;
    spbSupervise.supervisiSpbLicenseNumber = vehicleNumber.text;
    spbSupervise.supervisiSpbType = _employeeTypeValue;
    spbSupervise.supervisiSpbMethod = _sourceSPBValue;
    spbSupervise.supervisiSpbPhoto = _pickedFile;
    spbSupervise.bunchesRipe = int.parse(_bunchesRipe.text);
    spbSupervise.bunchesOverripe = int.parse(_bunchesOverRipe.text);
    spbSupervise.bunchesHalfripe = int.parse(_bunchesHalfRipe.text);
    spbSupervise.bunchesUnripe = int.parse(_bunchesUnRipe.text);
    spbSupervise.bunchesAbnormal = int.parse(_bunchesAbnormal.text);
    spbSupervise.bunchesEmpty = int.parse(_bunchesEmpty.text);
    spbSupervise.looseFruits = int.parse(_looseFruits.text);
    spbSupervise.bunchesTotal = int.parse(_bunchesTotal.text);
    spbSupervise.bunchesTotalNormal = int.parse(_bunchesNormalTotal.text);
    spbSupervise.bunchesSampah = int.parse(_sampah.text);
    spbSupervise.bunchesBatu = int.parse(_batu.text);
    spbSupervise.catatanBunchesTangkaiPanjang = noteJanjangTangkaiPanjang.text;
    spbSupervise.supervisiNotes = _notesOPH.text;
    spbSupervise.createdBy = _mConfigSchema?.employeeName;
    spbSupervise.supervisiSpbDate = _date;
    spbSupervise.createdDate = _date;
    spbSupervise.createdTime = _time;
    int count = await DatabaseSPBSupervise().insertSPBSupervise(spbSupervise);
    if (count > 0) {
      Navigator.pop(context);
      Navigator.pop(context);
      // FlushBarManager(
      //     title: "Simpan SPB",
      //     message: "Berhasil menyimpan SPB",
      //     context: context)
      //     .showFlushBarSuccess();
    } else {
      // FlushBarManager(
      //     title: "Simpan SPB",
      //     message: "Gagal menyimpan SPB",
      //     context: context)
      //     .showFlushBarWarning();
    }
  }
}

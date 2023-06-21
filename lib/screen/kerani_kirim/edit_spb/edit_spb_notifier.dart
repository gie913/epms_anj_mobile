import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/spb_card_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_m_employee.dart';
import 'package:epms/database/service/database_m_vendor.dart';
import 'package:epms/database/service/database_m_vra.dart';
import 'package:epms/database/service/database_spb.dart';
import 'package:epms/database/service/database_spb_loader.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/m_vendor_schema.dart';
import 'package:epms/model/m_vras_schema.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_detail.dart';
import 'package:epms/model/spb_loader.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class EditSPBNotifier extends ChangeNotifier {
  ScrollController _scrollController = new ScrollController();

  ScrollController get scrollController => _scrollController;

  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  bool _otherVendor = false;

  bool get otherVendor => _otherVendor;

  MConfigSchema? _mConfigSchema;

  MConfigSchema? get mConfigSchema => _mConfigSchema;

  String _typeDeliverValue = "Internal";

  String get typeDeliverValue => _typeDeliverValue;

  List<String> typeDeliver = ["Internal", "Kontrak"];

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

  List<SPBLoader> _spbLoaderList = [];

  List<SPBLoader> get spbLoaderList => _spbLoaderList;

  List<String> _loaderType = [];

  List<String> get loaderType => _loaderType;

  List<MVendorSchema> _vendorName = [];

  List<MVendorSchema> get vendorName => _vendorName;

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

  SPB _globalSPB = SPB();

  SPB get globalSPB => _globalSPB;

  MVRASchema? _mvraSchema = MVRASchema();

  MVRASchema? get mvraSchema => _mvraSchema;

  bool _isOthersVendor = false;

  bool get isOthersVendor => _isOthersVendor;

  bool _isLoaderExist = false;

  bool get isLoaderExist => _isLoaderExist;

  bool _isLoaderZero = false;

  bool get isLoaderZero => _isLoaderZero;

  double _totalCapacityTruck = 0;

  double get totalCapacityTruck => _totalCapacityTruck;

  List<String> deletedLoader = [];

  onCheckOtherVendor(bool value) {
    _isOthersVendor = value;
    notifyListeners();
  }

  checkVehicle(BuildContext context, String vehicleNumber) async {
    if (vehicleNumber.isNotEmpty) {
      if (_globalSPB.spbType != 3) {
        _mvraSchema =
            await DatabaseMVRASchema().selectMVRASchemaByNumber(vehicleNumber);
        _mvraSchema ??
            FlushBarManager.showFlushBarWarning(
                context, "Nomor Kendaraan", "Tidak sesuai");
        if (_mvraSchema != null) {
          _totalCapacityTruck =
              (_mvraSchema!.vraMaxCap! - _globalSPB.spbCapacityTonnage!);
        }
      }
    }
    notifyListeners();
  }

  onDeleteLoader(int index) {
    checkLoaderExist();
    checkLoaderPercentageValue();
    deletedLoader.add(_spbLoaderList[index].spbLoaderId!);
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

  onInitEdit(BuildContext context, SPB spb, List<SPBDetail> listSPBDetail,
      List<SPBLoader> listSPBLoader) async {
    _globalSPB = spb;
    _typeDeliverValue = ValueService.typeOfFormToText(spb.spbType!)!;
    _driverNameList = await DatabaseMEmployeeSchema().selectMEmployeeSchema();
    _mConfigSchema = await DatabaseMConfig().selectMConfig();
    checkVehicle(context, spb.spbLicenseNumber!);
    if (spb.spbType == 1) {
      _driverNameValue = MEmployeeSchema(
          employeeCode: spb.spbDriverEmployeeCode,
          employeeName: spb.spbDriverEmployeeName);
    }
    vehicleNumber.text = spb.spbLicenseNumber!;
    if (_driverNameList.isNotEmpty) {
      _vendorList = await DatabaseMVendorSchema().selectMVendorSchema();
      if (_vendorList.isNotEmpty) {
        if (spb.spbType == 1) {
          _listSPBDetail = listSPBDetail;
          onInitLoader(listSPBLoader);
          notifyListeners();
        } else {
          if (spb.spbVendorOthers == "1") {
            _isOthersVendor = true;
            _otherVendor = true;
            _vendorOther.text = spb.spbDriverEmployeeName!;
            _listSPBDetail = listSPBDetail;
            onInitLoader(listSPBLoader);
            notifyListeners();
          } else {
            _vendorSchemaValue = MVendorSchema(
                vendorCode: spb.spbDriverEmployeeCode,
                vendorName: spb.spbDriverEmployeeName);
            _listSPBDetail = listSPBDetail;
            onInitLoader(listSPBLoader);
            notifyListeners();
          }
        }
      }
    }
  }

  onAddLoader(BuildContext context) {
    checkLoaderExist();
    checkLoaderPercentageValue();
    if (_spbLoaderList.isNotEmpty) {
      SPBLoader newLoader = SPBLoader(
          spbId: _globalSPB.spbId,
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
          spbId: _globalSPB.spbId,
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
  }

  onInitLoader(List<SPBLoader> spbLoader) {
    for (int i = 0; i < spbLoader.length; i++) {
      _spbLoaderList.add(SPBLoader(
          spbId: spbLoader[i].spbId,
          spbLoaderId: spbLoader[i].spbLoaderId,
          loaderType: spbLoader[i].loaderType,
          loaderDestinationType: spbLoader[i].loaderDestinationType,
          loaderEmployeeCode: spbLoader[i].loaderEmployeeCode,
          loaderPercentage: spbLoader[i].loaderPercentage,
          loaderEmployeeName: spbLoader[i].loaderEmployeeName));
      _totalPercentageAngkut =
          _totalPercentageAngkut + spbLoader[i].loaderPercentage!;
      _loaderType.add(spbLoader[i].loaderType == 1 ? "Internal" : "Kontrak");
      if (spbLoader[i].loaderType == 1) {
        _loaderName.add(MEmployeeSchema(
            employeeName: spbLoader[i].loaderEmployeeName,
            employeeCode: spbLoader[i].loaderEmployeeCode));
        _vendorName.add(_vendorList.first);
      } else {
        _vendorName.add(MVendorSchema(
            vendorName: spbLoader[i].loaderEmployeeName,
            vendorCode: spbLoader[i].loaderEmployeeCode));
        _loaderName.add(driverNameList.first);
      }
      _jenisAngkutValue
          .add(spbLoader[i].loaderDestinationType == 1 ? "TPH-PKS" : "TPB-PKS");
      _percentageAngkut.add(TextEditingController(
          text: spbLoader[i].loaderPercentage.toString()));
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 320,
          duration: Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
        );
      }
    }
  }

  onChangeDeliveryType(String value) {
    _typeDeliverValue = value;
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

  Future getCamera(BuildContext context) async {
    String? picked = await CameraService.getImageByCamera(context);
    if (picked != null) {
      _globalSPB.spbPhoto = picked;
      notifyListeners();
    }
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
    if (count > 0) {
      _isLoaderZero = true;
    } else {
      _isLoaderZero = false;
    }
  }

  generateSPB() {
    _globalSPB.spbType = typeDeliverValue == "Internal" ? 1 : 3;
    if (_typeDeliverValue == "Internal") {
      _globalSPB.spbVendorOthers = 0;
      _globalSPB.spbDriverEmployeeCode = _driverNameValue?.employeeCode;
      _globalSPB.spbDriverEmployeeName = _driverNameValue?.employeeName;
    } else {
      if (_isOthersVendor) {
        _globalSPB.spbVendorOthers = 1;
        _globalSPB.spbDriverEmployeeCode = _vendorOther.text;
        _globalSPB.spbDriverEmployeeName = _vendorOther.text;
      } else {
        _globalSPB.spbVendorOthers = 0;
        _globalSPB.spbDriverEmployeeCode = _vendorSchemaValue?.vendorCode;
        _globalSPB.spbDriverEmployeeName = _vendorSchemaValue?.vendorName;
      }
    }
    if (typeDeliverValue != "Kontrak") {
      _globalSPB.spbLicenseNumber = _mvraSchema?.vraLicenseNumber;
    } else {
      _globalSPB.spbLicenseNumber = vehicleNumber.text;
    }
    _globalSPB.spbType = ValueService.typeOfFormToInt(_typeDeliverValue);
    _globalSPB.spbTotalOph = _listSPBDetail.length;
    _globalSPB.updatedBy = _mConfigSchema?.employeeCode;
    _globalSPB.updatedDate = TimeManager.dateWithDash(DateTime.now());
    _globalSPB.updatedTime = TimeManager.timeWithColon(DateTime.now());
    _globalSPB.spbIsClosed = 0;
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
    _dialogService.popDialog();
    saveSPBtoDatabase(_navigationService.navigatorKey.currentContext!);
  }

  void saveSPBtoDatabase(BuildContext context) async {
    List<SPBLoader> existListLoader =
        await DatabaseSPBLoader().selectSPBLoaderBySPBID(_globalSPB);
    int countSaved = await DatabaseSPB().updateSPBByID(_globalSPB);
    if (countSaved > 0) {
      for (int i = 0; i < _spbLoaderList.length; i++) {
        if (existListLoader.contains(_spbLoaderList[i])) {
          await DatabaseSPBLoader().updateSPBLoaderByID(_spbLoaderList[i]);
        } else {
          await DatabaseSPBLoader().insertSPBLoader(_spbLoaderList[i]);
        }
      }
      for (int i = 0; i < deletedLoader.length; i++) {
        DatabaseSPBLoader().deleterSPBLoaderByID(deletedLoader[i]);
      }
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
    checkLoaderExist();
    checkLoaderPercentageValue();
    checkVehicle(context, vehicleNumber.text);
    switch (_typeDeliverValue) {
      case "Internal":
        if (_driverNameValue != null) {
          if (vehicleNumber.text.isNotEmpty) {
            if (_mvraSchema != null) {
              if (_spbLoaderList.isNotEmpty) {
                if (!_isLoaderExist) {
                  if (!_isLoaderZero) {
                    if (_totalPercentageAngkut == 100) {
                      if (_totalPercentageAngkut >= 100) {
                        showDialogQuestion(context);
                      } else {
                        FlushBarManager.showFlushBarWarning(
                            context, "Daftar Loader", "Lebih dari dari 100 %");
                      }
                    } else {
                      FlushBarManager.showFlushBarWarning(
                          context, "Daftar Loader", "Harus memuat 100 %");
                    }
                  } else {
                    FlushBarManager.showFlushBarWarning(
                        context,
                        "Daftar Loader",
                        "Anda belum menginput persentase loader");
                  }
                } else {
                  FlushBarManager.showFlushBarWarning(context, "Daftar Loader",
                      "Anda menginput loader yang sama");
                }
              } else {
                FlushBarManager.showFlushBarWarning(
                    context, "Daftar Loader", "Belum menginput Loader");
              }
            } else {
              FlushBarManager.showFlushBarWarning(
                  context, "No Kendaraan", "Tidak  sesuai");
            }
          } else {
            FlushBarManager.showFlushBarWarning(
                context, "No Kendaraan", "Anda belum mengisi nomor kendaraan");
          }
        } else {
          FlushBarManager.showFlushBarWarning(
              context, "Supir", "Anda belum memilih supir");
        }
        break;
      case "Kontrak":
        if (_isOthersVendor) {
          if (_vendorOther.text.isNotEmpty) {
            if (vehicleNumber.text.isNotEmpty) {
              if (_spbLoaderList.isNotEmpty) {
                if (!_isLoaderExist) {
                  if (!_isLoaderZero) {
                    if (_totalPercentageAngkut == 100) {
                      if (_totalPercentageAngkut >= 100) {
                        showDialogQuestion(context);
                      } else {
                        FlushBarManager.showFlushBarWarning(
                            context, "Daftar Loader", "Lebih dari dari 100 %");
                      }
                    } else {
                      FlushBarManager.showFlushBarWarning(
                          context, "Daftar Loader", "Harus memuat 100 %");
                    }
                  } else {
                    FlushBarManager.showFlushBarWarning(
                        context,
                        "Daftar Loader",
                        "Anda belum menginput persentase loader");
                  }
                } else {
                  FlushBarManager.showFlushBarWarning(context, "Daftar Loader",
                      "Anda menginput loader yang sama");
                }
              } else {
                FlushBarManager.showFlushBarWarning(
                    context, "Daftar Loader", "Belum menginput Loader");
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
              if (_spbLoaderList.isNotEmpty) {
                if (!_isLoaderExist) {
                  if (!_isLoaderZero) {
                    if (_totalPercentageAngkut == 100) {
                      if (_totalPercentageAngkut >= 100) {
                        showDialogQuestion(context);
                      } else {
                        FlushBarManager.showFlushBarWarning(
                            context, "Daftar Loader", "Lebih dari dari 100 %");
                      }
                    } else {
                      FlushBarManager.showFlushBarWarning(
                          context, "Daftar Loader", "Harus memuat 100 %");
                    }
                  } else {
                    FlushBarManager.showFlushBarWarning(
                        context,
                        "Daftar Loader",
                        "Anda belum menginput persentase loader");
                  }
                } else {
                  FlushBarManager.showFlushBarWarning(context, "Daftar Loader",
                      "Anda menginput loader yang sama");
                }
              } else {
                FlushBarManager.showFlushBarWarning(
                    context, "Daftar Loader", "Belum menginput Loader");
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
        break;
    }
  }
}

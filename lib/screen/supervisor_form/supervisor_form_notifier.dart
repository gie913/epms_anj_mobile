import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/validation_service.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_supervisor.dart';
import 'package:epms/database/service/database_t_user_assignment.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/supervisor.dart';
import 'package:epms/model/t_user_assignment_schema.dart';
import 'package:flutter/material.dart';

class SupervisorFormNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  MConfigSchema? _mConfigSchema;

  MConfigSchema? get mConfigSchema => _mConfigSchema;

  MEmployeeSchema? _mandorValue;

  MEmployeeSchema? get mandorValue => _mandorValue;

  MEmployeeSchema? _mandorValue1;

  MEmployeeSchema? get mandorValue1 => _mandorValue1;

  MEmployeeSchema? _keraniPanenValue;

  MEmployeeSchema? get keraniPanenValue => _keraniPanenValue;

  MEmployeeSchema? _keraniKirimValue;

  MEmployeeSchema? get keraniKirimValue => _keraniKirimValue;

  Supervisor? _supervisor;

  Supervisor? get supervisor => _supervisor;

  bool _isEdit = false;

  bool get isEdit => _isEdit;

  onSaveClick(BuildContext context) {
    _dialogService.showOptionDialog(
        title: "Supervisi",
        subtitle: "Anda yakin ingin menyimpan?",
        buttonTextYes: "Ya",
        buttonTextNo: "Tidak",
        onPressYes: onSaveSupervisor,
        onPressNo: _dialogService.popDialog);
  }

  onCancelClick(BuildContext context) {
    _navigationService.pop();
  }


  getSupervisi() async {
    _mConfigSchema = await DatabaseMConfig().selectMConfig();
    setDefaultSupervisor();
    notifyListeners();
  }

  onSetSupervisi(MEmployeeSchema mEmployeeSchema) {
    _mandorValue = mEmployeeSchema;
    notifyListeners();
  }

  onSetSupervisi1(MEmployeeSchema mEmployeeSchema) {
    _mandorValue1 = mEmployeeSchema;
    notifyListeners();
  }

  onSetKeraniPanen(MEmployeeSchema mEmployeeSchema) {
    _keraniPanenValue = mEmployeeSchema;
    notifyListeners();
  }

  onSetKeraniKirim(MEmployeeSchema mEmployeeSchema) {
    _keraniKirimValue = mEmployeeSchema;
    notifyListeners();
  }

  onSaveSupervisor() async {
    _dialogService.popDialog();
    Supervisor supervisor = Supervisor();
    if (ValidationService.checkEmployee(_mandorValue)) {
      if (ValidationService.checkEmployee(_mandorValue1)) {
        if (ValidationService.checkEmployee(_keraniPanenValue)) {
          if (ValidationService.checkEmployee(_keraniKirimValue)) {
            supervisor.employeeCode = _mConfigSchema?.employeeCode;
            supervisor.mandorName = _mandorValue?.employeeName!;
            supervisor.mandorCode = _mandorValue?.employeeCode!;
            supervisor.mandor1Name = _mandorValue1?.employeeName!;
            supervisor.mandor1Code = _mandorValue1?.employeeCode!;
            supervisor.keraniPanenName = _keraniPanenValue?.employeeName!;
            supervisor.keraniPanenCode = _keraniPanenValue?.employeeCode!;
            supervisor.keraniKirimName = _keraniKirimValue?.employeeName!;
            supervisor.keraniKirimCode = _keraniKirimValue?.employeeCode!;
            int saved = 0;
            if(_isEdit) {
              saved = await DatabaseSupervisor().updateSupervisor(supervisor);
            } else {
              saved = await DatabaseSupervisor().insertSupervisor(supervisor);
            }
            if (saved > 0) {
              _navigationService.push(Routes.HOME_PAGE);
              FlushBarManager.showFlushBarSuccess(
                  _navigationService.navigatorKey.currentContext!,
                  "Supervisi",
                  "Berhasil disimpan");
            }
          } else {
            _dialogService.showNoOptionDialog(
                title: "Supervisi",
                subtitle: "Kerani Kirim belum terisi",
                onPress: _dialogService.popDialog);
          }
        } else {
          _dialogService.showNoOptionDialog(
              title: "Supervisi",
              subtitle: "Kerani Panen belum terisi",
              onPress: _dialogService.popDialog);
        }
      } else {
        _dialogService.showNoOptionDialog(
            title: "Supervisi",
            subtitle: "Mandor 1 belum terisi",
            onPress: _dialogService.popDialog);
      }
    } else {
      _dialogService.showNoOptionDialog(
          title: "Supervisi",
          subtitle: "Mandor belum terisi",
          onPress: _dialogService.popDialog);
    }
  }

  void setDefaultSupervisor() async {
    _supervisor = await DatabaseSupervisor()
        .selectSupervisorByEmployeeID(_mConfigSchema!.employeeCode!);
    if (_supervisor != null) {
      _isEdit = true;
      _mandorValue = MEmployeeSchema(
          employeeCode: _supervisor?.mandorCode,
          employeeName: _supervisor?.mandorName);
      _mandorValue1 = MEmployeeSchema(
          employeeCode: _supervisor?.mandor1Code,
          employeeName: _supervisor?.mandor1Name);
      _keraniPanenValue = MEmployeeSchema(
          employeeCode: _supervisor?.keraniPanenCode,
          employeeName: _supervisor?.keraniPanenName);
      _keraniKirimValue = MEmployeeSchema(
          employeeCode: _supervisor?.keraniKirimCode,
          employeeName: _supervisor?.keraniKirimName);
    } else {
      List<TUserAssignmentSchema> tUserAssignmentSchema =
          await DatabaseTUserAssignment()
              .selectEmployeeTUserAssignmentSupervisor(_mConfigSchema!);
      if (tUserAssignmentSchema.isNotEmpty) {
        _mandorValue = MEmployeeSchema(
            employeeCode: tUserAssignmentSchema.last.mandorEmployeeCode,
            employeeName: tUserAssignmentSchema.last.mandorEmployeeName);
        _mandorValue1 = MEmployeeSchema(
            employeeCode: tUserAssignmentSchema.last.mandor1EmployeeCode,
            employeeName: tUserAssignmentSchema.last.mandor1EmployeeName);
        _keraniPanenValue = MEmployeeSchema(
            employeeCode: tUserAssignmentSchema.last.keraniPanenEmployeeCode,
            employeeName: tUserAssignmentSchema.last.keraniPanenEmployeeName);
        _keraniKirimValue = MEmployeeSchema(
            employeeCode: tUserAssignmentSchema.last.keraniKirimEmployeeCode,
            employeeName: tUserAssignmentSchema.last.keraniKirimEmployeeName);
      }
    }
    notifyListeners();
  }
}

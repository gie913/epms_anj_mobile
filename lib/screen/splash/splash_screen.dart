import 'dart:async';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/base/constants/image_assets.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/database/service/database_supervisor.dart';
import 'package:epms/model/supervisor.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Supervisor? supervisor;
  NavigatorService navigationService = locator<NavigatorService>();
  DialogService dialogService = locator<DialogService>();

  @override
  void initState() {
    // var manageExternalStorage = Permission.manageExternalStorage;
    // manageExternalStorage.request();
    autoLogIn();
    // DatabaseLocalUpdate().addNewColumnOnVersion();
    super.initState();
  }

  getSupervisi(String roles) async {
    dynamic lastSynchDate = await StorageManager.readData('lastSynchDate');
    supervisor = await DatabaseSupervisor().selectSupervisor();
    if (lastSynchDate != null) {
      if (supervisor != null) {
        navigationService.push(Routes.HOME_PAGE);
      } else {
        navigationService.push(Routes.SUPERVISOR_FORM_PAGE);
      }
    } else {
      navigationService.push(Routes.SYNCH_PAGE);
    }
  }

  void autoLogIn() async {
    dynamic session = await StorageManager.readData('userToken');
    dynamic lastSynchDate = await StorageManager.readData('lastSynchDate');
    String? roles = await StorageManager.readData('userRoles');
    // Permission.location.request();
    var duration = const Duration(seconds: 3);
    Timer(duration, () {
      if (session != null) {
        if (lastSynchDate != null) {
          if (roles == "BC") {
            getSupervisi(roles!);
          } else {
            navigationService.push(Routes.HOME_PAGE);
          }
        } else {
          if (roles == "BC") {
            getSupervisi(roles!);
          } else {
            navigationService.push(Routes.HOME_PAGE);
          }
        }
      } else {
        navigationService.push(Routes.LOGIN_PAGE);
      }
    });
  }

  // onSuccess() {
  //   deleteMasterData();
  //   StorageManager.deleteData('userId');
  //   StorageManager.deleteData('userToken');
  //   StorageManager.deleteData("setTime");
  //   navigationService.push(Routes.LOGIN_PAGE);
  // }

  // onError(String response) {
  //   navigationService.push(Routes.HOME_PAGE);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          ImageAssets.ANJ_LOGO,
          height: 65,
        ),
      ),
    );
  }

  // Future<bool> deleteMasterData() async {
  //   try {
  //     DatabaseMActivitySchema().deleteMActivitySchema();
  //     DatabaseMCOPHSchema().deleteMCOPHSchema();
  //     DatabaseMCSPBCardSchema().deleteMCSPBCardSchema();
  //     DatabaseMCostControlSchema().deleteMCostControlSchema();
  //     DatabaseMCustomerCodeSchema().deleteMCustomerCodeSchema();
  //     DatabaseMDivisionSchema().deleteMDivisionSchema();
  //     DatabaseMDestinationSchema().deleteMDestinationSchema();
  //     DatabaseMMaterialSchema().deleteMMaterialSchema();
  //     DatabaseMTPHSchema().deleteMTPHSchema();
  //     DatabaseMVRASchema().deleteMVRASchema();
  //     DatabaseTUserAssignment().deleteEmployeeTUserAssignment();
  //     DatabaseLaporanPanenKemarin().deleteLaporanPanenKemarin();
  //     DatabaseTABWSchema().deleteTABWSchema();
  //     DatabaseTHarvestingPlan().deleteTHarvestingPlan();
  //     DatabaseLaporanRestan().deleteLaporanRestan();
  //     DatabaseLaporanSPBKemarin().deleteLaporanSPBKemarin();
  //     DatabaseMVendorSchema().deleteMVendorSchema();
  //     DatabaseMEstateSchema().deleteMEstateSchema();
  //     DatabaseMEmployeeSchema().deleteMEmployeeSchema();
  //     DatabaseAttendance().deleteEmployeeAttendance();
  //     DatabaseMAttendance().deleteEmployeeAttendance();
  //     DatabaseMBlockSchema().deleteMBlockSchema();
  //     DatabaseMAncakEmployee().deleteMAncakEmployeeSchema();
  //     DatabaseTABWSchema().deleteTABWSchema();
  //     return true;
  //   } catch (E) {
  //     return false;
  //   }
  // }
}

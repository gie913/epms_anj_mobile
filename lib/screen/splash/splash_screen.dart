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
import 'package:permission_handler/permission_handler.dart';

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
    autoLogIn();
    super.initState();
  }

  getSupervisi(String roles) async {
    supervisor = await DatabaseSupervisor().selectSupervisor();
    if (supervisor != null) {
      navigationService.push(Routes.HOME_PAGE);
    } else {
      navigationService.push(Routes.SUPERVISOR_FORM_PAGE);
    }
  }

  void autoLogIn() async {
    dynamic session = await StorageManager.readData('userToken');
    String? roles = await StorageManager.readData('userRoles');
    Permission.location.request();
    var duration = const Duration(seconds: 3);
    Timer(duration, () {
      if (session != null) {
        roles == "BC"
            ? getSupervisi(roles!)
            : navigationService.push(Routes.HOME_PAGE);
      } else {
        navigationService.push(Routes.LOGIN_PAGE);
      }
    });
  }

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
}

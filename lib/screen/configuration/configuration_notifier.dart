import 'package:epms/base/api/api_endpoint.dart';
import 'package:epms/base/common/locator.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:flutter/material.dart';

class ConfigurationNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  TextEditingController _apiServer = TextEditingController();

  TextEditingController get apiServer => _apiServer;

  TextEditingController _database = TextEditingController();

  TextEditingController get database => _database;

  onInitConfiguration() async {
    String? apiServerTemp = await StorageManager.readData("apiServer");
    if (apiServerTemp == null) {
      _apiServer.text = APIEndPoint.BASE_URL;
    } else {
      _apiServer.text = apiServerTemp;
    }
    notifyListeners();
  }

  doSaveButton(BuildContext context, String apiServer, String database) {
    try {
      StorageManager.saveData("apiServer", apiServer);
      _navigationService.pop();
      FlushBarManager.showFlushBarSuccess(context, "Konfigurasi server", "Berhasil");
    } catch (e) {
      print("Save api server error");
    }
  }
}

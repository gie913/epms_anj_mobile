import 'package:connectivity_plus/connectivity_plus.dart';

class InspectionService {
  static Future<bool> isInternetConnectionExist() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}

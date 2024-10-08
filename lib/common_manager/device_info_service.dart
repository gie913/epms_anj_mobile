import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

class DeviceInfoService {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};
  DeviceInfoGeneral deviceDataGeneral = DeviceInfoGeneral();

  /// call this method in stateful widget
  /// not in main
  Future<void> initPlatform() async {
    try {
      if (Platform.isAndroid) {
        deviceData = getAndroidDeviceInfo(await deviceInfo.androidInfo);
        deviceDataGeneral = DeviceInfoGeneral(
          deviceId: deviceData["id"],
          deviceType: deviceData["device"],
          deviceName: deviceData["brand"],
        );
      } else if (Platform.isIOS) {
        deviceData = getIosDeviceInfo(await deviceInfo.iosInfo);
        deviceDataGeneral = DeviceInfoGeneral(
          deviceId: deviceData["identifierForVendor"] +
              "-" +
              deviceData["isPhysicalDevice"],
          deviceType: deviceData["model"],
          deviceName: deviceData["name"],
        );
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
      deviceDataGeneral = DeviceInfoGeneral();
    }
  }

  Map<String, dynamic> getAndroidDeviceInfo(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> getIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}

/// Device info general model
///
class DeviceInfoGeneral {
  DeviceInfoGeneral({
    this.deviceId,
    this.deviceType,
    this.deviceName,
  });

  String? deviceId;
  String? deviceType;
  String? deviceName;
  String? firebaseToken;

  factory DeviceInfoGeneral.fromMap(Map<String, dynamic> json) =>
      DeviceInfoGeneral(
        deviceId: json["deviceId"],
        deviceType: json["deviceType"],
        deviceName: json["deviceName"],
      );

  Map<String, dynamic> toMap() => {
    "deviceId": deviceId,
    "deviceType": deviceType,
    "deviceName": deviceName,
  };
}

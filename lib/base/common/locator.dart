import 'package:epms/common_manager/device_info_service.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // locator.registerLazySingleton<AudioPlayerService>(() => AudioPlayerService());
  locator
    ..registerLazySingleton<NavigatorService>(() => NavigatorService())
    ..registerLazySingleton<DialogService>(() => DialogService())
    ..registerLazySingleton<DeviceInfoService>(() => DeviceInfoService());
}
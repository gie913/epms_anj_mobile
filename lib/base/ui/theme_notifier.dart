import 'package:epms/base/ui/palette.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    fontFamily: "DIN Pro",
    brightness: Brightness.dark,
    colorScheme: ThemeData.dark().colorScheme.copyWith(
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: Colors.orange,
        ),
    primaryColor: Color(0xFF212121),
    dividerTheme: DividerThemeData(color: Colors.grey),
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Palette.primaryColorProd),
      ),
    ),
    scaffoldBackgroundColor: Colors.black,
    dividerColor: Colors.white,
    // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange).copyWith(
    //   background: Colors.black,
    //   brightness: Brightness.dark,
    // ),
    useMaterial3: true,
  );

  final lightTheme = ThemeData(
    fontFamily: "DIN Pro",
    primaryColor: Palette.greenColor,
    primaryColorDark: Palette.greenColorDark,
    primaryColorLight: Palette.greenColorLight,
    appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        color: Palette.primaryColorProd),
    indicatorColor: Colors.white,
    scaffoldBackgroundColor: Color(0xFFF9F9F9),
    cardColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Palette.greenColor),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.orange,
      brightness: Brightness.light,
    ).copyWith(background: Colors.white),
    useMaterial3: true,
  );

  ThemeData? _themeData;

  bool? _status;

  bool? get status => _status;

  ThemeData? getTheme() => _themeData;

  ThemeNotifier() {
    _status = false;
    StorageManager.readData('themeMode').then((value) {
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
        _status = false;
      } else {
        print('setting dark theme');
        _themeData = darkTheme;
        _status = true;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    _status = true;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    _status = false;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}

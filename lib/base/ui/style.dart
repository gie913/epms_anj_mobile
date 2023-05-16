import 'package:epms/base/ui/palette.dart';
import 'package:flutter/material.dart';

class Style {
  static TextStyle textBold = TextStyle(fontWeight: FontWeight.bold);
  static TextStyle textBold12 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
  static TextStyle textBold14 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
  static TextStyle textBold16 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  static TextStyle textBold18 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  static TextStyle textBold20 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  static TextStyle textBold22 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 22);
  static TextStyle textBold24 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 24);
  static TextStyle textBold26 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 26);
  static TextStyle textBold28 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 28);
  static TextStyle textBold30 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 30);

  static TextStyle textBoldBlack = TextStyle(fontWeight: FontWeight.bold);
  static TextStyle textBoldBlack12 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black);
  static TextStyle textBoldBlack14 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black);
  static TextStyle textBoldBlack16 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black);
  static TextStyle textBoldBlack18 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black);
  static TextStyle textBoldBlack20 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black);
  static TextStyle textBoldBlack22 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black);
  static TextStyle textBoldBlack24 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black);
  static TextStyle textBoldBlack26 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black);
  static TextStyle textBoldBlack28 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.black);
  static TextStyle textBoldBlack30 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black);

  static TextStyle whiteBold = TextStyle(fontWeight: FontWeight.bold);
  static TextStyle whiteBold12 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white);
  static TextStyle whiteBold14 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white);
  static TextStyle whiteBold16 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white);
  static TextStyle whiteBold18 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white);
  static TextStyle whiteBold20 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white);
  static TextStyle whiteBold22 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white);
  static TextStyle whiteBold24 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white);
  static TextStyle whiteBold26 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.white);
  static TextStyle whiteBold28 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.white);

  static TextStyle primaryBold =
      TextStyle(fontWeight: FontWeight.bold, color: Palette.primaryColorProd);
  static TextStyle primaryBold12 = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Palette.primaryColorProd);
  static TextStyle primaryBold14 = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Palette.primaryColorProd);
  static TextStyle primaryBold16 = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Palette.primaryColorProd);
  static TextStyle primaryBold18 = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Palette.primaryColorProd);
  static TextStyle primaryBold20 = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Palette.primaryColorProd);
  static TextStyle primaryBold22 = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22,
      color: Palette.primaryColorProd);
  static TextStyle primaryBold24 = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: Palette.primaryColorProd);
  static TextStyle primaryBold26 = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 26,
      color: Palette.primaryColorProd);
  static TextStyle primaryBold28 = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 28,
      color: Palette.primaryColorProd);

  static TextStyle redBold =
      TextStyle(fontWeight: FontWeight.bold, color: Palette.redColorLight);
  static TextStyle redBold12 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 12, color: Palette.redColorLight);
  static TextStyle redBold14 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 14, color: Palette.redColorLight);
  static TextStyle redBold16 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 16, color: Palette.redColorLight);
  static TextStyle redBold18 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 18, color: Palette.redColorLight);
  static TextStyle redBold20 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 20, color: Palette.redColorLight);
  static TextStyle redBold22 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 22, color: Palette.redColorLight);
  static TextStyle redBold24 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 24, color: Palette.redColorLight);
  static TextStyle redBold26 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 26, color: Palette.redColorLight);
  static TextStyle redBold28 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 28, color: Palette.redColorLight);

  static mediaQueryText(BuildContext context) {
    return MediaQuery.of(context).copyWith(textScaleFactor: 1.22);
  }
}

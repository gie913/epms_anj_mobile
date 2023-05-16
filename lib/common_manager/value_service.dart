import 'dart:math';
import 'dart:typed_data';

import 'package:epms/base/common/routes.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/screen/kerani_kirim/kerani_kirim_menu/kerani_kirim_screen.dart';
import 'package:epms/screen/kerani_panen/kerani_panen_menu/kerani_panen_screen.dart';
import 'package:epms/screen/supervisor/supervisor_menu/supervisor_screen.dart';
import 'package:epms/screen/supervisor_spb/supervisor_spb_menu/supervisor_spb_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nfc_manager/nfc_manager.dart';

class ValueService {
  static Future<String> tagReader(NfcTag tag) async {
    var ndef = Ndef.from(tag);
    NdefMessage? ndefMessage = await ndef?.read();
    Uint8List? uInt8list = ndefMessage?.records[0].payload;
    String string = String.fromCharCodes(uInt8list!);
    String message = string.replaceAll("\n", "").substring(3);
    return message;
  }

  static String ophCardTag(OPH oph) {
    var ophTag = "O${oph.ophCardId}," +
        "${oph.ophId}," +
        "${oph.ophHarvestingMethod}," +
        "${oph.ophHarvestingType}," +
        "${oph.mandorEmployeeCode}," +
        "${oph.employeeCode}," +
        "${oph.mandor1EmployeeCode}," +
        "${oph.ophEstateCode}," +
        "${oph.ophDivisionCode}," +
        "${oph.ophBlockCode}," +
        "${oph.ophTphCode}," +
        "${oph.bunchesRipe}," +
        "${oph.bunchesOverripe}," +
        "${oph.bunchesHalfripe}," +
        "${oph.bunchesUnripe}," +
        "${oph.bunchesAbnormal}," +
        "${oph.bunchesEmpty}," +
        "${oph.looseFruits}," +
        "${oph.bunchesTotal}," +
        "${oph.bunchesNotSent}," +
        "${oph.isRestantPermanent}," +
        "${oph.createdDate}," +
        "${oph.createdTime}," +
        "${oph.ophEstimateTonnage}";
    return ophTag;
  }

  static String spbCardTag(SPB spb) {
    var spbTag = "S${spb.spbCardId}," +
        "${spb.spbId}," +
        "${spb.spbType}," +
        "${spb.spbKeraniTransportEmployeeCode}," +
        "${spb.spbDriverEmployeeCode}," +
        "${spb.spbDeliverToCode}," +
        "${spb.spbDeliverToName}," +
        "${spb.spbLicenseNumber}," +
        "${spb.spbEstateCode}," +
        "${spb.spbDivisionCode}," +
        "${spb.spbTotalOph}," +
        "${spb.spbTotalBunches}," +
        "${spb.spbTotalLooseFruit}," +
        "${spb.spbEstimateTonnage}," +
        "${spb.createdDate}," +
        "${spb.createdTime}," +
        "${spb.spbEstateVendorCode}";
    return spbTag;
  }

  static String? typeOfFormToText(int type) {
    String? typeValue;
    switch (type) {
      case 1:
        typeValue = "Internal";
        break;
      case 2:
        typeValue = "Pinjam";
        break;
      case 3:
        typeValue = "Kontrak";
        break;
    }
    return typeValue;
  }

  static String? typeOfDestination(int type) {
    String? typeValue;
    switch (type) {
      case 1:
        typeValue = "TPH-PKS";
        break;
      case 2:
        typeValue = "TPB-PKS";
        break;
    }
    return typeValue;
  }

  static int? typeOfFormToInt(String type) {
    int? typeValue;
    switch (type) {
      case "Internal":
        typeValue = 1;
        break;
      case "Pinjam":
        typeValue = 2;
        break;
      case "Kontrak":
        typeValue = 3;
        break;
    }
    return typeValue;
  }

  static String? harvestingType(int type) {
    String? isMechanic;
    switch (type) {
      case 1:
        isMechanic = "Ya";
        break;
      case 2:
        isMechanic = "Tidak";
        break;
    }
    return isMechanic;
  }

  static String generateIDFromDateTime(DateTime now) {
    String iDTime = now.year.toString().substring(2) +
        DateFormat('MM').format(now) +
        DateFormat('dd').format(now) +
        DateFormat('HH').format(now) +
        DateFormat('mm').format(now) +
        DateFormat('ss').format(now);
    return iDTime;
  }

  String generateIDLoader(DateTime now) {
    String idLoader = now.millisecondsSinceEpoch.toString() + generate4Digits();
    return idLoader;
  }

  String generate4Digits() {
      var rng = Random();
      String generatedNumber = '';
      for(int i=0;i<4;i++){
        generatedNumber += (rng.nextInt(9)+1).toString();

      }
      return generatedNumber;
  }

  static Widget getMenuFromRoles(String roles) {
    Widget widget = KeraniPanenScreen();
    switch (roles) {
      case "BC":
        widget = KeraniPanenScreen();
        break;
      case "TP":
        widget = KeraniKirimScreen();
        break;
      case "Supervisi":
        widget = SupervisorScreen();
        break;
      case "Supervisi_spb":
        widget = SupervisorSPBScreen();
    }
    return widget;
  }

  static String getMenuFirst(String roles) {
    String widget = Routes.HOME_PAGE;
    if (roles == "BC") {
      widget = Routes.SUPERVISOR_FORM_PAGE;
    } else {
      widget = Routes.HOME_PAGE;
    }
    return widget;
  }

  static String thousandSeparator(dynamic value) {
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    return myFormat.format(value);
  }
}

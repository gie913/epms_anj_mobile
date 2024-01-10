import 'dart:math';
import 'dart:typed_data';

import 'package:epms/base/common/routes.dart';
import 'package:epms/database/service/database_m_estate.dart';
import 'package:epms/model/m_estate_schema.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_detail.dart';
import 'package:epms/model/tbs_luar.dart';
import 'package:epms/screen/kerani/kerani_menu/kerani_screen.dart';
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
    if (ndef != null) {
      final ndefMessage = await ndef.read();
      Uint8List? uInt8list = ndefMessage.records[0].payload;
      String string = String.fromCharCodes(uInt8list);
      String message = string.replaceAll("\n", "").substring(3);
      return message;
    }
    return '';
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

  static Future<String> spbCardTag(SPB spb, List<SPBDetail> list) async {
    List<String> blockFormatIntiOrPlasma = [];
    List<String> blockFormatInti = [];
    List<String> blockFormatPlasma = [];

    int countInti = 0;
    int countPlasma = 0;
    // typeTBS = 1 Inti, 2 Plasma, 3 Campuran
    int typeTBS = checkTypeTBS(list);

    MEstateSchema? mEstateSchemaInti;
    MEstateSchema? mEstateSchemaPlasma;

    List<SPBDetail> listSPBDetailInti = [];
    List<SPBDetail> listSPBDetailPlasma = [];

    String mostEstateCodeInti = '';
    String mostEstateCodePlasma = '';

    String mostDivisionCodeInti = '';
    String mostDivisionCodePlasma = '';

    for (var i = 0; i < list.length; i++) {
      if (plasmaValidator(list[i].ophEstateCode!) == 1) {
        listSPBDetailInti.add(list[i]);
        countInti++;
      } else {
        listSPBDetailPlasma.add(list[i]);
        countPlasma++;
      }
    }

    if (countInti > 0 && countPlasma > 0) {
      typeTBS = 3;
    } else if (countInti > 0) {
      typeTBS = 1;
    } else if (countPlasma > 0) {
      typeTBS = 2;
    }

    // Check Most Estate & Division Inti
    int maxCountEstateInti = 0;
    for (int i = 0; i < listSPBDetailInti.length; i++) {
      int countEstateInti = 0;
      for (int j = 0; j < listSPBDetailInti.length; j++) {
        if (listSPBDetailInti[i].ophEstateCode ==
            listSPBDetailInti[j].ophEstateCode) {
          countEstateInti++;
        }
      }

      if (countEstateInti > maxCountEstateInti) {
        maxCountEstateInti = countEstateInti;
        mostEstateCodeInti = listSPBDetailInti[i].ophEstateCode!;
      }
    }

    List<SPBDetail> listSPBDetailMostEstateInti = [];
    for (int i = 0; i < listSPBDetailInti.length; i++) {
      if (listSPBDetailInti[i].ophEstateCode! == mostEstateCodeInti) {
        listSPBDetailMostEstateInti.add(listSPBDetailInti[i]);
      }
    }

    int maxCountDivisionInti = 0;
    for (int i = 0; i < listSPBDetailMostEstateInti.length; i++) {
      int countDivisionInti = 0;
      for (int j = 0; j < listSPBDetailMostEstateInti.length; j++) {
        if (listSPBDetailMostEstateInti[i].ophDivisionCode ==
            listSPBDetailMostEstateInti[j].ophDivisionCode) {
          countDivisionInti++;
        }
      }

      if (countDivisionInti > maxCountDivisionInti) {
        maxCountDivisionInti = countDivisionInti;
        mostDivisionCodeInti = listSPBDetailMostEstateInti[i].ophDivisionCode!;
      }
    }

    // Check Most Estate & Division Plasma
    int maxCountEstatePlasma = 0;
    for (int i = 0; i < listSPBDetailPlasma.length; i++) {
      int countEstatePlasma = 0;
      for (int j = 0; j < listSPBDetailPlasma.length; j++) {
        if (listSPBDetailPlasma[i].ophEstateCode ==
            listSPBDetailPlasma[j].ophEstateCode) {
          countEstatePlasma++;
        }
      }

      if (countEstatePlasma > maxCountEstatePlasma) {
        maxCountEstatePlasma = countEstatePlasma;
        mostEstateCodePlasma = listSPBDetailPlasma[i].ophEstateCode!;
      }
    }

    List<SPBDetail> listSPBDetailMostEstatePlasma = [];
    for (int i = 0; i < listSPBDetailPlasma.length; i++) {
      if (listSPBDetailPlasma[i].ophEstateCode! == mostEstateCodePlasma) {
        listSPBDetailMostEstatePlasma.add(listSPBDetailPlasma[i]);
      }
    }

    int maxCountDivisionPlasma = 0;
    for (int i = 0; i < listSPBDetailMostEstatePlasma.length; i++) {
      int countDivisionPlasma = 0;
      for (int j = 0; j < listSPBDetailMostEstatePlasma.length; j++) {
        if (listSPBDetailMostEstatePlasma[i].ophDivisionCode ==
            listSPBDetailMostEstatePlasma[j].ophDivisionCode) {
          countDivisionPlasma++;
        }
      }

      if (countDivisionPlasma > maxCountDivisionPlasma) {
        maxCountDivisionPlasma = countDivisionPlasma;
        mostDivisionCodePlasma =
            listSPBDetailMostEstatePlasma[i].ophDivisionCode!;
      }
    }

    mEstateSchemaInti = await DatabaseMEstateSchema()
        .selectMEstateSchemaByEstateCode(mostEstateCodeInti);
    mEstateSchemaPlasma = await DatabaseMEstateSchema()
        .selectMEstateSchemaByEstateCode(mostEstateCodePlasma);

/*remark bug
    for (int i = 0; i < list.length; i++) {
      if (listCombine.isEmpty) {
        listCombine.add(list[i]);
      } else {
        for (int j = 0; j < listCombine.length; j++) {
          if (listCombine[j].ophBlockCode == list[i].ophBlockCode) {
            listCombine[j].ophBunchesDelivered = listCombine[j].ophBunchesDelivered! + list[i].ophBunchesDelivered!;
          } else {
            listCombine.add(list[i]);
          }
        }
      }
    }
    */
    //test_ari

    int fgh = 0;
    int temp = 0;
    int temp2 = 0;
    List<SPBDetCombine> obj = [];
    for (int i = 0; i < list.length; i++) {
      fgh =
          obj.indexWhere((asd) => (asd.ophBlockCode == list[i].ophBlockCode!));
      if (fgh == -1) {
        SPBDetCombine ob = new SPBDetCombine();
        ob.tbsType = plasmaValidator(list[i].ophEstateCode!);
        ob.ophEstateCode = list[i].ophEstateCode!;
        ob.ophBlockCode = list[i].ophBlockCode!;
        ob.ophLooseFruitDelivered = list[i].ophLooseFruitDelivered!;
        ob.ophBunchesDelivered = list[i].ophBunchesDelivered!;
        obj.add(ob);
      } else {
        temp = 0;
        temp2 = 0;
        temp = list[i].ophBunchesDelivered!;
        temp2 = obj[fgh].ophBunchesDelivered!;
        obj[fgh].ophBunchesDelivered = temp + temp2;
        temp = 0;
        temp2 = 0;
        temp = list[i].ophLooseFruitDelivered!;
        temp2 = obj[fgh].ophLooseFruitDelivered!;
        obj[fgh].ophLooseFruitDelivered = temp + temp2;
        //blockFormat.add(list[i].ophBlockCode!.toString() + list[i].ophBunchesDelivered!.toString()+list[i].ophLooseFruitDelivered.toString());
      }
    }

    String spbTag = "";
    // var spbTagCampuran = "S${spb.spbCardId}," +
    //     "${spb.spbId}," +
    //     "${spb.spbType}," +
    //     "${spb.spbKeraniTransportEmployeeCode}," +
    //     "${spb.spbDriverEmployeeCode}," +
    //     "${spb.spbDeliverToCode}," +
    //     "${spb.spbDeliverToName}," +
    //     "${spb.spbLicenseNumber}," +
    //     "${spb.spbEstateCode}," +
    //     "${spb.spbDivisionCode}," +
    //     "${spb.spbTotalOph}," +
    //     "${spb.spbTotalBunches}," +
    //     "${spb.spbTotalLooseFruit}," +
    //     "${spb.spbEstimateTonnage}," +
    //     "${spb.createdDate}," +
    //     "${spb.createdTime}";

    obj.sort((a, b) => b.tbsType!.compareTo(a.tbsType!));
    obj.forEach((element) {
      if (typeTBS == 3) {
        if (plasmaValidator(element.ophEstateCode!) == 1) {
          // spbTagCampuran =
          //     '$spbTagCampuran,${mEstateSchemaInti?.estateVendorCode},$typeTBS,${mEstateSchemaInti?.estateVendorCode?.substring(4)}[${element.ophBlockCode},${element.ophBunchesDelivered},${element.ophLooseFruitDelivered}]';
          blockFormatInti.add(
              "${element.ophBlockCode},${element.ophBunchesDelivered},${element.ophLooseFruitDelivered}");
        } else if (plasmaValidator(element.ophEstateCode!) == 2) {
          // spbTagCampuran =
          //     '$spbTagCampuran,${mEstateSchemaPlasma?.estateVendorCode},$typeTBS,${mEstateSchemaPlasma?.estateVendorCode?.substring(4)}[${element.ophBlockCode},${element.ophBunchesDelivered},${element.ophLooseFruitDelivered}]';
          blockFormatPlasma.add(
              "${element.ophBlockCode},${element.ophBunchesDelivered},${element.ophLooseFruitDelivered}");
        }
      } else {
        blockFormatIntiOrPlasma.add(
            "${element.ophBlockCode},${element.ophBunchesDelivered},${element.ophLooseFruitDelivered}");
      }
    });

    //test
/*remark test
    listCombine.forEach((element) {
      blockFormat.add("${element.ophBlockCode},${element.ophBunchesDelivered},${element.ophLooseFruitDelivered}");
    });
 */

    if (typeTBS == 3) {
      // spbTag = spbTagCampuran;
      String blockListInti = blockFormatInti.join("#");
      String blockListPlasma = blockFormatPlasma.join("#");
      var spbTagCampuranNew = "S${spb.spbCardId}," +
          "${spb.spbId}," +
          "${spb.spbType}," +
          "${spb.spbKeraniTransportEmployeeCode}," +
          "${spb.spbDriverEmployeeCode}," +
          "${spb.spbDeliverToCode}," +
          "${spb.spbDeliverToName}," +
          "${spb.spbLicenseNumber}," +
          "$mostEstateCodePlasma," +
          "$mostDivisionCodePlasma," +
          "${spb.spbTotalOph}," +
          "${spb.spbTotalBunches}," +
          "${spb.spbTotalLooseFruit}," +
          "${spb.spbEstimateTonnage}," +
          "${spb.createdDate}," +
          "${spb.createdTime}," +
          "${mEstateSchemaPlasma.estateVendorCode}," +
          "$typeTBS," +
          "${mEstateSchemaPlasma.estateVendorCode!.substring(4)}[$blockListPlasma]," +
          "${mEstateSchemaInti.estateVendorCode}," +
          "$mostDivisionCodeInti," +
          "${mEstateSchemaInti.estateVendorCode!.substring(4)}[$blockListInti]";
      spbTag = spbTagCampuranNew;
    } else {
      int isPlasma = plasmaValidator(spb.spbEstateCode!);
      String blockList = blockFormatIntiOrPlasma.join("#");
      var spbTagIntiOrPlasma = "S${spb.spbCardId}," +
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
          "${spb.spbEstateVendorCode}," +
          "$isPlasma," +
          "${spb.spbEstateVendorCode!.substring(4)}"
              "[$blockList]";
      spbTag = spbTagIntiOrPlasma;
    }

    return spbTag;
  }

  static String tbsLuarTag(TBSLuar tbsLuar) {
    var tbsLuarTag = "${tbsLuar.spdID}," +
        "${tbsLuar.formType}," +
        "${tbsLuar.bunchesUnripe}," +
        "${tbsLuar.bunchesHalfripe}," +
        "${tbsLuar.bunchesOverripe}," +
        "${tbsLuar.bunchesRotten}," +
        "${tbsLuar.bunchesAbnormal}," +
        "${tbsLuar.bunchesEmpty}," +
        "${tbsLuar.rubbish}," +
        "${tbsLuar.water}," +
        "${tbsLuar.longStalk}," +
        "${tbsLuar.brondolanRotten}," +
        "${tbsLuar.bunchesLess4Kg}," +
        "${tbsLuar.bunchesCengkeh}," +
        "${tbsLuar.bunchesTotal}," +
        "${tbsLuar.deduction}," +
        "${tbsLuar.small}";
    return tbsLuarTag;
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
      case 2:
        isMechanic = "Ya";
        break;
      case 1:
        isMechanic = "Tidak";
        break;
    }
    return isMechanic;
  }

  static int? spbSourceData(String source) {
    int? value;
    switch (source) {
      case "Internal":
        value = 1;
        break;
      case "External":
        value = 3;
        break;
    }
    return value;
  }

  static int? sourceData(String type) {
    int? value;
    switch (type) {
      case "Internal":
        value = 1;
        break;
      case "External":
        value = 3;
        break;
    }
    return value;
  }

  static String? spbSourceDataText(int type) {
    String? value;
    switch (type) {
      case 1:
        value = "Internal";
        break;
      case 3:
        value = "External";
        break;
    }
    return value;
  }

  static String sourceDataText(String type) {
    String value = "Internal";
    switch (type) {
      case "1":
        value = "Internal";
        break;
      case "3":
        value = "External";
        break;
    }
    return value;
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

  static List<String> generateIDImageFromDateTime(DateTime now) {
    List<String> list = [];
    for (int i = 0; i < 11; i++) {
      String iDTime = now.year.toString() +
          DateFormat('MM').format(now) +
          DateFormat('dd').format(now) +
          "_" +
          DateFormat('HH').format(now) +
          DateFormat('mm').format(now) +
          "${(int.parse(DateFormat('ss').format(now)) - i)}";
      list.add(iDTime);
    }
    return list;
  }

  String generateIDLoader(DateTime now) {
    String idLoader = now.millisecondsSinceEpoch.toString() + generate4Digits();
    return idLoader;
  }

  String generate4Digits() {
    var rng = Random();
    String generatedNumber = '';
    for (int i = 0; i < 4; i++) {
      generatedNumber += (rng.nextInt(9) + 1).toString();
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
      case "KR":
        widget = KeraniScreen();
        break;
      case "Supervisi":
        widget = SupervisorScreen();
        break;
      case "Supervisi_Estate_Manager":
        widget = SupervisorScreen();
        break;
      case "Supervisi_spb":
        widget = SupervisorSPBScreen();
    }
    return widget;
  }

  static String getMenuFirst(String roles) {
    String widget = Routes.HOME_PAGE;
    print('cek role : $roles');
    if (roles == "BC" || roles == 'KR') {
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

  static String rightTrimVendor(String vendor) {
    return vendor.trim();
  }

  static int plasmaValidator(String estate) {
    int? i;
    final validCharacters = RegExp(r'^[0-9]+$');
    print(validCharacters.hasMatch(estate));
    if (validCharacters.hasMatch(estate)) {
      i = 1;
    } else {
      i = 2;
    }
    return i;
  }

  static int checkTypeTBS(List<SPBDetail> listSPBDetail) {
    int countInti = 0;
    int countPlasma = 0;
    for (var i = 0; i < listSPBDetail.length; i++) {
      if (plasmaValidator(listSPBDetail[i].ophEstateCode!) == 1) {
        countInti++;
      } else {
        countPlasma++;
      }
    }

    if (countInti > 0 && countPlasma > 0) {
      return 3;
    } else if (countInti > 0) {
      return 1;
    } else if (countPlasma > 0) {
      return 2;
    } else {
      return 0;
    }
  }
}

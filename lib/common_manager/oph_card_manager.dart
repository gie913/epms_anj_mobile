import 'package:epms/common_manager/value_service.dart';
import 'package:epms/model/oph.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

import 'encryption_manager.dart';

class OPHCardManager {
  ValueNotifier<dynamic> resultNFC = ValueNotifier(null);

  writeOPHCard(BuildContext context, OPH oph, onSuccess, onError) {
    String ophTag = ValueService.ophCardTag(oph);
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        resultNFC.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: resultNFC.value);
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText(EncryptionManager.encryptData(ophTag)),
      ]);

      try {
        await ndef.write(message);
        resultNFC.value = 'Success to Write';
        onSuccess(context, oph);
        Future.delayed(const Duration(milliseconds: 1200), () {
          NfcManager.instance.stopSession();
        });
      } catch (e) {
        resultNFC.value = e;
        onError(context);
        NfcManager.instance
            .stopSession(errorMessage: resultNFC.value.toString());
      }
    });
  }

  readOPHCard(BuildContext context, onSuccess, onError) {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      try {
        ValueService.tagReader(tag).then((value) {
          String decryptData = EncryptionManager.decryptData(value);
          if (decryptData.characters.first == "O") {
            final split = decryptData.split(',');
            final Map<int, String> values = {
              for (int i = 0; i < split.length; i++) i: split[i]
            };
            OPH ophTemp = OPH();
            ophTemp.ophCardId = values[0]?.substring(1);
            ophTemp.ophId = values[1];
            ophTemp.ophHarvestingMethod = int.parse(values[2]!);
            ophTemp.ophHarvestingType = int.parse(values[3]!);
            ophTemp.mandorEmployeeCode = values[4];
            ophTemp.employeeCode = values[5];
            ophTemp.mandor1EmployeeCode = values[6];
            ophTemp.ophEstateCode = values[7];
            ophTemp.ophDivisionCode = values[8];
            ophTemp.ophBlockCode = values[9];
            ophTemp.ophTphCode = values[10];
            ophTemp.bunchesRipe = int.parse(values[11]!);
            ophTemp.bunchesOverripe = int.parse(values[12]!);
            ophTemp.bunchesHalfripe = int.parse(values[13]!);
            ophTemp.bunchesUnripe = int.parse(values[14]!);
            ophTemp.bunchesAbnormal = int.parse(values[15]!);
            ophTemp.bunchesEmpty = int.parse(values[16]!);
            ophTemp.looseFruits = int.parse(values[17]!);
            ophTemp.bunchesTotal = int.parse(values[18]!);
            ophTemp.bunchesNotSent = int.parse(values[19]!);
            ophTemp.isRestantPermanent = int.parse(values[20]!);
            ophTemp.createdDate = values[21];
            ophTemp.createdTime = values[22];
            ophTemp.ophEstimateTonnage = double.parse(values[23]!);
            onSuccess(context, ophTemp);
          } else {
            onError(context, "Bukan Kartu OPH");
          }
        });
      } catch (e) {
        onError(context, "Gagal Membaca Kartu OPH");
      }
    });
  }
}

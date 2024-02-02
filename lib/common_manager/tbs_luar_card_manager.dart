import 'dart:developer';

import 'package:epms/common_manager/value_service.dart';
import 'package:epms/model/tbs_luar.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

import 'encryption_manager.dart';

class TBSLuarCardManager {
  ValueNotifier<dynamic> resultNFC = ValueNotifier(null);

  writeTBSLuarCard(BuildContext context, TBSLuar tbsLuar, onSuccess, onError) {
    String tbsLuarTag = ValueService.tbsLuarTag(tbsLuar);
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        resultNFC.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: resultNFC.value);
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText(EncryptionManager.encryptData(tbsLuarTag)),
      ]);

      try {
        await ndef.write(message);
        resultNFC.value = 'Success to Write';
        onSuccess(context, tbsLuar);
      } catch (e) {
        resultNFC.value = e;
        onError(context);
      }
    });
  }

  readTBSLuarCard(BuildContext context, onSuccess, onError) {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      try {
        ValueService.tagReader(tag).then((value) {
          String decryptData = EncryptionManager.decryptData(value);
          log('cek decryptData TBS Luar Card : $decryptData');
          if (decryptData.characters.first == "D") {
            final split = decryptData.split(',');
            var data = {};
            for (var i = 0; i < split.length; i++) {
              data[i] = split[i];
            }
            TBSLuar tbsLuarTemp = TBSLuar();
            tbsLuarTemp.spdID = data[0];
            tbsLuarTemp.formType = int.tryParse(data[1]);
            tbsLuarTemp.bunchesUnripe = data[2];
            tbsLuarTemp.bunchesHalfripe = data[3];
            tbsLuarTemp.bunchesOverripe = data[4];
            tbsLuarTemp.bunchesRotten = data[5];
            tbsLuarTemp.bunchesAbnormal = data[6];
            tbsLuarTemp.bunchesEmpty = data[7];
            tbsLuarTemp.rubbish = data[8];
            tbsLuarTemp.water = data[9];
            tbsLuarTemp.longStalk = data[10];
            tbsLuarTemp.brondolanRotten = data[11];
            tbsLuarTemp.bunchesLess4Kg = data[12];
            tbsLuarTemp.bunchesCengkeh = data[13];
            tbsLuarTemp.bunchesTotal = data[14];
            tbsLuarTemp.deduction = data[15];
            tbsLuarTemp.small = data[16];
            tbsLuarTemp.sortasiID = data[17];
            tbsLuarTemp.createdDate = data[18];
            tbsLuarTemp.createdTime = data[19];
            tbsLuarTemp.gpsLat = data[20];
            tbsLuarTemp.gpsLong = data[21];
            tbsLuarTemp.supplierCode = data[22];
            tbsLuarTemp.contractNumber = data[23];
            tbsLuarTemp.driverName = data[24];
            tbsLuarTemp.licenseNumber = data[25];
            tbsLuarTemp.notes = data[26];
            onSuccess(context, tbsLuarTemp);
          } else {
            onError(context, "Bukan Kartu Grading TBS");
          }
        });
      } catch (e) {
        onError(context, "Gagal Membaca Kartu Grading TBS");
      }
    });
  }
}

import 'dart:developer';

import 'package:epms/common_manager/value_service.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:nfc_manager/nfc_manager.dart';

import 'encryption_manager.dart';

class SPBCardManager {
  ValueNotifier<dynamic> resultNFC = ValueNotifier(null);

  writeSPBCard(BuildContext context, SPB spb, List<SPBDetail> listSPBDetail,
      onSuccess, onError) {
    String spbTag = ValueService.spbCardTag(spb, listSPBDetail);
    log('cek spbTag : $spbTag');
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        resultNFC.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: resultNFC.value);
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText(EncryptionManager.encryptData(spbTag)),
      ]);

      try {
        await ndef.write(message);
        resultNFC.value = 'Success to "Ndef Write"';
        onSuccess(context);
      } catch (e) {
        resultNFC.value = e;
        NfcManager.instance
            .stopSession(errorMessage: resultNFC.value.toString());
        onError(context);
        return;
      }
    });
  }

  void readSPBCard(BuildContext context, onSuccess, onError) {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      ValueService.tagReader(tag).then((value) {
        String decryptData = EncryptionManager.decryptData(value);
        log('cek decryptData SPB Card : $decryptData');
        if (decryptData.characters.first == "S") {
          final split = decryptData.split(',');
          final Map<int, String> values = {
            for (int i = 0; i < split.length; i++) i: split[i]
          };
          SPB spbTemp = SPB();
          spbTemp.spbCardId = values[0]?.substring(1);
          spbTemp.spbId = values[1];
          spbTemp.spbType = int.parse(values[2]!);
          spbTemp.spbKeraniTransportEmployeeCode = values[3];
          spbTemp.spbDriverEmployeeCode = values[4];
          spbTemp.spbDeliverToCode = values[5];
          spbTemp.spbDeliverToName = values[6];
          spbTemp.spbLicenseNumber = values[7];
          spbTemp.spbEstateCode = values[8];
          spbTemp.spbDivisionCode = values[9];
          spbTemp.spbTotalOph = int.tryParse(values[10]!);
          spbTemp.spbTotalBunches = int.tryParse(values[11]!);
          spbTemp.spbTotalLooseFruit = int.tryParse(values[12]!);
          spbTemp.spbEstimateTonnage = int.tryParse(values[13]!);
          spbTemp.createdDate = values[14];
          spbTemp.createdTime = values[15];
          spbTemp.spbEstateVendorCode = values[16];
          onSuccess(context, spbTemp);
        } else {
          onError(context, "Bukan Kartu SPB");
        }
      });
    });
  }
}

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
          if (decryptData.characters.first == "D") {
            final split = decryptData.split(',');
            final Map<int, String> values = {
              for (int i = 0; i < split.length; i++) i: split[i]
            };
            TBSLuar tbsLuarTemp = TBSLuar();
            tbsLuarTemp.spdID = values[0];
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
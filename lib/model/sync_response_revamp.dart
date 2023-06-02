import 'package:epms/model/global.dart';
import 'package:epms/model/kerani_kirim.dart';
import 'package:epms/model/kerani_model.dart';
import 'package:epms/model/kerani_panen.dart';
import 'package:epms/model/oph_history_model.dart';
import 'package:epms/model/supervisi.dart';
import 'package:epms/model/supervisi_3rd_party.dart';

class SynchResponse {
  String? message;
  Global? global;
  KeraniPanen? keraniPanen;
  KeraniKirim? keraniKirim;
  KeraniModel? kerani;
  Supervisi? supervisi;
  List<Supervisi3rdParty>? supervisi3rdParty;
  List<OphHistoryModel>? ophHistory;

  SynchResponse({
    this.message,
    this.global,
    this.keraniPanen,
    this.keraniKirim,
    this.kerani,
    this.supervisi,
    this.supervisi3rdParty,
    this.ophHistory,
  });

  SynchResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    global =
        json['global'] != null ? new Global.fromJson(json['global']) : null;
    keraniPanen = json['kerani_panen'] != null
        ? new KeraniPanen.fromJson(json['kerani_panen'])
        : null;
    keraniKirim = json['kerani_kirim'] != null
        ? new KeraniKirim.fromJson(json['kerani_kirim'])
        : null;
    kerani = json['kerani'] != null
        ? new KeraniModel.fromJson(json['kerani'])
        : null;
    supervisi = json['supervisi'] != null
        ? new Supervisi.fromJson(json['supervisi'])
        : null;
    if (json['supervisi_3rd_party'] != null) {
      supervisi3rdParty = <Supervisi3rdParty>[];
      json['supervisi_3rd_party'].forEach((v) {
        supervisi3rdParty!.add(new Supervisi3rdParty.fromJson(v));
      });
    }
    ophHistory = json['oph_history'] != null
        ? List<OphHistoryModel>.from((json['oph_history'] as List<String>)
            .map((e) => OphHistoryModel(ophId: e)))
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.global != null) {
      data['global'] = this.global!.toJson();
    }
    if (this.keraniPanen != null) {
      data['kerani_panen'] = this.keraniPanen!.toJson();
    }
    if (this.keraniKirim != null) {
      data['kerani_kirim'] = this.keraniKirim!.toJson();
    }
    if (this.kerani != null) {
      data['kerani'] = this.kerani!.toJson();
    }
    if (this.supervisi != null) {
      data['supervisi'] = this.supervisi!.toJson();
    }
    if (this.supervisi3rdParty != null) {
      data['supervisi_3rd_party'] =
          this.supervisi3rdParty!.map((v) => v.toJson()).toList();
    }
    if (this.ophHistory != null) {
      data['oph_history'] = this.ophHistory!.map((e) => e.ophId).toList();
    }
    return data;
  }
}

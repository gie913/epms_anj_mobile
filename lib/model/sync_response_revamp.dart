import 'package:epms/model/global.dart';
import 'package:epms/model/kerani_kirim.dart';
import 'package:epms/model/kerani_panen.dart';
import 'package:epms/model/supervisi.dart';

class SynchResponse {
  String? message;
  Global? global;
  KeraniPanen? keraniPanen;
  KeraniKirim? keraniKirim;
  Supervisi? supervisi;

  SynchResponse(
      {this.message, this.global, this.keraniPanen, this.keraniKirim, this.supervisi});

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
    supervisi = json['supervisi'] != null
        ? new Supervisi.fromJson(json['supervisi'])
        : null;
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
    if (this.supervisi != null) {
      data['supervisi'] = this.supervisi!.toJson();
    }
    return data;
  }
}

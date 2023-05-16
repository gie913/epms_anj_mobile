import 'package:epms/model/estate.dart';
import 'package:epms/model/global.dart';
import 'kerani_kirim.dart';

class LoginResponseOld {
  Estate? estate1;
  Estate? estate2;
  Estate? estate3;
  Global? global;
  KeraniKirim? keraniKirim;

  LoginResponseOld({this.estate1, this.estate2, this.estate3, this.keraniKirim});

  LoginResponseOld.fromJson(Map<String, dynamic> json) {
  estate1 = json['0'] != null ? new Estate.fromJson(json['0']) : null;
  estate2 = json['1'] != null ? new Estate.fromJson(json['1']) : null;
  estate3 = json['2'] != null ? new Estate.fromJson(json['2']) : null;
  global = json['global'] != null ? new Global.fromJson(json['global']) : null;
  keraniKirim = json['kerani_kirim'] != null ? new KeraniKirim.fromJson(json['kerani_kirim']) : null;
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (this.estate1 != null) {
  data['0'] = this.estate1!.toJson();
  }
  if (this.estate2 != null) {
  data['1'] = this.estate2!.toJson();
  }
  if (this.estate3 != null) {
  data['2'] = this.estate3!.toJson();
  }
  if (this.keraniKirim != null) {
  data['kerani_kirim'] = this.keraniKirim!.toJson();
  }
  return data;
  }
}
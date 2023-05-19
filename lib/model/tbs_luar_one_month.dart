import 'package:epms/model/supervisi_3rd_party.dart';

class TBSLuarOneMonth {
  List<Supervisi3rdParty>? supervisi3rdParty;

  TBSLuarOneMonth({this.supervisi3rdParty});

  TBSLuarOneMonth.fromJson(Map<String, dynamic> json) {
    if (json['supervisi_3rd_party'] != null) {
      supervisi3rdParty = <Supervisi3rdParty>[];
      json['supervisi_3rd_party'].forEach((v) {
        supervisi3rdParty!.add(new Supervisi3rdParty.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.supervisi3rdParty != null) {
      data['supervisi_3rd_party'] =
          this.supervisi3rdParty!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
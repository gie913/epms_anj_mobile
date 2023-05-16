import 'package:epms/model/laporan_spb_kemarin.dart';

import 'laporan_restan.dart';

class KeraniKirim {
  List<LaporanSPBKemarin>? laporanSPBKemarin;
  List<LaporanRestan>? laporanRestan;

  KeraniKirim({this.laporanRestan});

  KeraniKirim.fromJson(Map<String, dynamic> json) {
    if (json['Laporan_SPB_Kemarin'] != null) {
      laporanSPBKemarin = <LaporanSPBKemarin>[];
      json['Laporan_SPB_Kemarin'].forEach((v) {
        laporanSPBKemarin!.add(new LaporanSPBKemarin.fromJson(v));
      });
    }
    if (json['Laporan_Restan'] != null) {
      laporanRestan = <LaporanRestan>[];
      json['Laporan_Restan'].forEach((v) {
        laporanRestan!.add(new LaporanRestan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.laporanSPBKemarin != null) {
      data['Laporan_SPB_Kemarin'] =
          this.laporanSPBKemarin!.map((v) => v.toJson()).toList();
    }
    if (this.laporanRestan != null) {
      data['Laporan_Restan'] =
          this.laporanRestan!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

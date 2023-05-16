import 'package:epms/model/laporan_restan.dart';
import 'package:epms/model/t_abw_schema.dart';

import 'laporan_panen_kemarin.dart';
import 't_harvesting_plan_schema.dart';

class KeraniPanen {
  List<THarvestingPlanSchema>? tHarvestingPlanSchema;
  List<LaporanPanenKemarin>? laporanPanenKemarin;
  List<LaporanRestan>? laporanRestan;
  List<TABWSchema>? tABWSchema;

  KeraniPanen(
      {this.tHarvestingPlanSchema,
      this.laporanPanenKemarin,
      this.laporanRestan,
      this.tABWSchema});

  KeraniPanen.fromJson(Map<String, dynamic> json) {
    if (json['T_Harvesting_Plan_Schema'] != null) {
      tHarvestingPlanSchema = <THarvestingPlanSchema>[];
      json['T_Harvesting_Plan_Schema'].forEach((v) {
        tHarvestingPlanSchema!.add(new THarvestingPlanSchema.fromJson(v));
      });
    }
    if (json['Laporan_Panen_Kemarin'] != null) {
      laporanPanenKemarin = <LaporanPanenKemarin>[];
      json['Laporan_Panen_Kemarin'].forEach((v) {
        laporanPanenKemarin!.add(new LaporanPanenKemarin.fromJson(v));
      });
    }
    if (json['Laporan_Restan'] != null) {
      laporanRestan = <LaporanRestan>[];
      json['Laporan_Restan'].forEach((v) {
        laporanRestan!.add(new LaporanRestan.fromJson(v));
      });
    }
    if (json['T_ABW_Schema'] != null) {
      tABWSchema = <TABWSchema>[];
      json['T_ABW_Schema'].forEach((v) {
        tABWSchema!.add(new TABWSchema.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tHarvestingPlanSchema != null) {
      data['T_Harvesting_Plan_Schema'] =
          this.tHarvestingPlanSchema!.map((v) => v.toJson()).toList();
    }
    if (this.laporanPanenKemarin != null) {
      data['Laporan_Panen_Kemarin'] =
          this.laporanPanenKemarin!.map((v) => v.toJson()).toList();
    }
    if (this.laporanRestan != null) {
      data['Laporan_Restan'] =
          this.laporanRestan!.map((v) => v.toJson()).toList();
    }
    if (this.tABWSchema != null) {
      data['T_ABW_Schema'] = this.tABWSchema!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

import 'package:epms/model/laporan_panen_kemarin.dart';
import 'package:epms/model/t_harvesting_plan_schema.dart';
import 'package:epms/model/t_work_plan_schema.dart';

import 'laporan_restan.dart';
import 'm_ancak_employee.dart';

class Supervisi {
  List<MAncakEmployee>? mAncakEmployee;
  List<THarvestingPlanSchema>? tHarvestingPlanSchema;
  List<LaporanRestan>? laporanRestan;
  List<TWorkplanSchema>? tWorkplanSchema;
  List<LaporanPanenKemarin>? laporanPanenKemarin;

  Supervisi({this.mAncakEmployee, this.tHarvestingPlanSchema, this.laporanRestan, this.tWorkplanSchema, this.laporanPanenKemarin});

  Supervisi.fromJson(Map<String, dynamic> json) {
    if (json['M_Ancak_Employee'] != null) {
      mAncakEmployee = <MAncakEmployee>[];
      json['M_Ancak_Employee'].forEach((v) {
        mAncakEmployee!.add(new MAncakEmployee.fromJson(v));
      });
    }
    if (json['T_Harvesting_Plan_Schema'] != null) {
      tHarvestingPlanSchema = <THarvestingPlanSchema>[];
      json['T_Harvesting_Plan_Schema'].forEach((v) {
        tHarvestingPlanSchema!.add(new THarvestingPlanSchema.fromJson(v));
      });
    }
    if (json['Laporan_Restan'] != null) {
      laporanRestan = <LaporanRestan>[];
      json['Laporan_Restan'].forEach((v) {
        laporanRestan!.add(new LaporanRestan.fromJson(v));
      });
    }
    if (json['T_Workplan_Schema'] != null) {
      tWorkplanSchema = <TWorkplanSchema>[];
      json['T_Workplan_Schema'].forEach((v) {
        tWorkplanSchema!.add(new TWorkplanSchema.fromJson(v));
      });
    }
    if (json['Laporan_Panen_Kemarin'] != null) {
      laporanPanenKemarin = <LaporanPanenKemarin>[];
      json['Laporan_Panen_Kemarin'].forEach((v) {
        laporanPanenKemarin!.add(new LaporanPanenKemarin.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mAncakEmployee != null) {
      data['M_Ancak_Employee'] =
          this.mAncakEmployee!.map((v) => v.toJson()).toList();
    }
    if (this.tHarvestingPlanSchema != null) {
      data['T_Harvesting_Plan_Schema'] =
          this.tHarvestingPlanSchema!.map((v) => v.toJson()).toList();
    }
    if (this.laporanRestan != null) {
      data['Laporan_Restan'] =
          this.laporanRestan!.map((v) => v.toJson()).toList();
    }
    if (this.tWorkplanSchema != null) {
      data['T_Workplan_Schema'] =
          this.tWorkplanSchema!.map((v) => v.toJson()).toList();
    }
    if (this.laporanPanenKemarin != null) {
      data['Laporan_Panen_Kemarin'] =
          this.laporanPanenKemarin!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

import 'dart:convert';

import 'package:epms/model/laporan_panen_kemarin.dart';
import 'package:epms/model/laporan_restan.dart';
import 'package:epms/model/laporan_spb_kemarin.dart';
import 'package:epms/model/t_abw_schema.dart';
import 'package:epms/model/t_harvesting_plan_schema.dart';

KeraniModel keraniModelFromJson(String str) =>
    KeraniModel.fromJson(json.decode(str));

String keraniModelToJson(KeraniModel data) => json.encode(data.toJson());

class KeraniModel {
  List<THarvestingPlanSchema>? tHarvestingPlanSchema;
  List<LaporanPanenKemarin>? laporanPanenKemarin;
  List<LaporanRestan>? laporanRestan;
  List<TABWSchema>? tAbwSchema;
  List<LaporanSPBKemarin>? laporanSpbKemarin;

  KeraniModel({
    this.tHarvestingPlanSchema,
    this.laporanPanenKemarin,
    this.laporanRestan,
    this.tAbwSchema,
    this.laporanSpbKemarin,
  });

  factory KeraniModel.fromJson(Map<String, dynamic> json) => KeraniModel(
        tHarvestingPlanSchema: json['T_Harvesting_Plan_Schema'] != null
            ? (json['T_Harvesting_Plan_Schema'] as List)
                .map((e) => THarvestingPlanSchema.fromJson(e))
                .toList()
            : <THarvestingPlanSchema>[],
        laporanPanenKemarin: json["Laporan_Panen_Kemarin"] != null
            ? (json["Laporan_Panen_Kemarin"] as List)
                .map((e) => LaporanPanenKemarin.fromJson(e))
                .toList()
            : <LaporanPanenKemarin>[],
        laporanRestan: json["Laporan_Restan"] != null
            ? (json["Laporan_Restan"] as List)
                .map((e) => LaporanRestan.fromJson(e))
                .toList()
            : <LaporanRestan>[],
        tAbwSchema: json["T_ABW_Schema"] != null
            ? (json["T_ABW_Schema"] as List)
                .map((e) => TABWSchema.fromJson(e))
                .toList()
            : <TABWSchema>[],
        laporanSpbKemarin: json["Laporan_SPB_Kemarin"] != null
            ? (json["Laporan_SPB_Kemarin"] as List)
                .map((e) => LaporanSPBKemarin.fromJson(e))
                .toList()
            : <LaporanSPBKemarin>[],
      );

  Map<String, dynamic> toJson() => {
        "T_Harvesting_Plan_Schema": List<THarvestingPlanSchema>.from(
            tHarvestingPlanSchema!.map((e) => e.toJson())),
        "Laporan_Panen_Kemarin": List<LaporanPanenKemarin>.from(
            laporanPanenKemarin!.map((e) => e.toJson())),
        "Laporan_Restan":
            List<LaporanRestan>.from(laporanRestan!.map((e) => e.toJson())),
        "T_ABW_Schema":
            List<TABWSchema>.from(tAbwSchema!.map((e) => e.toJson())),
        "Laporan_SPB_Kemarin": List<LaporanSPBKemarin>.from(
            laporanSpbKemarin!.map((e) => e.toString())),
      };
}

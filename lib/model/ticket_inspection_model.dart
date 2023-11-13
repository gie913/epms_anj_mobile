import 'dart:convert';

import 'package:epms/model/history_inspection_model.dart';

class TicketInspectionModel {
  const TicketInspectionModel({
    this.id = '',
    this.date = '',
    this.longitude = '',
    this.latitude = '',
    this.category = '',
    this.company = '',
    this.division = '',
    this.userAssign = '',
    this.status = '',
    this.report = '',
    this.images = const [],
    this.history = const <HistoryInspectionModel>[],
  });

  factory TicketInspectionModel.fromJson(Map<String, dynamic> json) =>
      TicketInspectionModel(
        id: json['id'] ?? '',
        date: json['date'] ?? '',
        longitude: json['longitude'] ?? '',
        latitude: json['latitude'] ?? '',
        category: json['category'] ?? '',
        company: json['company'] ?? '',
        division: json['division'] ?? '',
        userAssign: json['user_assign'] ?? '',
        status: json['status'] ?? '',
        report: json['report'] ?? '',
        history: json['history'] != null
            ? List<HistoryInspectionModel>.from(
                (json['history'] as List).map((e) {
                  return HistoryInspectionModel.fromJson(e);
                }),
              )
            : <HistoryInspectionModel>[],
      );

  factory TicketInspectionModel.fromDatabase(Map<String, dynamic> json) =>
      TicketInspectionModel(
        id: json['id'] ?? '',
        date: json['date'] ?? '',
        longitude: json['longitude'] ?? '',
        latitude: json['latitude'] ?? '',
        category: json['category'] ?? '',
        company: json['company'] ?? '',
        division: json['division'] ?? '',
        userAssign: json['user_assign'] ?? '',
        status: json['status'] ?? '',
        report: json['report'] ?? '',
        images: json['images'] != null
            ? List.from(
                (jsonDecode(json['images']) as List).map((e) => e),
              )
            : [],
        history: json['history'] != null
            ? List<HistoryInspectionModel>.from(
                (jsonDecode(json['history']) as List).map((e) {
                  return HistoryInspectionModel.fromJson(e);
                }),
              )
            : <HistoryInspectionModel>[],
      );

  final String id;
  final String date;
  final String longitude;
  final String latitude;
  final String category;
  final String company;
  final String division;
  final String userAssign;
  final String status;
  final String report;
  final List images;
  final List<HistoryInspectionModel> history;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['date'] = date;
    tempData['longitude'] = longitude;
    tempData['latitude'] = latitude;
    tempData['category'] = category;
    tempData['company'] = company;
    tempData['division'] = division;
    tempData['user_assign'] = userAssign;
    tempData['status'] = status;
    tempData['report'] = report;
    tempData['images'] = List.from(images.map((e) => e));
    tempData['history'] = List.from(history.map((e) => e.toJson()));

    return tempData;
  }

  Map<String, dynamic> toDatabase() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['date'] = date;
    tempData['longitude'] = longitude;
    tempData['latitude'] = latitude;
    tempData['category'] = category;
    tempData['company'] = company;
    tempData['division'] = division;
    tempData['user_assign'] = userAssign;
    tempData['status'] = status;
    tempData['report'] = report;
    tempData['images'] = jsonEncode(List.from(images.map((e) => e)));
    tempData['history'] = jsonEncode(List.from(history.map((e) => e.toJson())));

    return tempData;
  }

  @override
  String toString() {
    return 'TicketInspectionModel(id: $id, date: $date, longitude: $longitude, latitude: $latitude, category: $category, company: $company, division: $division, user_assign: $userAssign, status: $status, report: $report, images: ${images.length} item, history: $history)';
  }
}

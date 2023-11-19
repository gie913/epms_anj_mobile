import 'dart:convert';

import 'package:epms/model/history_inspection_model.dart';

class TicketInspectionModel {
  const TicketInspectionModel({
    this.id = '',
    this.date = '',
    this.longitude = 0,
    this.latitude = 0,
    this.category = '',
    this.company = '',
    this.division = '',
    this.userAssign = '',
    this.status = '',
    this.description = '',
    this.assignedTo = '',
    this.mTeamId = '',
    this.mCompanyId = '',
    this.mDivisionId = '',
    this.images = const [],
    this.history = const <HistoryInspectionModel>[],
  });

  factory TicketInspectionModel.fromJson(Map<String, dynamic> json) =>
      TicketInspectionModel(
        id: json['id'] ?? '',
        date: json['date'] ?? '',
        longitude: json['longitude'] ?? 0,
        latitude: json['latitude'] ?? 0,
        category: json['category'] ?? '',
        company: json['company'] ?? '',
        division: json['division'] ?? '',
        userAssign: json['user_assign'] ?? '',
        status: json['status'] ?? '',
        description: json['description'] ?? '',
        assignedTo: json['assigned_to'] ?? '',
        mTeamId: json['m_team_id'] ?? '',
        mCompanyId: json['m_company_id'] ?? '',
        mDivisionId: json['m_division_id'] ?? '',
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
        longitude: json['longitude'] ?? 0,
        latitude: json['latitude'] ?? 0,
        category: json['category'] ?? '',
        company: json['company'] ?? '',
        division: json['division'] ?? '',
        userAssign: json['user_assign'] ?? '',
        status: json['status'] ?? '',
        description: json['description'] ?? '',
        assignedTo: json['assigned_to'] ?? '',
        mTeamId: json['m_team_id'] ?? '',
        mCompanyId: json['m_company_id'] ?? '',
        mDivisionId: json['m_division_id'] ?? '',
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
  final double longitude;
  final double latitude;
  final String category;
  final String company;
  final String division;
  final String userAssign;
  final String status;
  final String description;
  final String assignedTo;
  final String mTeamId;
  final String mCompanyId;
  final String mDivisionId;
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
    tempData['description'] = description;
    tempData['assigned_to'] = assignedTo;
    tempData['m_team_id'] = mTeamId;
    tempData['m_company_id'] = mCompanyId;
    tempData['m_division_id'] = mDivisionId;
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
    tempData['description'] = description;
    tempData['assigned_to'] = assignedTo;
    tempData['m_team_id'] = mTeamId;
    tempData['m_company_id'] = mCompanyId;
    tempData['m_division_id'] = mDivisionId;
    tempData['images'] = jsonEncode(List.from(images.map((e) => e)));
    tempData['history'] = jsonEncode(List.from(history.map((e) => e.toJson())));

    return tempData;
  }

  @override
  String toString() {
    return 'TicketInspectionModel(id: $id, date: $date, longitude: $longitude, latitude: $latitude, category: $category, company: $company, division: $division, user_assign: $userAssign, status: $status, description: $description, assigned_to: $assignedTo, m_team_id: $mTeamId, m_company_id: $mCompanyId, m_division_id: $mDivisionId, images: ${images.length} item, history: $history)';
  }
}

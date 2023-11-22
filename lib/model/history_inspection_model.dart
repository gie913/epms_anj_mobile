import 'package:epms/database/helper/convert_helper.dart';

class HistoryInspectionModel {
  const HistoryInspectionModel({
    this.id = '',
    this.code = '',
    this.trTime = '',
    this.submittedAt = '',
    this.submittedBy = '',
    this.submittedByName = '',
    this.reassignedTo = '',
    this.reassignedToName = '',
    this.consultedWith = '',
    this.consultedWithName = '',
    this.description = '',
    this.gpsLat = 0,
    this.gpsLng = 0,
    this.status = '',
    this.attachments = const [],
  });

  factory HistoryInspectionModel.fromJson(Map<String, dynamic> json) =>
      HistoryInspectionModel(
        id: json['id'] ?? '',
        code: json['code'] ?? '',
        trTime: json['tr_time'] ?? '',
        submittedAt: json['submitted_at'] ?? '',
        submittedBy: json['submitted_by'] ?? '',
        submittedByName: json['submitted_by_name'] ?? '',
        reassignedTo: json['reassigned_to'] ?? '',
        reassignedToName: json['reassigned_to_name'] ?? '',
        consultedWith: json['consulted_with'] ?? '',
        consultedWithName: json['consulted_with_name'] ?? '',
        description: json['description'] ?? '',
        gpsLat: ConvertHelper.stringToDouble(json['gps_lat'] ?? ''),
        gpsLng: ConvertHelper.stringToDouble(json['gps_lng'] ?? ''),
        status: json['status'] ?? '',
        attachments: json['attachments'] != null
            ? List.from((json['attachments'] as List).map((e) => e))
            : const [],
      );

  final String id;
  final String code;
  final String trTime;
  final String submittedAt;
  final String submittedBy;
  final String submittedByName;
  final String reassignedTo;
  final String reassignedToName;
  final String consultedWith;
  final String consultedWithName;
  final String description;
  final double gpsLng;
  final double gpsLat;
  final String status;
  final List attachments;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['code'] = code;
    tempData['tr_time'] = trTime;
    tempData['submitted_at'] = submittedAt;
    tempData['submitted_by'] = submittedBy;
    tempData['submitted_by_name'] = submittedByName;
    tempData['reassigned_to'] = reassignedTo;
    tempData['reassigned_to_name'] = reassignedToName;
    tempData['consulted_with'] = consultedWith;
    tempData['consulted_with_name'] = consultedWithName;
    tempData['description'] = description;
    tempData['gps_lat'] = gpsLat.toString();
    tempData['gps_lng'] = gpsLng.toString();
    tempData['status'] = status;
    tempData['attachments'] = List.from(attachments.map((e) => e));

    return tempData;
  }

  @override
  String toString() {
    return 'HistoryInspectionModel(id: $id, code: $code, tr_time: $trTime, submitted_at: $submittedAt, submitted_by: $submittedBy, submitted_by_name: $submittedByName, reassigned_to: $reassignedTo, reassigned_to_name: $reassignedToName, consulted_with: $consultedWith, consulted_with_name: $consultedWithName, description: $description, gps_lat: $gpsLat, gps_lng: $gpsLng, status: $status, attachments: $attachments)';
  }
}

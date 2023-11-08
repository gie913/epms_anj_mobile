import 'package:epms/model/synch_inspection_data.dart';

class SynchInspectionResponse {
  const SynchInspectionResponse({
    this.success = false,
    this.message = '',
    this.data = const SynchInspectionData(),
  });

  factory SynchInspectionResponse.fromJson(Map<String, dynamic> json) =>
      SynchInspectionResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] != null
            ? SynchInspectionData.fromJson(json['data'])
            : const SynchInspectionData(),
      );

  final bool success;
  final String message;
  final SynchInspectionData data;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['success'] = success;
    tempData['message'] = message;
    tempData['data'] = data.toJson();

    return tempData;
  }

  @override
  String toString() {
    return 'SynchInspectionResponse(success: $success, message: $message, data: $data)';
  }
}

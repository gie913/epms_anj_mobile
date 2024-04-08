import 'package:epms/model/ticket_inspection_data_model.dart';

class TicketInspectionResponse {
  const TicketInspectionResponse({
    this.success = false,
    this.message = '',
    this.data = const TicketInspectionDataModel(),
  });

  factory TicketInspectionResponse.fromJson(Map<String, dynamic> json) =>
      TicketInspectionResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] != null
            ? TicketInspectionDataModel.fromJson(json['data'])
            : TicketInspectionDataModel(),
      );

  final bool success;
  final String message;
  final TicketInspectionDataModel data;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['success'] = success;
    tempData['message'] = message;
    tempData['data'] = data.toJson();

    return tempData;
  }

  @override
  String toString() {
    return 'TicketInspectionResponse(success: $success, message: $message, data: $data)';
  }
}

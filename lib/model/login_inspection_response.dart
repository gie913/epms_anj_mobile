import 'package:epms/model/login_inspection_data.dart';

class LoginInspectionResponse {
  const LoginInspectionResponse({
    this.success = false,
    this.message = '',
    this.data = const LoginInspectionData(),
  });

  factory LoginInspectionResponse.fromJson(Map<String, dynamic> json) =>
      LoginInspectionResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] != null
            ? LoginInspectionData.fromJson(json['data'])
            : const LoginInspectionData(),
      );

  final bool success;
  final String message;
  final LoginInspectionData data;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['success'] = success;
    tempData['message'] = message;
    tempData['data'] = data.toJson();

    return tempData;
  }

  @override
  String toString() {
    return 'LoginInspectionResponse(success: $success, message: $message, data: $data)';
  }
}

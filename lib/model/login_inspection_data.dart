import 'package:epms/model/inspection_access_model.dart';
import 'package:epms/model/user_inspection_config_model.dart';

class LoginInspectionData {
  const LoginInspectionData({
    this.token = '',
    this.tokenExpiredAt = '',
    this.user = const UserInspectionConfigModel(),
    this.access = const [],
  });

  factory LoginInspectionData.fromJson(Map<String, dynamic> json) =>
      LoginInspectionData(
        token: json['token'] ?? '',
        tokenExpiredAt: json['token_expired_at'] ?? '',
        user: json['user'] != null
            ? UserInspectionConfigModel.fromJson(json['user'])
            : const UserInspectionConfigModel(),
        access: json['access'] != null
            ? List<InspectionAccessModel>.from(
                (json['access'] as List).map((e) {
                  return InspectionAccessModel.fromJson(e);
                }),
              )
            : <InspectionAccessModel>[],
      );

  final String token;
  final String tokenExpiredAt;
  final UserInspectionConfigModel user;
  final List<InspectionAccessModel> access;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['token'] = token;
    tempData['token_expired_at'] = tokenExpiredAt;
    tempData['user'] = user.toJson();
    tempData['access'] = List.from(access.map((e) => e.toJson()));

    return tempData;
  }

  @override
  String toString() {
    return 'LoginInspectionData(success: $token, token_expired_at: $tokenExpiredAt, user: $user, access: $access)';
  }
}

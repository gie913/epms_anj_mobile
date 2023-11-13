class HistoryInspectionModel {
  const HistoryInspectionModel({
    this.user = '',
    this.date = '',
    this.response = '',
    this.status = '',
    this.userReAssign = '',
    this.userConsultation = '',
  });

  factory HistoryInspectionModel.fromJson(Map<String, dynamic> json) =>
      HistoryInspectionModel(
        user: json['user'] ?? '',
        date: json['date'] ?? '',
        response: json['response'] ?? '',
        status: json['status'] ?? '',
        userReAssign: json['user_re_assign'] ?? '',
        userConsultation: json['user_consultation'] ?? '',
      );

  final String user;
  final String date;
  final String response;
  final String status;
  final String userReAssign;
  final String userConsultation;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['user'] = user;
    tempData['date'] = date;
    tempData['response'] = response;
    tempData['status'] = status;
    tempData['user_re_assign'] = userReAssign;
    tempData['user_consultation'] = userConsultation;

    return tempData;
  }

  @override
  String toString() {
    return 'HistoryInspectionModel(user: $user, date: $date, response: $response, status: $status, user_re_assign: $userReAssign, user_consultation: $userConsultation)';
  }
}

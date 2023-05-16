class LaporanPanenKemarin {
  String? employeeCode;
  String? employeeName;
  int? bunchesRipe;
  int? bunchesOverripe;
  int? bunchesHalfripe;
  int? bunchesUnripe;
  int? bunchesAbnormal;
  int? bunchesEmpty;
  int? looseFruits;
  int? bunchesTotal;
  int? bunchesNotSent;
  String? createdDate;

  LaporanPanenKemarin(
      {this.employeeCode,
        this.employeeName,
        this.bunchesRipe,
        this.bunchesOverripe,
        this.bunchesHalfripe,
        this.bunchesUnripe,
        this.bunchesAbnormal,
        this.bunchesEmpty,
        this.looseFruits,
        this.bunchesTotal,
        this.bunchesNotSent,
        this.createdDate});

  LaporanPanenKemarin.fromJson(Map<String, dynamic> json) {
    employeeCode = json['employee_code'];
    employeeName = json['employee_name'];
    bunchesRipe = json['bunches_ripe'];
    bunchesOverripe = json['bunches_overripe'];
    bunchesHalfripe = json['bunches_halfripe'];
    bunchesUnripe = json['bunches_unripe'];
    bunchesAbnormal = json['bunches_abnormal'];
    bunchesEmpty = json['bunches_empty'];
    looseFruits = json['loose_fruits'];
    bunchesTotal = json['bunches_total'];
    bunchesNotSent = json['bunches_not_sent'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_code'] = this.employeeCode;
    data['employee_name'] = this.employeeName;
    data['bunches_ripe'] = this.bunchesRipe;
    data['bunches_overripe'] = this.bunchesOverripe;
    data['bunches_halfripe'] = this.bunchesHalfripe;
    data['bunches_unripe'] = this.bunchesUnripe;
    data['bunches_abnormal'] = this.bunchesAbnormal;
    data['bunches_empty'] = this.bunchesEmpty;
    data['loose_fruits'] = this.looseFruits;
    data['bunches_total'] = this.bunchesTotal;
    data['bunches_not_sent'] = this.bunchesNotSent;
    data['created_date'] = this.createdDate;
    return data;
  }
}
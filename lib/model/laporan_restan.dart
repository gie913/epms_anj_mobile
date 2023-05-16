class LaporanRestan {
  String? ophId;
  String? ophCardId;
  dynamic ophHarvestingType;
  dynamic ophHarvestingMethod;
  String? ophEstateCode;
  String? ophDivisionCode;
  String? ophBlockCode;
  String? ophTphCode;
  String? mandorEmployeeCode;
  String? mandorEmployeeName;
  String? employeeCode;
  String? employeeName;
  String? keraniPanenEmployeeCode;
  String? keraniPanenEmployeeName;
  dynamic isRestantPermanent;
  String? ophPickupDate;
  String? createdDate;
  String? createdTime;
  String? ophPickupTime;
  dynamic bunchesRipe;
  dynamic bunchesOverripe;
  dynamic bunchesHalfripe;
  dynamic bunchesUnripe;
  dynamic bunchesAbnormal;
  dynamic bunchesEmpty;
  dynamic looseFruits;
  dynamic bunchesTotal;
  dynamic bunchesNotSent;
  dynamic ophEstimateTonnage;
  String? ophNotes;
  String? ophCustomerCode;
  dynamic isPlanned;

  LaporanRestan(
      {this.ophId,
      this.ophCardId,
      this.ophHarvestingType,
      this.ophHarvestingMethod,
      this.ophEstateCode,
      this.ophDivisionCode,
      this.ophBlockCode,
      this.ophTphCode,
      this.mandorEmployeeCode,
      this.mandorEmployeeName,
      this.employeeCode,
      this.employeeName,
      this.keraniPanenEmployeeCode,
      this.keraniPanenEmployeeName,
      this.isRestantPermanent,
      this.ophPickupDate,
      this.createdDate,
      this.createdTime,
      this.ophPickupTime,
      this.bunchesRipe,
      this.bunchesOverripe,
      this.bunchesHalfripe,
      this.bunchesUnripe,
      this.bunchesAbnormal,
      this.bunchesEmpty,
      this.looseFruits,
      this.bunchesTotal,
      this.bunchesNotSent,
      this.ophEstimateTonnage,
      this.ophNotes,
      this.ophCustomerCode,
      this.isPlanned});

  LaporanRestan.fromJson(Map<String, dynamic> json) {
    ophId = json['oph_id'];
    ophCardId = json['oph_card_id'];
    ophHarvestingType = json['oph_harvesting_type'];
    ophHarvestingMethod = json['oph_harvesting_method'];
    ophEstateCode = json['oph_estate_code'];
    ophDivisionCode = json['oph_division_code'];
    ophBlockCode = json['oph_block_code'];
    ophTphCode = json['oph_tph_code'];
    mandorEmployeeCode = json['mandor_employee_code'];
    mandorEmployeeName = json['mandor_employee_name'];
    employeeCode = json['employee_code'];
    employeeName = json['employee_name'];
    keraniPanenEmployeeCode = json['kerani_panen_employee_code'];
    keraniPanenEmployeeName = json['kerani_panen_employee_name'];
    isRestantPermanent = json['is_restant_permanent'];
    ophPickupDate = json['oph_pickup_date'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    ophPickupTime = json['oph_pickup_time'];
    bunchesRipe = json['bunches_ripe'];
    bunchesOverripe = json['bunches_overripe'];
    bunchesHalfripe = json['bunches_halfripe'];
    bunchesUnripe = json['bunches_unripe'];
    bunchesAbnormal = json['bunches_abnormal'];
    bunchesEmpty = json['bunches_empty'];
    looseFruits = json['loose_fruits'];
    bunchesTotal = json['bunches_total'];
    bunchesNotSent = json['bunches_not_sent'];
    ophEstimateTonnage = json['oph_estimate_tonnage'];
    ophNotes = json['oph_notes'];
    ophCustomerCode = json['oph_customer_code'];
    isPlanned = json['is_planned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oph_id'] = this.ophId;
    data['oph_card_id'] = this.ophCardId;
    data['oph_harvesting_type'] = this.ophHarvestingType;
    data['oph_harvesting_method'] = this.ophHarvestingMethod;
    data['oph_estate_code'] = this.ophEstateCode;
    data['oph_division_code'] = this.ophDivisionCode;
    data['oph_block_code'] = this.ophBlockCode;
    data['oph_tph_code'] = this.ophTphCode;
    data['mandor_employee_code'] = this.mandorEmployeeCode;
    data['mandor_employee_name'] = this.mandorEmployeeName;
    data['employee_code'] = this.employeeCode;
    data['employee_name'] = this.employeeName;
    data['kerani_panen_employee_code'] = this.keraniPanenEmployeeCode;
    data['kerani_panen_employee_name'] = this.keraniPanenEmployeeName;
    data['is_restant_permanent'] = this.isRestantPermanent;
    data['oph_pickup_date'] = this.ophPickupDate;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['oph_pickup_time'] = this.ophPickupTime;
    data['bunches_ripe'] = this.bunchesRipe;
    data['bunches_overripe'] = this.bunchesOverripe;
    data['bunches_halfripe'] = this.bunchesHalfripe;
    data['bunches_unripe'] = this.bunchesUnripe;
    data['bunches_abnormal'] = this.bunchesAbnormal;
    data['bunches_empty'] = this.bunchesEmpty;
    data['loose_fruits'] = this.looseFruits;
    data['bunches_total'] = this.bunchesTotal;
    data['bunches_not_sent'] = this.bunchesNotSent;
    data['oph_estimate_tonnage'] = this.ophEstimateTonnage;
    data['oph_notes'] = this.ophNotes;
    data['oph_customer_code'] = this.ophCustomerCode;
    data['is_planned'] = this.isPlanned;
    return data;
  }
}

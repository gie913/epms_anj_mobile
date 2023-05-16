
class OPHNew {
  String? ophId;
  String? ophCardId;
  int? ophHarvestingMethod;
  int? ophHarvestingType;
  String? ophEstateCode;
  String? ophPlantCode;
  String? ophDivisionCode;
  String? ophBlockCode;
  String? ophTphCode;
  String? ophNotes;
  String? ophLat;
  String? ophLong;
  String? ophPhoto;
  String? mandor1EmployeeCode;
  String? mandor1EmployeeName;
  String? keraniKirimEmployeeCode;
  String? keraniKirimEmployeeName;
  String? mandorEmployeeCode;
  String? mandorEmployeeName;
  String? keraniPanenEmployeeCode;
  String? keraniPanenEmployeeName;
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
  double? ophEstimateTonnage;
  int? isPlanned;
  int? isApproved;
  int? isRestantPermanent;
  String? ophApprovedBy;
  String? ophApprovedByName;
  String? ophApprovedDate;
  String? ophApprovedTime;
  String? ophCustomerCode;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;
  String? ophPickupDate;
  String? ophPickupTime;
  int? ophIsClosed;

  OPHNew(
      {this.ophId,
        this.ophCardId,
        this.ophHarvestingMethod,
        this.ophHarvestingType,
        this.ophEstateCode,
        this.ophPlantCode,
        this.ophDivisionCode,
        this.ophBlockCode,
        this.ophTphCode,
        this.ophNotes,
        this.ophLat,
        this.ophLong,
        this.ophPhoto,
        this.mandor1EmployeeCode,
        this.mandor1EmployeeName,
        this.keraniKirimEmployeeCode,
        this.keraniKirimEmployeeName,
        this.mandorEmployeeCode,
        this.mandorEmployeeName,
        this.keraniPanenEmployeeCode,
        this.keraniPanenEmployeeName,
        this.employeeCode,
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
        this.ophEstimateTonnage,
        this.isPlanned,
        this.isApproved,
        this.isRestantPermanent,
        this.ophApprovedBy,
        this.ophApprovedByName,
        this.ophApprovedDate,
        this.ophApprovedTime,
        this.ophCustomerCode,
        this.createdBy,
        this.createdDate,
        this.createdTime,
        this.updatedBy,
        this.updatedDate,
        this.updatedTime,
        this.ophPickupDate,
        this.ophPickupTime,
        this.ophIsClosed});

  OPHNew.fromJson(Map<String, dynamic> json) {
    ophId = json['oph_id'];
    ophCardId = json['oph_card_id'];
    ophHarvestingMethod = json['oph_harvesting_method'];
    ophHarvestingType = json['oph_harvesting_type'];
    ophEstateCode = json['oph_estate_code'];
    ophPlantCode = json['oph_plant_code'];
    ophDivisionCode = json['oph_division_code'];
    ophBlockCode = json['oph_block_code'];
    ophTphCode = json['oph_tph_code'];
    ophNotes = json['oph_notes'];
    ophLat = json['oph_lat'];
    ophLong = json['oph_long'];
    ophPhoto = json['oph_photo'];

    // Mandor yang dipilih saat login

    mandor1EmployeeCode = json['mandor1_employee_code'];
    mandor1EmployeeName = json['mandor1_employee_name'];
    keraniKirimEmployeeCode = json['kerani_kirim_employee_code'];
    keraniKirimEmployeeName = json['kerani_kirim_employee_name'];
    mandorEmployeeCode = json['mandor_employee_code'];
    mandorEmployeeName = json['mandor_employee_name'];
    keraniPanenEmployeeCode = json['kerani_panen_employee_code'];
    keraniPanenEmployeeName = json['kerani_panen_employee_name'];

    // Kurang ini
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
    ophEstimateTonnage = json['oph_estimate_tonnage'];
    isPlanned = json['is_planned']; //Backend
    isApproved = json['is_approved']; //Backend
    isRestantPermanent = json['is_restant_permanent']; //Backend
    ophApprovedBy = json['oph_approved_by']; //Backend
    ophApprovedByName = json['oph_approved_by_name']; //Backend
    ophApprovedDate = json['oph_approved_date']; //Backend
    ophApprovedTime = json['oph_approved_time']; //Backend
    ophCustomerCode = json['oph_customer_code']; //Backend
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
    ophPickupDate = json['oph_pickup_date'];
    ophPickupTime = json['oph_pickup_time'];
    ophIsClosed = json['oph_is_closed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oph_id'] = this.ophId;
    data['oph_card_id'] = this.ophCardId;
    data['oph_harvesting_method'] = this.ophHarvestingMethod;
    data['oph_harvesting_type'] = this.ophHarvestingType;
    data['oph_estate_code'] = this.ophEstateCode;
    data['oph_plant_code'] = this.ophPlantCode;
    data['oph_division_code'] = this.ophDivisionCode;
    data['oph_block_code'] = this.ophBlockCode;
    data['oph_tph_code'] = this.ophTphCode;
    data['oph_notes'] = this.ophNotes;
    data['oph_lat'] = this.ophLat;
    data['oph_long'] = this.ophLong;
    data['oph_photo'] = this.ophPhoto;
    data['mandor1_employee_code'] = this.mandor1EmployeeCode;
    data['mandor1_employee_name'] = this.mandor1EmployeeName;
    data['kerani_kirim_employee_code'] = this.keraniKirimEmployeeCode;
    data['kerani_kirim_employee_name'] = this.keraniKirimEmployeeName;
    data['mandor_employee_code'] = this.mandorEmployeeCode;
    data['mandor_employee_name'] = this.mandorEmployeeName;
    data['kerani_panen_employee_code'] = this.keraniPanenEmployeeCode;
    data['kerani_panen_employee_name'] = this.keraniPanenEmployeeName;
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
    data['oph_estimate_tonnage'] = this.ophEstimateTonnage;
    data['is_planned'] = this.isPlanned;
    data['is_approved'] = this.isApproved;
    data['is_restant_permanent'] = this.isRestantPermanent;
    data['oph_approved_by'] = this.ophApprovedBy;
    data['oph_approved_by_name'] = this.ophApprovedByName;
    data['oph_approved_date'] = this.ophApprovedDate;
    data['oph_approved_time'] = this.ophApprovedTime;
    data['oph_customer_code'] = this.ophCustomerCode;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    data['oph_pickup_date'] = this.ophPickupDate;
    data['oph_pickup_time'] = this.ophPickupTime;
    data['oph_is_closed'] = this.ophIsClosed;
    return data;
  }
}

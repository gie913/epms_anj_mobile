class TBSLuar {
  String? sortasiID;
  String? supervisiName;
  dynamic gpsLat;
  dynamic gpsLong;
  dynamic quantity;
  dynamic formType;
  String? contractNumber;
  String? supplierCode;
  String? supplierName;
  String? driverName;
  String? licenseNumber;
  String? spdID;
  dynamic bunchesUnripe;
  dynamic bunchesLess4Kg;
  dynamic brondolanRotten;
  dynamic bunchesCengkeh;
  dynamic bunchesHalfripe;
  dynamic bunchesOverripe;
  dynamic bunchesRotten;
  dynamic bunchesAbnormal;
  dynamic bunchesEmpty;
  dynamic rubbish;
  dynamic water;
  dynamic longStalk;
  dynamic bunchesTotal;
  dynamic deduction;
  dynamic small;
  dynamic medium;
  dynamic large;
  String? gradingPhoto;
  String? notes;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;

  TBSLuar(
      {this.sortasiID,
        this.supervisiName,
        this.gpsLat,
        this.gpsLong,
        this.quantity,
        this.formType,
        this.contractNumber,
        this.supplierCode,
        this.supplierName,
        this.driverName,
        this.licenseNumber,
        this.spdID,
        this.bunchesUnripe,
        this.bunchesLess4Kg,
        this.brondolanRotten,
        this.bunchesCengkeh,
        this.bunchesHalfripe,
        this.bunchesOverripe,
        this.bunchesRotten,
        this.bunchesAbnormal,
        this.bunchesEmpty,
        this.rubbish,
        this.water,
        this.longStalk,
        this.bunchesTotal,
        this.deduction,
        this.small,
        this.medium,
        this.large,
        this.notes,
        this.gradingPhoto,
        this.createdBy,
        this.createdDate,
        this.createdTime,
        this.updatedBy,
        this.updatedDate,
        this.updatedTime});

  TBSLuar.fromJson(Map<String, dynamic> json) {
    sortasiID = json['sortasi_id'];
    supervisiName = json['supervisi_name'];
    gpsLat = json['gps_lat'];
    gpsLong = json['gps_long'];
    quantity = json['quantity'];
    formType = json['form_type'];
    contractNumber = json['contract_number'];
    supplierCode = json['supplier_code'];
    supplierName = json['supplier_name'];
    driverName = json['driver_name'];
    licenseNumber = json['license_number'];
    spdID = json['spb_id'];
    bunchesUnripe = json['bunches_unripe'];
    bunchesLess4Kg = json['bunches_less_4_kg'];
    bunchesCengkeh = json['bunches_cengkeh'];
    brondolanRotten = json['brondolan_rotten'];
    bunchesHalfripe = json['bunches_halfripe'];
    bunchesOverripe = json['bunches_overripe'];
    bunchesRotten = json['bunches_rotten'];
    bunchesAbnormal = json['bunches_abnormal'];
    bunchesEmpty = json['bunches_empty'];
    rubbish = json['rubbish'];
    water = json['water'];
    longStalk = json['long_stalk'];
    bunchesTotal = json['bunches_total'];
    deduction = json['deduction'];
    small = json['small'];
    medium = json['medium'];
    large = json['large'];
    notes = json['notes'];
    gradingPhoto = json['grading_photo'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sortasi_id'] = this.sortasiID;
    data['supervisi_name'] = this.supervisiName;
    data['gps_lat'] = this.gpsLat;
    data['gps_long'] = this.gpsLong;
    data['quantity'] = this.quantity;
    data['contract_number'] = this.contractNumber;
    data['supplier_code'] = this.supplierCode;
    data['supplier_name'] = this.supplierName;
    data['driver_name'] = this.driverName;
    data['license_number'] = this.licenseNumber;
    data['spb_id'] = this.spdID;
    data['bunches_unripe'] = this.bunchesUnripe;
    data['form_type'] = this.formType;
    data['bunches_less_4_kg'] =  this.bunchesLess4Kg;
    data['bunches_cengkeh'] = this.bunchesCengkeh;
    data['brondolan_rotten'] = this.brondolanRotten;
    data['bunches_halfripe'] = this.bunchesHalfripe;
    data['bunches_overripe'] = this.bunchesOverripe;
    data['bunches_rotten'] = this.bunchesRotten;
    data['bunches_abnormal'] = this.bunchesAbnormal;
    data['bunches_empty'] = this.bunchesEmpty;
    data['rubbish'] = this.rubbish;
    data['water'] = this.water;
    data['long_stalk'] = this.longStalk;
    data['bunches_total'] = this.bunchesTotal;
    data['deduction'] = this.deduction;
    data['small'] = this.small;
    data['medium'] = this.medium;
    data['large'] = this.large;
    data['notes'] = this.notes;
    data['grading_photo'] = this.gradingPhoto;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    return data;
  }
}
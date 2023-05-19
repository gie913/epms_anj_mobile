class SPBSupervise {
  String? spbSuperviseId;
  String? spbId;
  String? supervisiSpbEmployeeCode;
  String? supervisiSpbEmployeeName;
  String? supervisiEstateCode;
  String? supervisiSpbLat;
  String? supervisiSpbLong;
  String? supervisiSpbDriverEmployeeCode;
  String? supervisiSpbDriverEmployeeName;
  String? supervisiSpbDivisionCode;
  String? supervisiSpbLicenseNumber;
  int? supervisiSpbType;
  int? supervisiSpbMethod;
  String? supervisiSpbPhoto;
  int? bunchesRipe;
  int? bunchesOverripe;
  int? bunchesHalfripe;
  int? bunchesUnripe;
  int? bunchesAbnormal;
  int? bunchesEmpty;
  int? looseFruits;
  int? bunchesTotal;
  int? bunchesTotalNormal;
  int? bunchesTangkaiPanjang;
  int? bunchesSampah;
  int? bunchesBatu;
  String? catatanBunchesTangkaiPanjang;
  String? supervisiNotes;
  String? createdBy;
  String? supervisiSpbDate;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;

  SPBSupervise(
      {this.spbSuperviseId,
        this.spbId,
      this.supervisiSpbEmployeeCode,
      this.supervisiSpbEmployeeName,
        this.supervisiEstateCode,
      this.supervisiSpbLat,
      this.supervisiSpbLong,
      this.supervisiSpbDriverEmployeeCode,
      this.supervisiSpbDriverEmployeeName,
      this.supervisiSpbDivisionCode,
      this.supervisiSpbLicenseNumber,
      this.supervisiSpbType,
      this.supervisiSpbMethod,
      this.supervisiSpbPhoto,
      this.bunchesRipe,
      this.bunchesOverripe,
      this.bunchesHalfripe,
      this.bunchesUnripe,
      this.bunchesAbnormal,
      this.bunchesEmpty,
      this.looseFruits,
      this.bunchesTotal,
      this.bunchesTotalNormal,
        this.bunchesTangkaiPanjang,
      this.bunchesSampah,
      this.bunchesBatu,
      this.catatanBunchesTangkaiPanjang,
      this.supervisiNotes,
      this.createdBy,
      this.supervisiSpbDate,
      this.createdDate,
      this.createdTime,
      this.updatedBy,
      this.updatedDate,
      this.updatedTime});

  SPBSupervise.fromJson(Map<String, dynamic> json) {
    spbSuperviseId = json['spb_supervisi_id'];
    spbId = json['spb_id'];
    supervisiSpbEmployeeCode = json['supervisi_spb_employee_code'];
    supervisiSpbEmployeeName = json['supervisi_spb_employee_name'];
    supervisiEstateCode = json['supervisi_spb_estate_code'];
    supervisiSpbLat = json['supervisi_spb_lat'];
    supervisiSpbLong = json['supervisi_spb_long'];
    supervisiSpbDriverEmployeeCode = json['supervisi_spb_driver_employee_code'];
    supervisiSpbDriverEmployeeName = json['supervisi_spb_driver_employee_name'];
    supervisiSpbDivisionCode = json['supervisi_spb_division_code'];
    supervisiSpbLicenseNumber = json['supervisi_spb_license_number'];
    supervisiSpbType = json['supervisi_spb_type'];
    supervisiSpbMethod = json['supervisi_spb_method'];
    supervisiSpbPhoto = json['supervisi_spb_photo'];
    bunchesRipe = json['bunches_ripe'];
    bunchesOverripe = json['bunches_overripe'];
    bunchesHalfripe = json['bunches_halfripe'];
    bunchesUnripe = json['bunches_unripe'];
    bunchesAbnormal = json['bunches_abnormal'];
    bunchesEmpty = json['bunches_empty'];
    looseFruits = json['loose_fruits'];
    bunchesTotal = json['bunches_total'];
    bunchesTotalNormal = json['bunches_total_normal'];
    bunchesTangkaiPanjang = json['bunches_tangkai_panjang'];
    bunchesSampah = json['bunches_sampah'];
    bunchesBatu = json['bunches_batu'];
    catatanBunchesTangkaiPanjang = json['catatan_bunches_tangkai_panjang'];
    supervisiNotes = json['supervisi_notes'];
    createdBy = json['created_by'];
    supervisiSpbDate = json['supervisi_spb_date'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spb_supervisi_id'] = this.spbSuperviseId;
    data['spb_id'] = this.spbId;
    data['supervisi_spb_employee_code'] = this.supervisiSpbEmployeeCode;
    data['supervisi_spb_employee_name'] = this.supervisiSpbEmployeeName;
    data['supervisi_spb_estate_code'] = this.supervisiEstateCode;
    data['supervisi_spb_lat'] = this.supervisiSpbLat;
    data['supervisi_spb_long'] = this.supervisiSpbLong;
    data['supervisi_spb_driver_employee_code'] =
        this.supervisiSpbDriverEmployeeCode;
    data['supervisi_spb_driver_employee_name'] =
        this.supervisiSpbDriverEmployeeName;
    data['supervisi_spb_division_code'] = this.supervisiSpbDivisionCode;
    data['supervisi_spb_license_number'] = this.supervisiSpbLicenseNumber;
    data['supervisi_spb_type'] = this.supervisiSpbType;
    data['supervisi_spb_method'] = this.supervisiSpbMethod;
    data['supervisi_spb_photo'] = this.supervisiSpbPhoto;
    data['bunches_ripe'] = this.bunchesRipe;
    data['bunches_overripe'] = this.bunchesOverripe;
    data['bunches_halfripe'] = this.bunchesHalfripe;
    data['bunches_unripe'] = this.bunchesUnripe;
    data['bunches_abnormal'] = this.bunchesAbnormal;
    data['bunches_empty'] = this.bunchesEmpty;
    data['loose_fruits'] = this.looseFruits;
    data['bunches_total'] = this.bunchesTotal;
    data['bunches_total_normal'] = this.bunchesTotalNormal;
    data['bunches_tangkai_panjang'] = this.bunchesTangkaiPanjang;
    data['bunches_sampah'] = this.bunchesSampah;
    data['bunches_batu'] = this.bunchesBatu;
    data['catatan_bunches_tangkai_panjang'] = this.catatanBunchesTangkaiPanjang;
    data['supervisi_notes'] = this.supervisiNotes;
    data['created_by'] = this.createdBy;
    data['supervisi_spb_date'] = this.supervisiSpbDate;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    return data;
  }
}

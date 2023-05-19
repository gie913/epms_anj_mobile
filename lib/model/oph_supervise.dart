class OPHSupervise {
  String? ophSupervisiId;
  String? supervisiEstateCode;
  String? supervisiBlockCode;
  String? supervisiTphCode;
  String? ophId;
  String? supervisiEmployeeCode;
  String? supervisiEmployeeName;
  String? supervisiLat;
  String? supervisiLong;
  String? supervisiMandorEmployeeCode;
  String? supervisiMandorEmployeeName;
  String? supervisiKeraniPanenEmployeeCode;
  String? supervisiKeraniPanenEmployeeName;
  String? supervisiPemanenEmployeeName;
  String? supervisiPemanenEmployeeCode;
  String? supervisiPhoto;
  String? supervisiDivisionCode;
  int? bunchesRipe;
  int? bunchesOverripe;
  int? bunchesHalfripe;
  int? bunchesUnripe;
  int? bunchesAbnormal;
  int? bunchesEmpty;
  int? looseFruits;
  int? bunchesTotal;
  int? bunchesNotSent;
  String? supervisiNotes;
  String? createdBy;
  String? supervisiDate;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;

  OPHSupervise(
      {this.ophSupervisiId,
        this.supervisiEstateCode,
        this.supervisiBlockCode,
        this.supervisiTphCode,
        this.ophId,
        this.supervisiEmployeeCode,
        this.supervisiEmployeeName,
        this.supervisiLat,
        this.supervisiLong,
        this.supervisiMandorEmployeeCode,
        this.supervisiMandorEmployeeName,
        this.supervisiKeraniPanenEmployeeCode,
        this.supervisiKeraniPanenEmployeeName,
        this.supervisiPemanenEmployeeName,
        this.supervisiPemanenEmployeeCode,
        this.supervisiPhoto,
        this.supervisiDivisionCode,
        this.bunchesRipe,
        this.bunchesOverripe,
        this.bunchesHalfripe,
        this.bunchesUnripe,
        this.bunchesAbnormal,
        this.bunchesEmpty,
        this.looseFruits,
        this.bunchesTotal,
        this.bunchesNotSent,
        this.supervisiNotes,
        this.createdBy,
        this.supervisiDate,
        this.createdDate,
        this.createdTime,
        this.updatedBy,
        this.updatedDate,
        this.updatedTime});

  OPHSupervise.fromJson(Map<String, dynamic> json) {
    ophSupervisiId = json['oph_supervisi_id'];
    supervisiEstateCode = json['supervisi_estate_code'];
    supervisiBlockCode = json['supervisi_block_code'];
    supervisiTphCode = json['supervisi_tph_code'];
    ophId = json['oph_id'];
    supervisiEmployeeCode = json['supervisi_employee_code'];
    supervisiEmployeeName = json['supervisi_employee_name'];
    supervisiLat = json['supervisi_lat'];
    supervisiLong = json['supervisi_long'];
    supervisiMandorEmployeeCode = json['supervisi_mandor_employee_code'];
    supervisiMandorEmployeeName = json['supervisi_mandor_employee_name'];
    supervisiKeraniPanenEmployeeCode =
    json['supervisi_kerani_panen_employee_code'];
    supervisiKeraniPanenEmployeeName =
    json['supervisi_kerani_panen_employee_name'];
    supervisiPemanenEmployeeName = json['supervisi_pemanen_employee_name'];
    supervisiKeraniPanenEmployeeCode = json['supervisi_pemanen_employee_code'];
    supervisiPhoto = json['supervisi_photo'];
    supervisiDivisionCode = json['supervisi_division_code'];
    bunchesRipe = json['bunches_ripe'];
    bunchesOverripe = json['bunches_overripe'];
    bunchesHalfripe = json['bunches_halfripe'];
    bunchesUnripe = json['bunches_unripe'];
    bunchesAbnormal = json['bunches_abnormal'];
    bunchesEmpty = json['bunches_empty'];
    looseFruits = json['loose_fruits'];
    bunchesTotal = json['bunches_total'];
    bunchesNotSent = json['bunches_not_sent'];
    supervisiNotes = json['supervisi_notes'];
    createdBy = json['created_by'];
    supervisiDate = json['supervisi_date'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oph_supervisi_id'] = this.ophSupervisiId;
    data['supervisi_estate_code'] = this.supervisiEstateCode;
    data['supervisi_block_code'] = this.supervisiBlockCode;
    data['supervisi_tph_code'] = this.supervisiTphCode;
    data['oph_id'] = this.ophId;
    data['supervisi_employee_code'] = this.supervisiEmployeeCode;
    data['supervisi_employee_name'] = this.supervisiEmployeeName;
    data['supervisi_lat'] = this.supervisiLat;
    data['supervisi_long'] = this.supervisiLong;
    data['supervisi_mandor_employee_code'] = this.supervisiMandorEmployeeCode;
    data['supervisi_mandor_employee_name'] = this.supervisiMandorEmployeeName;
    data['supervisi_kerani_panen_employee_code'] =
        this.supervisiKeraniPanenEmployeeCode;
    data['supervisi_kerani_panen_employee_name'] =
        this.supervisiKeraniPanenEmployeeName;
    data['supervisi_pemanen_employee_name'] = this.supervisiPemanenEmployeeName;
    data['supervisi_pemanen_employee_code'] = this.supervisiPemanenEmployeeCode;
    data['supervisi_photo'] = this.supervisiPhoto;
    data['supervisi_division_code'] = this.supervisiDivisionCode;
    data['bunches_ripe'] = this.bunchesRipe;
    data['bunches_overripe'] = this.bunchesOverripe;
    data['bunches_halfripe'] = this.bunchesHalfripe;
    data['bunches_unripe'] = this.bunchesUnripe;
    data['bunches_abnormal'] = this.bunchesAbnormal;
    data['bunches_empty'] = this.bunchesEmpty;
    data['loose_fruits'] = this.looseFruits;
    data['bunches_total'] = this.bunchesTotal;
    data['bunches_not_sent'] = this.bunchesNotSent;
    data['supervisi_notes'] = this.supervisiNotes;
    data['created_by'] = this.createdBy;
    data['supervisi_date'] = this.supervisiDate;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    return data;
  }
}
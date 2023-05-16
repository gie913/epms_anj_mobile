class LaporanSPBKemarin {
  String? spbId;
  String? spbCardId;
  String? spbEstateCode;
  String? spbDivisionCode;
  String? spbLicenseNumber;
  dynamic spbType;
  String? spbDeliverToCode;
  String? spbDeliverToName;
  String? spbDeliveryNote;
  String? spbLat;
  String? spbLong;
  String? spbKeraniTransportEmployeeCode;
  String? spbKeraniTransportEmployeeName;
  String? spbDriverEmployeeCode;
  String? spbDriverEmployeeName;
  int? spbTotalBunches;
  int? spbTotalOph;
  int? spbTotalLooseFruit;
  dynamic spbCapacityTonnage;
  dynamic spbEstimateTonnage;
  String? spbActualWeightDate;
  String? spbActualWeightTime;
  dynamic spbActualTonnage;
  int? spbIsClosed;
  String? spbPhoto;
  String? spbCertificateId;
  String? certificationCertNoRspo;
  String? certificationCertNoIspo;
  String? certificationCertNoIscc;
  String? certificationNilaiGhgNoRspo;
  String? certificationNilaiGhgNoIspo;
  String? certificationNilaiGhgNoIscc;
  String? certificationIsccId;
  String? certificationIspoId;
  String? certificationRspoId;

  LaporanSPBKemarin(
      {this.spbId,
        this.spbCardId,
        this.spbEstateCode,
        this.spbDivisionCode,
        this.spbLicenseNumber,
        this.spbType,
        this.spbDeliverToCode,
        this.spbDeliverToName,
        this.spbDeliveryNote,
        this.spbLat,
        this.spbLong,
        this.spbKeraniTransportEmployeeCode,
        this.spbKeraniTransportEmployeeName,
        this.spbDriverEmployeeCode,
        this.spbDriverEmployeeName,
        this.spbTotalBunches,
        this.spbTotalOph,
        this.spbTotalLooseFruit,
        this.spbCapacityTonnage,
        this.spbEstimateTonnage,
        this.spbActualWeightDate,
        this.spbActualWeightTime,
        this.spbActualTonnage,
        this.spbIsClosed,
        this.spbPhoto,
        this.spbCertificateId,
        this.certificationCertNoRspo,
        this.certificationCertNoIspo,
        this.certificationCertNoIscc,
        this.certificationNilaiGhgNoRspo,
        this.certificationNilaiGhgNoIspo,
        this.certificationNilaiGhgNoIscc,
        this.certificationIsccId,
        this.certificationIspoId,
        this.certificationRspoId});

  LaporanSPBKemarin.fromJson(Map<String, dynamic> json) {
    spbId = json['spb_id'];
    spbCardId = json['spb_card_id'];
    spbEstateCode = json['spb_estate_code'];
    spbDivisionCode = json['spb_division_code'];
    spbLicenseNumber = json['spb_license_number'];
    spbType = json['spb_type'];
    spbDeliverToCode = json['spb_deliver_to_code'];
    spbDeliverToName = json['spb_deliver_to_name'];
    spbDeliveryNote = json['spb_delivery_note'];
    spbLat = json['spb_lat'];
    spbLong = json['spb_long'];
    spbKeraniTransportEmployeeCode = json['spb_kerani_transport_employee_code'];
    spbKeraniTransportEmployeeName = json['spb_kerani_transport_employee_name'];
    spbDriverEmployeeCode = json['spb_driver_employee_code'];
    spbDriverEmployeeName = json['spb_driver_employee_name'];
    spbTotalBunches = json['spb_total_bunches'];
    spbTotalOph = json['spb_total_oph'];
    spbTotalLooseFruit = json['spb_total_loose_fruit'];
    spbCapacityTonnage = json['spb_capacity_tonnage'];
    spbEstimateTonnage = json['spb_estimate_tonnage'];
    spbActualWeightDate = json['spb_actual_weight_date'];
    spbActualWeightTime = json['spb_actual_weight_time'];
    spbActualTonnage = json['spb_actual_tonnage'];
    spbIsClosed = json['spb_is_closed'];
    spbPhoto = json['spb_photo'];
    spbCertificateId = json['spb_certificate_id'];
    certificationCertNoRspo = json['certification_cert_no_rspo'];
    certificationCertNoIspo = json['certification_cert_no_ispo'];
    certificationCertNoIscc = json['certification_cert_no_iscc'];
    certificationNilaiGhgNoRspo = json['certification_nilai_ghg_no_rspo'];
    certificationNilaiGhgNoIspo = json['certification_nilai_ghg_no_ispo'];
    certificationNilaiGhgNoIscc = json['certification_nilai_ghg_no_iscc'];
    certificationIsccId = json['certification_iscc_id'];
    certificationIspoId = json['certification_ispo_id'];
    certificationRspoId = json['certification_rspo_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spb_id'] = this.spbId;
    data['spb_card_id'] = this.spbCardId;
    data['spb_estate_code'] = this.spbEstateCode;
    data['spb_division_code'] = this.spbDivisionCode;
    data['spb_license_number'] = this.spbLicenseNumber;
    data['spb_type'] = this.spbType;
    data['spb_deliver_to_code'] = this.spbDeliverToCode;
    data['spb_deliver_to_name'] = this.spbDeliverToName;
    data['spb_delivery_note'] = this.spbDeliveryNote;
    data['spb_lat'] = this.spbLat;
    data['spb_long'] = this.spbLong;
    data['spb_kerani_transport_employee_code'] =
        this.spbKeraniTransportEmployeeCode;
    data['spb_kerani_transport_employee_name'] =
        this.spbKeraniTransportEmployeeName;
    data['spb_driver_employee_code'] = this.spbDriverEmployeeCode;
    data['spb_driver_employee_name'] = this.spbDriverEmployeeName;
    data['spb_total_bunches'] = this.spbTotalBunches;
    data['spb_total_oph'] = this.spbTotalOph;
    data['spb_total_loose_fruit'] = this.spbTotalLooseFruit;
    data['spb_capacity_tonnage'] = this.spbCapacityTonnage;
    data['spb_estimate_tonnage'] = this.spbEstimateTonnage;
    data['spb_actual_weight_date'] = this.spbActualWeightDate;
    data['spb_actual_weight_time'] = this.spbActualWeightTime;
    data['spb_actual_tonnage'] = this.spbActualTonnage;
    data['spb_is_closed'] = this.spbIsClosed;
    data['spb_photo'] = this.spbPhoto;
    data['spb_certificate_id'] = this.spbCertificateId;
    data['certification_cert_no_rspo'] = this.certificationCertNoRspo;
    data['certification_cert_no_ispo'] = this.certificationCertNoIspo;
    data['certification_cert_no_iscc'] = this.certificationCertNoIscc;
    data['certification_nilai_ghg_no_rspo'] = this.certificationNilaiGhgNoRspo;
    data['certification_nilai_ghg_no_ispo'] = this.certificationNilaiGhgNoIspo;
    data['certification_nilai_ghg_no_iscc'] = this.certificationNilaiGhgNoIscc;
    data['certification_iscc_id'] = this.certificationIsccId;
    data['certification_ispo_id'] = this.certificationIspoId;
    data['certification_rspo_id'] = this.certificationRspoId;
    return data;
  }
}
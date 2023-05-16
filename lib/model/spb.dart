class SPB {
  String? spbId;
  String? spbCardId;
  String? spbEstateCode;
  String? spbDivisionCode;
  String? spbLicenseNumber;
  int? spbType;
  dynamic spbVendorOthers;
  String? spbDeliverToCode;
  String? spbDeliverToName;
  String? spbDeliveryNote;
  String? spbLat;
  String? spbLong;
  String? spbPhoto;
  String? spbKeraniTransportEmployeeCode;
  String? spbKeraniTransportEmployeeName;
  String? spbDriverEmployeeCode;
  String? spbDriverEmployeeName;
  int? spbTotalBunches;
  int? spbTotalOph;
  int? spbTotalLooseFruit;
  double? spbCapacityTonnage;
  dynamic spbEstimateTonnage;
  String? spbActualWeightDate;
  String? spbActualWeightTime;
  dynamic spbActualTonnage;
  String? spbEstateVendorCode;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;
  int? spbIsClosed;

  SPB(
      {this.spbId,
      this.spbCardId,
      this.spbEstateCode,
      this.spbDivisionCode,
      this.spbLicenseNumber,
      this.spbType,
      this.spbVendorOthers,
      this.spbDeliverToCode,
      this.spbDeliverToName,
      this.spbDeliveryNote,
      this.spbLat,
      this.spbLong,
      this.spbPhoto,
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
      this.spbEstateVendorCode,
      this.createdBy,
      this.createdDate,
      this.createdTime,
      this.updatedBy,
      this.updatedDate,
      this.updatedTime,
      this.spbIsClosed});

  SPB.fromJson(Map<String, dynamic> json) {
    spbId = json['spb_id'];
    spbCardId = json['spb_card_id'];
    spbEstateCode = json['spb_estate_code'];
    spbDivisionCode = json['spb_division_code'];
    spbLicenseNumber = json['spb_license_number'];
    spbType = json['spb_type'];
    spbVendorOthers = json['spb_vendor_others'];
    spbDeliverToCode = json['spb_deliver_to_code'];
    spbDeliverToName = json['spb_deliver_to_name'];
    spbDeliveryNote = json['spb_delivery_note'];
    spbLat = json['spb_lat'];
    spbLong = json['spb_long'];
    spbPhoto = json['spb_photo'];
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
    spbEstateVendorCode = json['spb_estate_vendor_code'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
    spbIsClosed = json['spb_is_closed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spb_id'] = this.spbId;
    data['spb_card_id'] = this.spbCardId;
    data['spb_estate_code'] = this.spbEstateCode;
    data['spb_division_code'] = this.spbDivisionCode;
    data['spb_license_number'] = this.spbLicenseNumber;
    data['spb_type'] = this.spbType;
    data['spb_vendor_others'] = this.spbVendorOthers;
    data['spb_deliver_to_code'] = this.spbDeliverToCode;
    data['spb_deliver_to_name'] = this.spbDeliverToName;
    data['spb_delivery_note'] = this.spbDeliveryNote;
    data['spb_lat'] = this.spbLat;
    data['spb_long'] = this.spbLong;
    data['spb_photo'] = this.spbPhoto;
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
    data['spb_estate_vendor_code'] = this.spbEstateVendorCode;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    data['spb_is_closed'] = this.spbIsClosed;
    return data;
  }
}

class MEstateSchema {
  dynamic estateId;
  String? estateCompanyCode;
  String? estateCode;
  String? estateName;
  String? estatePlantCode;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;
  String? estateVendorCode;

  MEstateSchema(
      {this.estateId,
      this.estateCompanyCode,
      this.estateCode,
      this.estateName,
      this.estatePlantCode,
      this.createdBy,
      this.createdDate,
      this.createdTime,
      this.updatedBy,
      this.updatedDate,
      this.updatedTime,
      this.estateVendorCode});

  MEstateSchema.fromJson(Map<String, dynamic> json) {
    estateId = json['estate_id'];
    estateCompanyCode = json['estate_company_code'];
    estateCode = json['estate_code'];
    estateName = json['estate_name'];
    estatePlantCode = json['estate_plant_code'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
    estateVendorCode = json['estate_vendor_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['estate_id'] = this.estateId;
    data['estate_company_code'] = this.estateCompanyCode;
    data['estate_code'] = this.estateCode;
    data['estate_name'] = this.estateName;
    data['estate_plant_code'] = this.estatePlantCode;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    data['estate_vendor_code'] = this.estateVendorCode;
    return data;
  }
}

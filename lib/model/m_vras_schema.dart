class MVRASchema {
  int? vraId;
  String? vraLicenseNumber;
  dynamic vraMaxCap;
  String? vraValidFrom;
  String? vraValidTo;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;

  MVRASchema(
      {this.vraId,
      this.vraLicenseNumber,
      this.vraMaxCap,
      this.vraValidFrom,
      this.vraValidTo,
      this.createdBy,
      this.createdDate,
      this.createdTime,
      this.updatedBy,
      this.updatedDate,
      this.updatedTime});

  MVRASchema.fromJson(Map<String, dynamic> json) {
    vraId = json['vra_id'];
    vraLicenseNumber = json['vra_license_number'];
    vraMaxCap = json['vra_max_cap'];
    vraValidFrom = json['vra_valid_from'];
    vraValidTo = json['vra_valid_to'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vra_id'] = this.vraId;
    data['vra_license_number'] = this.vraLicenseNumber;
    data['vra_max_cap'] = this.vraMaxCap;
    data['vra_valid_from'] = this.vraValidFrom;
    data['vra_valid_to'] = this.vraValidTo;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    return data;
  }
}

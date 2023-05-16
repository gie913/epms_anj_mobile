class MDivisionSchema {
  dynamic divisionId;
  String? divisionCompanyCode;
  String? divisionEstateCode;
  String? divisionCode;
  String? divisionName;
  String? divisionValidFrom;
  String? divisionValidTo;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;

  MDivisionSchema(
      {this.divisionId,
      this.divisionCompanyCode,
      this.divisionEstateCode,
      this.divisionCode,
      this.divisionName,
      this.divisionValidFrom,
      this.divisionValidTo,
      this.createdBy,
      this.createdDate,
      this.createdTime,
      this.updatedBy,
      this.updatedDate,
      this.updatedTime});

  MDivisionSchema.fromJson(Map<String, dynamic> json) {
    divisionId = json['division_id'];
    divisionCompanyCode = json['division_company_code'];
    divisionEstateCode = json['division_estate_code'];
    divisionCode = json['division_code'];
    divisionName = json['division_name'];
    divisionValidFrom = json['division_valid_from'];
    divisionValidTo = json['division_valid_to'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['division_id'] = this.divisionId;
    data['division_company_code'] = this.divisionCompanyCode;
    data['division_estate_code'] = this.divisionEstateCode;
    data['division_code'] = this.divisionCode;
    data['division_name'] = this.divisionName;
    data['division_valid_from'] = this.divisionValidFrom;
    data['division_valid_to'] = this.divisionValidTo;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    return data;
  }
}

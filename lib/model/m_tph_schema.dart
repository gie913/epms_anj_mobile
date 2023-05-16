class MTPHSchema {
  dynamic tphId;
  String? tphCompanyCode;
  String? tphEstateCode;
  String? tphDivisionCode;
  String? tphBlockCode;
  String? tphCode;
  String? tphValidFrom;
  String? tphValidTo;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;
  String? tphLatitude;
  String? tphLongitude;

  MTPHSchema(
      {this.tphId,
      this.tphCompanyCode,
      this.tphEstateCode,
      this.tphDivisionCode,
      this.tphBlockCode,
      this.tphCode,
      this.tphValidFrom,
      this.tphValidTo,
      this.createdBy,
      this.createdDate,
      this.createdTime,
      this.updatedBy,
      this.updatedDate,
      this.updatedTime,
      this.tphLatitude,
      this.tphLongitude});

  MTPHSchema.fromJson(Map<String, dynamic> json) {
    tphId = json['tph_id'];
    tphCompanyCode = json['tph_company_code'];
    tphEstateCode = json['tph_estate_code'];
    tphDivisionCode = json['tph_division_code'];
    tphBlockCode = json['tph_block_code'];
    tphCode = json['tph_code'];
    tphValidFrom = json['tph_valid_from'];
    tphValidTo = json['tph_valid_to'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
    tphLatitude = json['tph_latitude'];
    tphLongitude = json['tph_longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tph_id'] = this.tphId;
    data['tph_company_code'] = this.tphCompanyCode;
    data['tph_estate_code'] = this.tphEstateCode;
    data['tph_division_code'] = this.tphDivisionCode;
    data['tph_block_code'] = this.tphBlockCode;
    data['tph_code'] = this.tphCode;
    data['tph_valid_from'] = this.tphValidFrom;
    data['tph_valid_to'] = this.tphValidTo;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    data['tph_latitude'] = this.tphLatitude;
    data['tph_longitude'] = this.tphLongitude;
    return data;
  }
}

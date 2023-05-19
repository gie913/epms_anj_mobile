class MBlockSchema {
  int? blockId;
  String? blockCompanyCode;
  String? blockEstateCode;
  String? blockDivisionCode;
  String? blockCode;
  String? blockName;
  // String? blockPlantedDate;
  // String? blockValidFrom;
  // String? blockValidTo;
  // String? createdBy;
  // String? createdDate;
  // String? createdTime;
  // String? updatedBy;
  // String? updatedDate;
  // String? updatedTime;
  // String? blockHectarage;
  // String? blockKerapatanPokok;

  MBlockSchema(
      {this.blockId,
      this.blockCompanyCode,
      this.blockEstateCode,
      this.blockDivisionCode,
      this.blockCode,
      this.blockName,
      // this.blockPlantedDate,
      // this.blockValidFrom,
      // this.blockValidTo,
      // this.createdBy,
      // this.createdDate,
      // this.createdTime,
      // this.updatedBy,
      // this.updatedDate,
      // this.updatedTime,
      // this.blockHectarage,
      // this.blockKerapatanPokok
      });

  MBlockSchema.fromJson(Map<String, dynamic> json) {
    blockId = json['block_id'];
    blockCompanyCode = json['block_company_code'];
    blockEstateCode = json['block_estate_code'];
    blockDivisionCode = json['block_division_code'];
    blockCode = json['block_code'];
    blockName = json['block_name'];
    // blockPlantedDate = json['block_planted_date'];
    // blockValidFrom = json['block_valid_from'];
    // blockValidTo = json['block_valid_to'];
    // createdBy = json['created_by'];
    // createdDate = json['created_date'];
    // createdTime = json['created_time'];
    // updatedBy = json['updated_by'];
    // updatedDate = json['updated_date'];
    // updatedTime = json['updated_time'];
    // blockHectarage = json['block_hectarage'];
    // blockKerapatanPokok = json['block_kerapatan_pokok'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['block_id'] = this.blockId;
    data['block_company_code'] = this.blockCompanyCode;
    data['block_estate_code'] = this.blockEstateCode;
    data['block_division_code'] = this.blockDivisionCode;
    data['block_code'] = this.blockCode;
    data['block_name'] = this.blockName;
    // data['block_planted_date'] = this.blockPlantedDate;
    // data['block_valid_from'] = this.blockValidFrom;
    // data['block_valid_to'] = this.blockValidTo;
    // data['created_by'] = this.createdBy;
    // data['created_date'] = this.createdDate;
    // data['created_time'] = this.createdTime;
    // data['updated_by'] = this.updatedBy;
    // data['updated_date'] = this.updatedDate;
    // data['updated_time'] = this.updatedTime;
    // data['block_hectarage'] = this.blockHectarage;
    // data['block_kerapatan_pokok'] = this.blockKerapatanPokok;
    return data;
  }
}

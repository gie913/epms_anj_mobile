class MMaterialSchema {
  int? materialId;
  String? materialCode;
  String? materialName;
  String? materialUom;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;

  MMaterialSchema(
      {this.materialId,
      this.materialCode,
      this.materialName,
      this.materialUom,
      this.createdBy,
      this.createdDate,
      this.createdTime,
      this.updatedBy,
      this.updatedDate,
      this.updatedTime});

  MMaterialSchema.fromJson(Map<String, dynamic> json) {
    materialId = json['material_id'];
    materialCode = json['material_code'];
    materialName = json['material_name'];
    materialUom = json['material_uom'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['material_id'] = this.materialId;
    data['material_code'] = this.materialCode;
    data['material_name'] = this.materialName;
    data['material_uom'] = this.materialUom;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    return data;
  }
}

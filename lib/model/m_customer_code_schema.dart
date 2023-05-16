class MCustomerCodeSchema {
  dynamic customerCodeId;
  String? customerPlantCode;
  String? customerCode;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;

  MCustomerCodeSchema(
      {this.customerCodeId,
      this.customerPlantCode,
      this.customerCode,
      this.createdBy,
      this.createdDate,
      this.createdTime,
      this.updatedBy,
      this.updatedDate,
      this.updatedTime});

  MCustomerCodeSchema.fromJson(Map<String, dynamic> json) {
    customerCodeId = json['customer_code_id'];
    customerPlantCode = json['customer_plant_code'];
    customerCode = json['customer_code'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_code_id'] = this.customerCodeId;
    data['customer_plant_code'] = this.customerPlantCode;
    data['customer_code'] = this.customerCode;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    return data;
  }
}

class MCostControlSchema {
  int? costControlId;
  int? activityCodeStart;
  int? activityCodeEnd;
  int? costByBlock;
  int? costByAuc;
  int? costByOrderNumber;
  int? costByCostCenter;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;

  MCostControlSchema(
      {this.costControlId,
      this.activityCodeStart,
      this.activityCodeEnd,
      this.costByBlock,
      this.costByAuc,
      this.costByOrderNumber,
      this.costByCostCenter,
      this.createdBy,
      this.createdDate,
      this.createdTime,
      this.updatedBy,
      this.updatedDate,
      this.updatedTime});

  MCostControlSchema.fromJson(Map<String, dynamic> json) {
    costControlId = json['cost_control_id'];
    activityCodeStart = json['activity_code_start'];
    activityCodeEnd = json['activity_code_end'];
    costByBlock = json['cost_by_block'];
    costByAuc = json['cost_by_auc'];
    costByOrderNumber = json['cost_by_order_number'];
    costByCostCenter = json['cost_by_cost_center'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cost_control_id'] = this.costControlId;
    data['activity_code_start'] = this.activityCodeStart;
    data['activity_code_end'] = this.activityCodeEnd;
    data['cost_by_block'] = this.costByBlock;
    data['cost_by_auc'] = this.costByAuc;
    data['cost_by_order_number'] = this.costByOrderNumber;
    data['cost_by_cost_center'] = this.costByCostCenter;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    return data;
  }
}

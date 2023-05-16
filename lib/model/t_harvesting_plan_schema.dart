class THarvestingPlanSchema {
  dynamic harvestingPlanId;
  String? harvestingPlanDate;
  String? harvestingPlanEstateCode;
  String? harvestingPlanDivisionCode;
  String? harvestingPlanBlockCode;
  dynamic harvestingPlanTotalHk;
  String? harvestingPlanHectarage;
  String? harvestingPlanAssistantEmployeeCode;
  String? harvestingPlanAssistantEmployeeName;
  dynamic isApproved;
  String? harvestingPlanApprovedBy;
  String? harvestingPlanApprovedByName;
  String? harvestingPlanApprovedDate;
  String? harvestingPlanApprovedTime;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;

  THarvestingPlanSchema(
      {this.harvestingPlanId,
        this.harvestingPlanDate,
        this.harvestingPlanEstateCode,
        this.harvestingPlanDivisionCode,
        this.harvestingPlanBlockCode,
        this.harvestingPlanTotalHk,
        this.harvestingPlanHectarage,
        this.harvestingPlanAssistantEmployeeCode,
        this.harvestingPlanAssistantEmployeeName,
        this.isApproved,
        this.harvestingPlanApprovedBy,
        this.harvestingPlanApprovedByName,
        this.harvestingPlanApprovedDate,
        this.harvestingPlanApprovedTime,
        this.createdBy,
        this.createdDate,
        this.createdTime,
        this.updatedBy,
        this.updatedDate,
        this.updatedTime});

  THarvestingPlanSchema.fromJson(Map<String, dynamic> json) {
    harvestingPlanId = json['harvesting_plan_id'];
    harvestingPlanDate = json['harvesting_plan_date'];
    harvestingPlanEstateCode = json['harvesting_plan_estate_code'];
    harvestingPlanDivisionCode = json['harvesting_plan_division_code'];
    harvestingPlanBlockCode = json['harvesting_plan_block_code'];
    harvestingPlanTotalHk = json['harvesting_plan_total_hk'];
    harvestingPlanHectarage = json['harvesting_plan_hectarage'];
    harvestingPlanAssistantEmployeeCode =
    json['harvesting_plan_assistant_employee_code'];
    harvestingPlanAssistantEmployeeName =
    json['harvesting_plan_assistant_employee_name'];
    isApproved = json['is_approved'];
    harvestingPlanApprovedBy = json['harvesting_plan_approved_by'];
    harvestingPlanApprovedByName = json['harvesting_plan_approved_by_name'];
    harvestingPlanApprovedDate = json['harvesting_plan_approved_date'];
    harvestingPlanApprovedTime = json['harvesting_plan_approved_time'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['harvesting_plan_id'] = this.harvestingPlanId;
    data['harvesting_plan_date'] = this.harvestingPlanDate;
    data['harvesting_plan_estate_code'] = this.harvestingPlanEstateCode;
    data['harvesting_plan_division_code'] = this.harvestingPlanDivisionCode;
    data['harvesting_plan_block_code'] = this.harvestingPlanBlockCode;
    data['harvesting_plan_total_hk'] = this.harvestingPlanTotalHk;
    data['harvesting_plan_hectarage'] = this.harvestingPlanHectarage;
    data['harvesting_plan_assistant_employee_code'] =
        this.harvestingPlanAssistantEmployeeCode;
    data['harvesting_plan_assistant_employee_name'] =
        this.harvestingPlanAssistantEmployeeName;
    data['is_approved'] = this.isApproved;
    data['harvesting_plan_approved_by'] = this.harvestingPlanApprovedBy;
    data['harvesting_plan_approved_by_name'] =
        this.harvestingPlanApprovedByName;
    data['harvesting_plan_approved_date'] = this.harvestingPlanApprovedDate;
    data['harvesting_plan_approved_time'] = this.harvestingPlanApprovedTime;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    return data;
  }
}
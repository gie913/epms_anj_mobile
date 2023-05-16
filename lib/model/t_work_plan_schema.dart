import 'materials.dart';

class TWorkplanSchema {
  String? workplanId;
  String? workplanDate;
  String? workplanEstateCode;
  String? workplanDivisionCode;
  String? workplanActivityCode;
  String? workplanActivityName;
  String? workplanActivityUom;
  dynamic workplanTarget;
  int? workplanTotalHk;
  String? workplanRemark;
  String? workplanAssistantEmployeeCode;
  String? workplanAssistantEmployeeName;
  String? workplanBlockCode;
  String? workplanOrderNumber;
  String? workplanAucNumber;
  String? workplanCostCenter;
  dynamic isApproved;
  String? workplanApprovedBy;
  String? workplanApprovedByName;
  String? workplanApprovedDate;
  String? workplanApprovedTime;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;
  List<Materials>? materials;

  TWorkplanSchema({
    this.workplanId,
    this.workplanDate,
    this.workplanEstateCode,
    this.workplanDivisionCode,
    this.workplanActivityCode,
    this.workplanActivityName,
    this.workplanActivityUom,
    this.workplanTarget,
    this.workplanTotalHk,
    this.workplanRemark,
    this.workplanAssistantEmployeeCode,
    this.workplanAssistantEmployeeName,
    this.workplanBlockCode,
    this.workplanOrderNumber,
    this.workplanAucNumber,
    this.workplanCostCenter,
    this.isApproved,
    this.workplanApprovedBy,
    this.workplanApprovedByName,
    this.workplanApprovedDate,
    this.workplanApprovedTime,
    this.createdBy,
    this.createdDate,
    this.createdTime,
    this.updatedBy,
    this.updatedDate,
    this.updatedTime,
    this.materials,
  });

  TWorkplanSchema.fromJson(Map<String, dynamic> json) {
    workplanId = json['workplan_id'];
    workplanDate = json['workplan_date'];
    workplanEstateCode = json['workplan_estate_code'];
    workplanDivisionCode = json['workplan_division_code'];
    workplanActivityCode = json['workplan_activity_code'];
    workplanActivityName = json['workplan_activity_name'];
    workplanActivityUom = json['workplan_activity_uom'];
    workplanTarget = json['workplan_target'];
    workplanTotalHk = json['workplan_total_hk'];
    workplanRemark = json['workplan_remark'];
    workplanAssistantEmployeeCode = json['workplan_assistant_employee_code'];
    workplanAssistantEmployeeName = json['workplan_assistant_employee_name'];
    workplanBlockCode = json['workplan_block_code'];
    workplanOrderNumber = json['workplan_order_number'];
    workplanAucNumber = json['workplan_auc_number'];
    workplanCostCenter = json['workplan_cost_center'];
    isApproved = json['is_approved'];
    workplanApprovedBy = json['workplan_approved_by'];
    workplanApprovedByName = json['workplan_approved_by_name'];
    workplanApprovedDate = json['workplan_approved_date'];
    workplanApprovedTime = json['workplan_approved_time'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
    if (json['materials'] != null) {
      materials = <Materials>[];
      json['materials'].forEach((v) {
        materials!.add(new Materials.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workplan_id'] = this.workplanId;
    data['workplan_date'] = this.workplanDate;
    data['workplan_estate_code'] = this.workplanEstateCode;
    data['workplan_division_code'] = this.workplanDivisionCode;
    data['workplan_activity_code'] = this.workplanActivityCode;
    data['workplan_activity_name'] = this.workplanActivityName;
    data['workplan_activity_uom'] = this.workplanActivityUom;
    data['workplan_target'] = this.workplanTarget;
    data['workplan_total_hk'] = this.workplanTotalHk;
    data['workplan_remark'] = this.workplanRemark;
    data['workplan_assistant_employee_code'] =
        this.workplanAssistantEmployeeCode;
    data['workplan_assistant_employee_name'] =
        this.workplanAssistantEmployeeName;
    data['workplan_block_code'] = this.workplanBlockCode;
    data['workplan_order_number'] = this.workplanOrderNumber;
    data['workplan_auc_number'] = this.workplanAucNumber;
    data['workplan_cost_center'] = this.workplanCostCenter;
    data['is_approved'] = this.isApproved;
    data['workplan_approved_by'] = this.workplanApprovedBy;
    data['workplan_approved_by_name'] = this.workplanApprovedByName;
    data['workplan_approved_date'] = this.workplanApprovedDate;
    data['workplan_approved_time'] = this.workplanApprovedTime;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    if (this.materials != null) {
      data['materials'] = this.materials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Materials {
  String? workplanMaterialId;
  String? workplanId;
  String? workplanMaterialCode;
  String? workplanMaterialName;
  String? workplanMaterialUom;
  String? workplanMaterialQty;

  Materials(
      {this.workplanMaterialId,
      this.workplanId,
      this.workplanMaterialCode,
      this.workplanMaterialName,
      this.workplanMaterialUom,
      this.workplanMaterialQty});

  Materials.fromJson(Map<String, dynamic> json) {
    workplanMaterialId = json['workplan_material_id'];
    workplanId = json['workplan_id'];
    workplanMaterialCode = json['workplan_material_code'];
    workplanMaterialName = json['workplan_material_name'];
    workplanMaterialUom = json['workplan_material_uom'];
    workplanMaterialQty = json['workplan_material_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workplan_material_id'] = this.workplanMaterialId;
    data['workplan_id'] = this.workplanId;
    data['workplan_material_code'] = this.workplanMaterialCode;
    data['workplan_material_name'] = this.workplanMaterialName;
    data['workplan_material_uom'] = this.workplanMaterialUom;
    data['workplan_material_qty'] = this.workplanMaterialQty;
    return data;
  }
}

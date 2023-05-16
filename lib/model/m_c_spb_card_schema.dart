class MCSPBCardSchema {
  String? spbCardId;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;
  String? spbCardDivision;
  String? spbCardStatus;

  MCSPBCardSchema(
      {this.spbCardId,
      this.createdBy,
      this.createdDate,
      this.createdTime,
      this.updatedBy,
      this.updatedDate,
      this.updatedTime,
      this.spbCardDivision,
      this.spbCardStatus});

  MCSPBCardSchema.fromJson(Map<String, dynamic> json) {
    spbCardId = json['spb_card_id'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
    spbCardDivision = json['spb_card_division'];
    spbCardStatus = json['spb_card_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spb_card_id'] = this.spbCardId;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    data['spb_card_division'] = this.spbCardDivision;
    data['spb_card_status'] = this.spbCardStatus;
    return data;
  }
}

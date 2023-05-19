class MCOPHCardSchema {
  String? ophCardId;
  // String? createdBy;
  // String? createdDate;
  // String? createdTime;
  // String? updatedBy;
  // String? updatedDate;
  // String? updatedTime;
  String? ophCardDivision;
  // String? ophCardStatus;

  MCOPHCardSchema(
      {this.ophCardId,
      // this.createdBy,
      // this.createdDate,
      // this.createdTime,
      // this.updatedBy,
      // this.updatedDate,
      // this.updatedTime,
      this.ophCardDivision,
      // this.ophCardStatus
      });

  MCOPHCardSchema.fromJson(Map<String, dynamic> json) {
    ophCardId = json['oph_card_id'];
    // createdBy = json['created_by'];
    // createdDate = json['created_date'];
    // createdTime = json['created_time'];
    // updatedBy = json['updated_by'];
    // updatedDate = json['updated_date'];
    // updatedTime = json['updated_time'];
    ophCardDivision = json['oph_card_division'];
    // ophCardStatus = json['oph_card_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oph_card_id'] = this.ophCardId;
    // data['created_by'] = this.createdBy;
    // data['created_date'] = this.createdDate;
    // data['created_time'] = this.createdTime;
    // data['updated_by'] = this.updatedBy;
    // data['updated_date'] = this.updatedDate;
    // data['updated_time'] = this.updatedTime;
    data['oph_card_division'] = this.ophCardDivision;
    // data['oph_card_status'] = this.ophCardStatus;
    return data;
  }
}

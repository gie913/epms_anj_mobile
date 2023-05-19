class MDestinationSchema {
  dynamic destinationId;
  String? destinationCode;
  String? destinationName;
  // String? createdBy;
  // String? createdDate;
  // String? createdTime;
  // String? updatedBy;
  // String? updatedDate;
  // String? updatedTime;

  MDestinationSchema(
      {this.destinationId,
      this.destinationCode,
      this.destinationName,
      // this.createdBy,
      // this.createdDate,
      // this.createdTime,
      // this.updatedBy,
      // this.updatedDate,
      // this.updatedTime
      });

  MDestinationSchema.fromJson(Map<String, dynamic> json) {
    destinationId = json['destination_id'];
    destinationCode = json['destination_code'];
    destinationName = json['destination_name'];
    // createdBy = json['created_by'];
    // createdDate = json['created_date'];
    // createdTime = json['created_time'];
    // updatedBy = json['updated_by'];
    // updatedDate = json['updated_date'];
    // updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['destination_id'] = this.destinationId;
    data['destination_code'] = this.destinationCode;
    data['destination_name'] = this.destinationName;
    // data['created_by'] = this.createdBy;
    // data['created_date'] = this.createdDate;
    // data['created_time'] = this.createdTime;
    // data['updated_by'] = this.updatedBy;
    // data['updated_date'] = this.updatedDate;
    // data['updated_time'] = this.updatedTime;
    return data;
  }
}

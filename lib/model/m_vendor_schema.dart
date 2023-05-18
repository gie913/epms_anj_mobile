// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class MVendorSchema extends Equatable {
  dynamic vendorId;
  String? vendorCode;
  String? vendorName;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;

  MVendorSchema(
      {this.vendorId,
      this.vendorCode,
      this.vendorName,
      this.createdBy,
      this.createdDate,
      this.createdTime,
      this.updatedBy,
      this.updatedDate,
      this.updatedTime});

  MVendorSchema.fromJson(Map<String, dynamic> json) {
    vendorId = json['vendor_id'];
    vendorCode = json['vendor_code'];
    vendorName = json['vendor_name'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vendor_id'] = this.vendorId;
    data['vendor_code'] = this.vendorCode;
    data['vendor_name'] = this.vendorName;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    return data;
  }

  @override
  List<Object> get props => [vendorCode!, vendorName!];

  @override
  bool get stringify => false;
}

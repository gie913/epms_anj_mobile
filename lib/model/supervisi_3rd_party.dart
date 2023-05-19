class Supervisi3rdParty {
  String? sortasiId;
  String? spbId;
  String? gradingDate;

  Supervisi3rdParty({this.sortasiId, this.spbId, this.gradingDate});

  Supervisi3rdParty.fromJson(Map<String, dynamic> json) {
    sortasiId = json['sortasi_id'];
    spbId = json['spb_id'];
    gradingDate = json['grading_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sortasi_id'] = this.sortasiId;
    data['spb_id'] = this.spbId;
    data['grading_date'] = this.gradingDate;
    return data;
  }
}
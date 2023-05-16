class Supervisor {
  String? employeeCode;
  String? mandorName;
  String? mandorCode;
  String? mandor1Name;
  String? mandor1Code;
  String? keraniPanenName;
  String? keraniPanenCode;
  String? keraniKirimName;
  String? keraniKirimCode;

  Supervisor(
      {
        this.employeeCode,
        this.mandorName,
      this.mandorCode,
      this.mandor1Name,
      this.mandor1Code,
      this.keraniPanenName,
      this.keraniPanenCode,
      this.keraniKirimCode,
      this.keraniKirimName});

  Supervisor.fromJson(Map<String, dynamic> json) {
    employeeCode = json['employee_code'];
    mandorName = json['mandor_name'];
    mandorCode = json['mandor_code'];
    mandor1Code = json['mandor1_code'];
    mandor1Name = json['mandor1_name'];
    keraniPanenName = json['kerani_panen_name'];
    keraniPanenCode = json['kerani_panen_code'];
    keraniKirimName = json['kerani_kirim_name'];
    keraniKirimCode = json['kerani_kirim_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['employee_code'] = this.employeeCode;
    data['mandor_name'] = this.mandorName;
    data['mandor_code'] = this.mandorCode;
    data['mandor1_code'] = this.mandor1Code;
    data['mandor1_name'] = this.mandor1Name;
    data['kerani_panen_name'] = this.keraniPanenName;
    data['kerani_panen_code'] = this.keraniPanenCode;
    data['kerani_kirim_name'] = this.keraniKirimName;
    data['kerani_kirim_code'] = this.keraniKirimCode;
    return data;
  }
}

class Token {
  String? id;
  String? token;
  String? username;

  Token({this.id, this.token, this.username});

  Token.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['token'] = this.token;
    data['username'] = this.username;
    return data;
  }
}

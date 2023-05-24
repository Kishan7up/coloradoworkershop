class Recent_view_list {
  int userId;
  int id;
  String title;
  String body;

  Recent_view_list({this.userId, this.id, this.title, this.body});

  Recent_view_list.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}

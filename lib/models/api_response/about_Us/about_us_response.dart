class AboutUsResponse {
  String message;
  int status;
  String data;

  AboutUsResponse({this.message, this.status,this.data});

  AboutUsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['data'] = this.data;

    return data;
  }
}

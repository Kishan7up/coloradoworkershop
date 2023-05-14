class MaxBenifitRequest {
  String notification;
  String device_token;
  String date;

  /*firstName:
lastName:
email:
phoneNumber:
message:*/

  MaxBenifitRequest({
    this.notification,
    this.device_token,
    this.date
  });

  MaxBenifitRequest.fromJson(Map<String, dynamic> json) {
    notification = json['notification'];
    device_token = json['device_token'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification'] = this.notification;
    data['device_token'] = this.device_token;
    data['date'] = this.date;
    return data;
  }
}

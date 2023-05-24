class NotificationActivateRequest {
  String notification;
  String device_token;
  String device_type;

  /*firstName:
lastName:
email:
phoneNumber:
message:*/

  NotificationActivateRequest({this.notification, this.device_token,this.device_type});

  NotificationActivateRequest.fromJson(Map<String, dynamic> json) {
    notification = json['notification'];
    device_token = json['device_token'];
    device_type = json['device_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification'] = this.notification;
    data['device_token'] = this.device_token;
    data['device_type'] = this.device_type;

    return data;
  }
}

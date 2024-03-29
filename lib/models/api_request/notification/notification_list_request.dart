class NotificationListRequest {
  String notification;
  String device_token;

  /*firstName:
lastName:
email:
phoneNumber:
message:*/

  NotificationListRequest({this.notification, this.device_token});

  NotificationListRequest.fromJson(Map<String, dynamic> json) {
    notification = json['notification'];
    device_token = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification'] = this.notification;
    data['device_token'] = this.device_token;

    return data;
  }
}

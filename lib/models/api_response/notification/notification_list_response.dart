class NotificationListResponse {
  int status;
  String message;
  NotificationListResponseData data;

  NotificationListResponse({this.status, this.message, this.data});

  NotificationListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new NotificationListResponseData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class NotificationListResponseData {
  NotificationListResponseDetails details;
  String totalCount;

  NotificationListResponseData({this.details, this.totalCount});

  NotificationListResponseData.fromJson(Map<String, dynamic> json) {
    details = json['details'] != null
        ? new NotificationListResponseDetails.fromJson(json['details'])
        : null;
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.toJson();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class NotificationListResponseDetails {
  String body;

  NotificationListResponseDetails({this.body});

  NotificationListResponseDetails.fromJson(Map<String, dynamic> json) {
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    return data;
  }
}

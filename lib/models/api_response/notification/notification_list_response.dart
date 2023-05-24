class NotificationListResponse {
  int status;
  String message;
  NotificationListResponseData data;

  NotificationListResponse({this.status, this.message, this.data});

  NotificationListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new NotificationListResponseData.fromJson(json['data']) : null;
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
  int totalCount;

  NotificationListResponseData({this.details, this.totalCount});

  NotificationListResponseData.fromJson(Map<String, dynamic> json) {
    details =
    json['details'] != null ? new NotificationListResponseDetails.fromJson(json['details']) : null;
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
  List<NotificationListResponseBody> body;

  NotificationListResponseDetails({this.body});

  NotificationListResponseDetails.fromJson(Map<String, dynamic> json) {
    if (json['body'] != null) {
      body = [];
      json['body'].forEach((v) {
        body.add(new NotificationListResponseBody.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationListResponseBody {
  int id;
  String title;
  String description;
  int userId;
  int isRead;
  String createdAt;
  String updatedAt;
  int type;

  NotificationListResponseBody(
      {this.id,
        this.title,
        this.description,
        this.userId,
        this.isRead,
        this.createdAt,
        this.updatedAt,
        this.type});

  NotificationListResponseBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    userId = json['user_id'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['user_id'] = this.userId;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['type'] = this.type;
    return data;
  }
}
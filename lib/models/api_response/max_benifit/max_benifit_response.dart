class MaxBenifitResponse {
  int status;
  String message;
  MaxBenifitResponseData data;

  MaxBenifitResponse({this.status, this.message, this.data});

  MaxBenifitResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new MaxBenifitResponseData.fromJson(json['data']) : null;
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

class MaxBenifitResponseData {
  MaxBenifitResponseDataDetails details;
  int totalCount;

  MaxBenifitResponseData({this.details, this.totalCount});

  MaxBenifitResponseData.fromJson(Map<String, dynamic> json) {
    details =
    json['details'] != null ? new MaxBenifitResponseDataDetails.fromJson(json['details']) : null;
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

class MaxBenifitResponseDataDetails {
  String ppf;
  String comp;
  String aww;
  String scheduled;
  String disfigurement;
  String extensiveDisfigurement;
  String s1cap;
  String s2cap;

  MaxBenifitResponseDataDetails(
      {this.ppf,
        this.comp,
        this.aww,
        this.scheduled,
        this.disfigurement,
        this.extensiveDisfigurement,
        this.s1cap,
        this.s2cap});

  MaxBenifitResponseDataDetails.fromJson(Map<String, dynamic> json) {
    ppf = json['ppf'];
    comp = json['comp'];
    aww = json['aww'];
    scheduled = json['scheduled'];
    disfigurement = json['disfigurement'];
    extensiveDisfigurement = json['extensive_disfigurement'];
    s1cap = json['1cap'];
    s2cap = json['2cap'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ppf'] = this.ppf;
    data['comp'] = this.comp;
    data['aww'] = this.aww;
    data['scheduled'] = this.scheduled;
    data['disfigurement'] = this.disfigurement;
    data['extensive_disfigurement'] = this.extensiveDisfigurement;
    data['1cap'] = this.s1cap;
    data['2cap'] = this.s2cap;
    return data;
  }
}
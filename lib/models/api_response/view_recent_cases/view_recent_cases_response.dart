class ViewRecentCasesResponse {
  ViewRecentCasesResponseData data;
  String message;
  int status;

  ViewRecentCasesResponse({this.data, this.message, this.status});

  ViewRecentCasesResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new ViewRecentCasesResponseData.fromJson(json['data'])
        : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class ViewRecentCasesResponseData {
  List<ViewRecentCasesResponseDetails> details;
  int totalCount;

  ViewRecentCasesResponseData({this.details, this.totalCount});

  ViewRecentCasesResponseData.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ViewRecentCasesResponseDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class ViewRecentCasesResponseDetails {
  String title;
  int caseNo;
  String caseDetailShort;
  String caseDetailLong;
  String filter;
  String link;

  ViewRecentCasesResponseDetails(
      {this.title,
      this.caseNo,
      this.caseDetailShort,
      this.caseDetailLong,
      this.filter,
      this.link});

  ViewRecentCasesResponseDetails.fromJson(Map<String, dynamic> json) {
    title = json['title'] == null ? "" : json['title'];
    caseNo = json['case_no'] == null ? 0 : json['case_no'];
    caseDetailShort =
        json['case_detail_short'] == null ? "" : json['case_detail_short'];
    caseDetailLong =
        json['case_detail_long'] == null ? "" : json['case_detail_long'];
    filter = json['filter'] == null ? "" : json['filter'];
    link = json['link'] == null ? "" : json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['case_no'] = this.caseNo;
    data['case_detail_short'] = this.caseDetailShort;
    data['case_detail_long'] = this.caseDetailLong;
    data['filter'] = this.filter;
    data['link'] = this.link;
    return data;
  }
}

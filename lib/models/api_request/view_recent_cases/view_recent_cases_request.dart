class ViewRecentCasesRequest {
  String filter;

  /*firstName:
lastName:
email:
phoneNumber:
message:*/

  ViewRecentCasesRequest({
    this.filter,
  });

  ViewRecentCasesRequest.fromJson(Map<String, dynamic> json) {
    filter = json['filter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filter'] = this.filter;

    return data;
  }
}

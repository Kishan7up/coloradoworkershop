class MaxBenifitResponse {
  int status;
  String message;
  MaxBenifitResponseData data;

  MaxBenifitResponse({this.status, this.message, this.data});

  MaxBenifitResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new MaxBenifitResponseData.fromJson(json['data'])
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

class MaxBenifitResponseData {
  MaxBenifitResponseDataDetails details;
  String totalCount;

  MaxBenifitResponseData({this.details, this.totalCount});

  MaxBenifitResponseData.fromJson(Map<String, dynamic> json) {
    details = json['details'] != null
        ? new MaxBenifitResponseDataDetails.fromJson(json['details'])
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

class MaxBenifitResponseDataDetails {
  String maxAvgWeekWage;
  String maxPpdWeekRate;
  String maxTtdWeekRate;
  String impairmentWeekRate;
  String woStumps;
  String wStumps;
  String twentyFiveLess;
  String twentyFiveMore;

  MaxBenifitResponseDataDetails(
      {this.maxAvgWeekWage,
      this.maxPpdWeekRate,
      this.maxTtdWeekRate,
      this.impairmentWeekRate,
      this.woStumps,
      this.wStumps,
      this.twentyFiveLess,
      this.twentyFiveMore});

  MaxBenifitResponseDataDetails.fromJson(Map<String, dynamic> json) {
    maxAvgWeekWage =
        json['max_avg_week_wage'] == null ? "" : json['max_avg_week_wage'];
    maxPpdWeekRate =
        json['max_ppd_week_rate'] == null ? "" : json['max_ppd_week_rate'];
    maxTtdWeekRate =
        json['max_ttd_week_rate'] == null ? "" : json['max_ttd_week_rate'];
    impairmentWeekRate = json['impairment_week_rate'] == null
        ? ""
        : json['impairment_week_rate'];
    woStumps = json['wo_stumps'] == null ? "" : json['wo_stumps'];
    wStumps = json['w_stumps'] == null ? "" : json['w_stumps'];
    twentyFiveLess =
        json['twenty_five_less'] == null ? "" : json['twenty_five_less'];
    twentyFiveMore =
        json['twenty_five_more'] == null ? "" : json['twenty_five_more'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['max_avg_week_wage'] = this.maxAvgWeekWage;
    data['max_ppd_week_rate'] = this.maxPpdWeekRate;
    data['max_ttd_week_rate'] = this.maxTtdWeekRate;
    data['impairment_week_rate'] = this.impairmentWeekRate;
    data['wo_stumps'] = this.woStumps;
    data['w_stumps'] = this.wStumps;
    data['twenty_five_less'] = this.twentyFiveLess;
    data['twenty_five_more'] = this.twentyFiveMore;
    return data;
  }
}

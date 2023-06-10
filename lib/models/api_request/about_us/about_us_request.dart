class AboutUsRequest {
  String firstName;


  /*firstName:
lastName:
email:
phoneNumber:
message:*/

  AboutUsRequest(
      {this.firstName,
    });

  AboutUsRequest.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;


    return data;
  }
}

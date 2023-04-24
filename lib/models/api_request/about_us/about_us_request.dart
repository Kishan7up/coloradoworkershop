class AboutUsRequest {
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String message;

  /*firstName:
lastName:
email:
phoneNumber:
message:*/

  AboutUsRequest(
      {this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.message});

  AboutUsRequest.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['message'] = this.message;

    return data;
  }
}

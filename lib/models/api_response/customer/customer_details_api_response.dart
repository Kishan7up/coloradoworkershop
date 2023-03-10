class CustomerDetailsResponse {
  List<CustomerDetails> details;
  int totalCount;

  CustomerDetailsResponse({this.details, this.totalCount});

  CustomerDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new CustomerDetails.fromJson(v));
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

class CustomerDetails {
  int rowNum;
  int customerID;
  String customerName;
  String customerType;
  String address;
  String area;
  String pinCode;
  int cityCode;
  String cityName;
  int stateCode;
  String stateName;
  String countryCode;
  String countryName;
  String address1;
  String area1;
  String pinCode1;
  int cityCode1;
  String cityName1;
  int stateCode1;
  String stateName1;
  String countryCode1;
  String countryName1;
  String gSTNO;
  String pANNO;
  String cINNO;
  String contactNo1;
  String contactNo2;
  String emailAddress;
  String websiteAddress;
  String birthDate;
  String anniversaryDate;
  int orgTypeCode;
  int customerSourceID;
  String customerSourceName;
  int parentID;
  String createdDate;
  String createdBy;
  bool blockCustomer;
  String parentName;

  CustomerDetails({
    this.rowNum,
    this.customerID,
    this.customerName,
    this.customerType,
    this.blockCustomer,
    this.address,
    this.area,
    this.pinCode,
    this.cityCode,
    this.cityName,
    this.stateCode,
    this.stateName,
    this.address1,
    this.area1,
    this.pinCode1,
    this.cityCode1,
    this.cityName1,
    this.stateCode1,
    this.stateName1,
    this.gSTNO,
    this.pANNO,
    this.cINNO,
    this.contactNo1,
    this.contactNo2,
    this.emailAddress,
    this.websiteAddress,
    this.birthDate,
    this.anniversaryDate,
    this.orgTypeCode,
    this.parentID,
    this.parentName,
    this.customerSourceID,
    this.customerSourceName,
    this.countryCode,
    this.countryName,
    this.countryCode1,
    this.countryName1,
  });

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] != null ? json['RowNum'] : 0;
    customerID = json['CustomerID'] != null ? json['CustomerID'] : 0;
    customerName = json['CustomerName'] != null ? json['CustomerName'] : "";
    customerType = json['CustomerType'] != null ? json['CustomerType'] : "";
    blockCustomer =
        json['BlockCustomer'] != null ? json['BlockCustomer'] : true;
    address = json['Address'] != null ? json['Address'] : "";
    area = json['Area'] != null ? json['Area'] : "";
    pinCode = json['PinCode'] != null ? json['PinCode'] : "";
    cityCode = json['CityCode'] != null ? json['CityCode'] : 0;
    cityName = json['CityName'] != null ? json['CityName'] : "";
    stateCode = json['StateCode'] != null ? json['StateCode'] : 0;
    stateName = json['StateName'] != null ? json['StateName'] : "";
    address1 = json['Address1'] != null ? json['Address1'] : "";
    area1 = json['Area1'] != null ? json['Area1'] : "";
    ;
    pinCode1 = json['PinCode1'] != null ? json['PinCode1'] : "";
    cityCode1 = json['CityCode1'] != null ? json['CityCode1'] : 0;
    cityName1 = json['CityName1'] != null ? json['CityName1'] : "";
    stateCode1 = json['StateCode1'] != null ? json['StateCode1'] : 0;
    stateName1 = json['StateName1'] != null ? json['StateName1'] : "";
    gSTNO = json['GSTNO'] != null ? json['GSTNO'] : "";
    pANNO = json['PANNO'] != null ? json['PANNO'] : "";
    cINNO = json['CINNO'] != null ? json['CINNO'] : "";
    contactNo1 = json['ContactNo1'] != null ? json['ContactNo1'] : "";
    contactNo2 = json['ContactNo2'] != null ? json['ContactNo2'] : "";
    emailAddress = json['EmailAddress'] != null ? json['EmailAddress'] : "";
    websiteAddress =
        json['WebsiteAddress'] != null ? json['WebsiteAddress'] : "";
    birthDate = json['BirthDate'] != null ? json['BirthDate'] : "";
    anniversaryDate =
        json['AnniversaryDate'] != null ? json['AnniversaryDate'] : "";
    orgTypeCode = json['OrgTypeCode'] != null ? json['OrgTypeCode'] : 0;
    parentID = json['ParentID'] != null ? json['ParentID'] : 0;
    parentName = json['ParentName'] != null ? json['ParentName'] : "";
    customerSourceID =
        json['CustomerSourceID'] != null ? json['CustomerSourceID'] : 0;
    customerSourceName =
        json['CustomerSourceName'] != null ? json['CustomerSourceName'] : "";
    countryCode = json['CountryCode'] != null ? json['CountryCode'] : "";
    countryName = json['CountryName'] != null ? json['CountryName'] : "";
    countryCode1 = json['CountryCode1'] != null ? json['CountryCode1'] : "";
    countryName1 = json['CountryName1'] != null ? json['CountryName1'] : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['CustomerType'] = this.customerType;
    data['BlockCustomer'] = this.blockCustomer;
    data['Address'] = this.address;
    data['Area'] = this.area;
    data['PinCode'] = this.pinCode;
    data['CityCode'] = this.cityCode;
    data['CityName'] = this.cityName;
    data['StateCode'] = this.stateCode;
    data['StateName'] = this.stateName;
    data['Address1'] = this.address1;
    data['Area1'] = this.area1;
    data['PinCode1'] = this.pinCode1;
    data['CityCode1'] = this.cityCode1;
    data['CityName1'] = this.cityName1;
    data['StateCode1'] = this.stateCode1;
    data['StateName1'] = this.stateName1;
    data['GSTNO'] = this.gSTNO;
    data['PANNO'] = this.pANNO;
    data['CINNO'] = this.cINNO;
    data['ContactNo1'] = this.contactNo1;
    data['ContactNo2'] = this.contactNo2;
    data['EmailAddress'] = this.emailAddress;
    data['WebsiteAddress'] = this.websiteAddress;
    data['BirthDate'] = this.birthDate;
    data['AnniversaryDate'] = this.anniversaryDate;
    data['OrgTypeCode'] = this.orgTypeCode;
    data['ParentID'] = this.parentID;
    data['ParentName'] = this.parentName;
    data['CustomerSourceID'] = this.customerSourceID;
    data['CustomerSourceName'] = this.customerSourceName;

    data['CountryCode'] = this.countryCode;
    data['CountryName'] = this.countryName;
    data['CountryCode1'] = this.countryCode1;
    data['CountryName1'] = this.countryName1;

    return data;
  }
}

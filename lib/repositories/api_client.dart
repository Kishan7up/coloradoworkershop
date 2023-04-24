import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app/models/common/globals.dart';
import 'package:app/utils/date_time_extensions.dart';
import 'package:app/utils/general_utils.dart';
import 'package:app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;

import 'custom_exception.dart';
import 'error_response_exception.dart';

class ApiClient {
  ///set apis' base url here

  static var BASE_URL = "http://122.169.111.101:108/";

  static var BASE_URL_FOR_COLORADO = "https://admin.appcoloworkcomp.com/api/";

  // "http://122.169.111.101:108/"; //

  /// General Flutter Test SerialKey = TEST-0000-SI0F-0208 / ID : admin / Pwd : Sharvaya / SiteURL : 122.169.11.101:3346

  /// Testing Project Credential

/*

SharvayaNativeTEST  : [BaseURL(API)]:	http://122.169.111.101:107/ [WebURL]:http://122.169.111.101:207/  CompanyID:4131	SerailsKey:TEST-0000-SI0N-0207
SharvayaFlutterTEST : [BaseURL(API)]:	http://122.169.111.101:108/ [WebURL]:http://122.169.111.101:208/  CompanyID:4132	SerailsKey:TEST-0000-SI0F-0208
SoleosFlutterTEST   : [BaseURL(API)]:	http://122.169.111.101:112/ [WebURL]:http://122.169.111.101:212/  CompanyID:4133	SerailsKey:TEST-0000-SOLF-0212
DolphinFlutterTEST  : [BaseURL(API)]:	http://122.169.111.101:105/ [WebURL]:http://122.169.111.101:205/  CompanyID:4134	SerailsKey:TEST-0000-DOLF-0205
CartFlutterAPITEST  : [BaseURL(API)]:	http://122.169.111.101:106/ [WebURL]:http://122.169.111.101:206/  CompanyID:4135	SerailsKey:TEST-0000-CARF-0206

 */

// Live Project Credential
/*

SharvayaNativeLive  : [BaseURL(API)]:	http://208.109.14.134:82/ [WebURL]:http://122.169.111.101:207/  CompanyID:4131	SerailsKey:TEST-0000-SI0N-0207
SharvayaFlutterLive : [BaseURL(API)]:	http://208.109.14.134:83/ [WebURL]:http://122.169.111.101:208/  CompanyID:1007	SerailsKey:6CTR-6KWG-3TQV-3WU0
SoleosFlutterLive   : [BaseURL(API)]:	http://208.109.14.134:84/ [WebURL]:http://122.169.111.101:212/  CompanyID:4133	SerailsKey:TEST-0000-SOLF-0212
DolphinFlutterLive  : [BaseURL(API)]:	http://208.109.14.134:85/ [WebURL]:http://122.169.111.101:205/  CompanyID:4134	SerailsKey:TEST-0000-DOLF-0205
CartFlutterLive     : [BaseURL(API)]:	http://208.109.14.134:86/ [WebURL]:http://122.169.111.101:206/  CompanyID:4135	SerailsKey:TEST-0000-CARF-0206

*/

  ///add end point of your apis as below
  static const END_POINT_REGISTRATION = 'Login/SerialKey';

  /// end point of login User Details
  static const END_POINT_LOGIN = 'Login/';
  static const END_POINT_CUSTOMER_PAGINATION = 'Customer';
  static const END_POINT_CUSTOMER_SEARCH_BY_ID = 'Customer/';
  static const END_POINT_CUSTOMER_SEARCH = 'Customer/Search';
  static const END_POINT_CUSTOMER_CATEGORY = 'Customer/CategoryList';
  static const END_POINT_COUNTRYLIST = 'Country/List';
  static const END_POINT_STATELIST = 'Customer/States/Search';
  static const END_POINT_CITY_LIST = "Customer/Cities/Search";
  static const END_POINT_CUSTOMER_ADD_EDIT = "Customer/";
  static const END_POINT_CUSTOMER_DELETE = "Customer/";
  static const END_POINT_CUSTOMER_SOURCE = 'Customer/Source';
  static const END_POINT_INQUIRY = 'Inquiry';
  static const END_POINT_INQUIRY_SEARCH_BY_INQUIRY_NO =
      'Inquiry/SearchByInquiryNo';

  static const END_POINT_INQUIRY_SEARCH_BY_NAME = 'Inquiry/SearchByName';
  static const END_POINT_PRODUCT_SEARCH = "Inquiry/Product/List";
  static const END_POINT_INQUIRY_HEADER_SAVE = "Inquiry/";
  static const END_POINT_INQUIRY_PRODUCT_SAVE = "Inquiry/Product/INS_UPD";
  static const END_POINT_INQUIRY_NO_TO_PRODUCT_LIST = "Inquiry/Products/1-1000";
  static const END_POINT_INQUIRY_NO_TO_DELETE_PRODUCT_LIST = "Inquiry/";
  static const END_POINT_INQUIRY_SEARCH_BY_PKID = 'Inquiry/';
  static const END_POINT_FOLLOWUP_TYPE_LIST = "Customer/Source";

  static const END_POINT_FOLLOWER_EMPLOYEE_LIST =
      'Inquiry/EmployeeFollowerList';
  static const END_POINT_INQUIRY_SEARCH_BY_FILLTER = 'Inquiry/SearchList';
  static const END_POINT_RECENT_VIEW_LIST = 'Customer/1-3';

  static const END_POINT_ABOUT_US = 'aboutUs';
  static const END_POINT_CONTACT_US = 'contactUs';

  //DailyAttendanceMode/0/Save
  final http.Client httpClient;

  ApiClient({this.httpClient});

  Future<dynamic> apiCallrecentview(
    String url,
    Map<String, dynamic> requestJsonMap, {
    /*String baseUrl = BASE_URL,*/
    bool showSuccessDialog = false,
    //dynamic jsontemparray,
  }) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Headers - $headers");
    //String asd = json.encode(jsontemparray);

    log("Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $requestJsonMap" /*+ "JSON Array $asd"*/);
    /*print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap" */ /*+ "JSON Array $asd"*/ /*);*/
    try {
      final response = await httpClient
          .post(Uri.parse("$BASE_URL$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));

      responseJson =
          await _response(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  ///GET api call
  Future<dynamic> apiCallGet(String url, {String query = ""}) async {
    var responseJson;
    var getUrl;

    if (query.isNotEmpty) {
      getUrl = '$BASE_URL$url?$query';
    } else {
      getUrl = '$BASE_URL$url';
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Api request url : $getUrl");
    String authToken =
        SharedPrefHelper.instance.getString(SharedPrefHelper.AUTH_TOKEN_STRING);
    if (authToken != null && authToken.isNotEmpty) {
      headers['access-token'] = "$authToken";
    }

    try {
      String timeZone = await getCurrentTimeZone();
      if (timeZone != null && timeZone.isNotEmpty) {
        headers['timeZone'] = timeZone;
      }
    } catch (e) {}
    print("Api request url : $getUrl\nHeaders - $headers");

    try {
      final response = await httpClient
          .get(Uri.parse(getUrl), headers: headers)
          .timeout(const Duration(seconds: 60));
      responseJson = await _response(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  ///POST api call
  Future<dynamic> apiCallPost(
    String url,
    Map<String, dynamic> requestJsonMap, {
    /*String baseUrl = BASE_URL,*/
    bool showSuccessDialog = false,
    //dynamic jsontemparray,
  }) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Headers - $headers");
    //String asd = json.encode(jsontemparray);

    log("Api request url : $BASE_URL_FOR_COLORADO$url\nHeaders - $headers\nApi request params : $requestJsonMap" /*+ "JSON Array $asd"*/);
    /*print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap" */ /*+ "JSON Array $asd"*/ /*);*/
    try {
      final response = await httpClient
          .post(Uri.parse("$BASE_URL_FOR_COLORADO$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));

      responseJson =
          await _response(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  Future<dynamic> _response(http.Response response,
      {bool showSuccessDialog = false}) async {
    log("Api response\n${response.body}");
    print("Api response\n${response.body}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        // final data = responseJson["Data"];
        final message =
            responseJson["message"] == null ? "" : responseJson["message"];

        if (responseJson["status"] == 1) {
          if (showSuccessDialog) {
            await showCommonDialogWithSingleOption(Globals.context, message,
                positiveButtonTitle: "OK");
          }

          return responseJson;
        }
        if (responseJson["status"] == 2) {
          if (showSuccessDialog) {
            await showCommonDialogWithSingleOption(Globals.context, message,
                positiveButtonTitle: "OK");
          }

          return responseJson;
        }
        if (responseJson["status"] == 3) {
          await showCommonDialogWithSingleOption(Globals.context, message,
              positiveButtonTitle: "OK");

          return responseJson;
        }
        if (responseJson is Map<String, dynamic>) {
          throw ErrorResponseException(responseJson, message);
        }
        throw ErrorResponseException(null, message);
      case 400:
        var responseJson = json.decode(response.body);
        final message = responseJson["message"];
        throw BadRequestException(message.toString());
      case 401:
        var responseJson = json.decode(response.body);
        final message = responseJson["message"];
        throw UnauthorisedException(message.toString());
      case 403:
        var responseJson = json.decode(response.body);
        final message = responseJson["message"];
        throw UnauthorisedException(message.toString());
      case 404:
        var responseJson = json.decode(response.body);
        final message = responseJson["message"];
        throw NotFoundException(message.toString());
      case 500:
        var responseJson = json.decode(response.body);
        final message = responseJson["message"];
        throw ServerErrorException(message.toString());
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

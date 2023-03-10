import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/models/common/globals.dart';
import 'package:app/utils/date_time_extensions.dart';
import 'package:app/utils/general_utils.dart';
import 'package:app/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'custom_exception.dart';
import 'error_response_exception.dart';

class ApiClient {
  ///set apis' base url here

  static var BASE_URL = "http://122.169.111.101:108/";
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
      responseJson = await _responseLogin(response);
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

  Future<dynamic> apiCallPostforMultipleJSONArray(
    String url,
    dynamic jsontemparray, {
    /*String baseUrl = BASE_URL,*/
    bool showSuccessDialog = false,
    //dynamic jsontemparray,
  }) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Headers - $headers");
    String asd = json.encode(jsontemparray);
    log("Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $asd" +
        json.encode(jsontemparray));
    /*print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $asd" +
            json.encode(jsontemparray));*/
    try {
      final response = await httpClient
          .post(Uri.parse("$BASE_URL$url"),
              headers: headers,
              body: (jsontemparray == null) ? null : json.encode(jsontemparray))
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

  ///POST api call with multipart and multiple image

  Future<dynamic> apiCallPostMultipart(
      String url, Map<String, dynamic> requestJsonMap,
      {List<File> imageFilesToUpload,
      /*String baseUrl = BASE_URL,*/
      String imageFieldKey = "image",
      bool showSuccessDialog: false}) async {
    var responseJson;
    print("$BASE_URL$url\n$requestJsonMap");
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (!imageFilesToUpload[0].existsSync()) {
      print("file not exist");
    }

    print(
        "Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $requestJsonMap");

    final request = http.MultipartRequest("POST", Uri.parse("$BASE_URL$url"));
    if (requestJsonMap != null) {
      request.fields.addAll(requestJsonMap);
    }
    request.headers.addAll(headers);

    if (imageFilesToUpload != null) {
      imageFilesToUpload.forEach((element) async {
        if (element != null) {
          var pic =
              await http.MultipartFile.fromPath(imageFieldKey, element.path);
          request.files.add(pic);
        }
      });
    }
    //upload kro?

    try {
      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson =
          await _responseLogin(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  /*Future<dynamic> apiCallPostMultipart(
      String url, Map<String, dynamic> requestJsonMap,
      {List<File> imageFilesToUpload,
        String baseUrl = BASE_URL,
        String imageFieldKey = "image",
        bool showSuccessDialog: false}) async {
    var responseJson;
    print("$baseUrl$url\n$requestJsonMap");
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',

    };

    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap");

    final request = http.MultipartRequest("POST", Uri.parse("$baseUrl$url"));
    if (requestJsonMap != null) {
      request.fields.addAll(requestJsonMap);
    }
    request.headers.addAll(headers);

    if (imageFilesToUpload != null) {
      imageFilesToUpload.forEach((element) async {
        if (element != null) {
          var pic =
          await http.MultipartFile.fromPath(imageFieldKey, element.path);
          request.files.add(pic);
        }
      });

    }

    try {
      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson =
      await _responseLogin(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }*/

  ///POST api call pagination
  Future<dynamic> apiCallPostPagination(
    String url,
    String query,
    Map<String, dynamic> requestJsonMap, {
    bool showSuccessDialog = false,
  }) async {
    var responseJson;
    var geturl;

    if (query.isNotEmpty) {
      geturl = '$BASE_URL$url/$query-10';
    } else {
      geturl = '$BASE_URL$url/0-10';
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Headers - $headers");
    print(
        "Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $requestJsonMap");
    try {
      final response = await httpClient
          .post(Uri.parse("$geturl"),
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

  /// Post api for Login_USer Details
  Future<dynamic> apiCallLoginUSerPost(
    String url,
    Map<String, dynamic> requestJsonMap, {
    bool showSuccessDialog = false,
  }) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Headers - $headers");
    print(
        "Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $requestJsonMap");
    try {
      final response = await httpClient
          .post(Uri.parse("$BASE_URL$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));

      responseJson = response;
      await _responseLogin(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  /// Post api for Login_USer Details
  Future<dynamic> apiCallCustomerPaginationPost(
    String url,
    Map<String, dynamic> requestJsonMap, {
    bool showSuccessDialog = false,
  }) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print("Headers - $headers");
    print(
        "Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $requestJsonMap");
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

  ///PUT api call with multipart and single image
  Future<dynamic> apiCallPutMultipart(
      String url, Map<String, String> requestJsonMap,
      {File imageFileToUpload}) async {
    var responseJson;
    print("$BASE_URL$url\n$requestJsonMap");
    Map<String, String> headers = {};
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
    print(
        "Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $requestJsonMap");

    final request = http.MultipartRequest("PUT", Uri.parse("$BASE_URL$url"));
    request.fields.addAll(requestJsonMap);
    request.headers.addAll(headers);

    if (imageFileToUpload != null) {
      var pic =
          await http.MultipartFile.fromPath("image", imageFileToUpload.path);
      request.files.add(pic);
    }

    try {
      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson = await _response(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  ///PUT api call with multipart and single image
  ///AWS api call
  Future<void> awsApiCallPut(
    String url,
    Map<String, String> requestJsonMap, {
    @required File imageFileToUpload,
  }) async {
    print("$url\n$requestJsonMap");
    print("Api request url : $url\nApi request params : $requestJsonMap");
    try {
      Uint8List bytes = imageFileToUpload.readAsBytesSync();

      var responseJson = await http.put(Uri.parse(url), body: bytes, headers: {
        "Content-Type":
            "image/${path.extension(imageFileToUpload.path).substring(1)}"
      });
      if (responseJson.statusCode == 200) {
        //uploaded successfully
        print("Response - ${responseJson.body}");
      } else {
        //uploading failed
        throw BadRequestException(
            "Uploading file operation failed, please try again later");
      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    } catch (e) {
      print("exception e - $e");
      throw e;
    }
  }

  /*  Future<dynamic> apiCallPostMultipart(
      String url, Map<String, String> requestJsonMap,
      {List<File> imageFilesToUpload,
        String baseUrl = BASE_URL,
        String imageFieldKey = "image",
        bool showSuccessDialog: false}) async {
    var responseJson;
    print("$baseUrl$url\n$requestJsonMap");
    Map<String, String> headers = {};
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
    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap");

    final request = http.MultipartRequest("POST", Uri.parse("$baseUrl$url"));
    if (requestJsonMap != null) {
      request.fields.addAll(requestJsonMap);
    }
    request.headers.addAll(headers);

    if (imageFilesToUpload != null) {
      imageFilesToUpload.forEach((element) async {
        if (element != null) {
          var pic =
          await http.MultipartFile.fromPath(imageFieldKey, element.path);
          request.files.add(pic);
        }
      });
    }

    try {
      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson =
      await _responseLogin(response, showSuccessDialog: showSuccessDialog);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }*/

  ///PUT api call
  Future<dynamic> apiCallPut(String url, Map<String, dynamic> requestJsonMap,
      {bool showSuccessDialog = false}) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
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

    print(
        "Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $requestJsonMap");
    try {
      final response = await httpClient
          .put(Uri.parse("$BASE_URL$url"),
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

  ///DELETE api call
  Future<dynamic> apiCallDelete(String url, Map<String, dynamic> requestJsonMap,
      {bool showSuccessDialog = false}) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    String authToken =
        SharedPrefHelper.instance.getString(SharedPrefHelper.AUTH_TOKEN_STRING);
    if (authToken != null && authToken.isNotEmpty) {
      headers['access-token'] = "$authToken";
    }
    print("$BASE_URL$url");

    try {
      String timeZone = await getCurrentTimeZone();
      if (timeZone != null && timeZone.isNotEmpty) {
        headers['timeZone'] = timeZone;
      }
    } catch (e) {}
    print(
        "Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $requestJsonMap");

    try {
      final response = await httpClient
          .delete(Uri.parse("$BASE_URL$url"),
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

  ///handling whole response
  ///decrypts response and checks for all status code error
  ///returns "data" object response if status is success

  Future<dynamic> _response(http.Response response,
      {bool showSuccessDialog = false}) async {
    log("Api response\n${response.body}");
    print("Api response\n${response.body}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        final data = responseJson["Data"];
        final message =
            responseJson["Message"] == null ? "" : responseJson["Message"];

        if (responseJson["Status"] == 1) {
          if (showSuccessDialog) {
            await showCommonDialogWithSingleOption(Globals.context, message,
                positiveButtonTitle: "OK");
          }

          return data;
        }
        if (responseJson["Status"] == 2) {
          if (showSuccessDialog) {
            await showCommonDialogWithSingleOption(Globals.context, message,
                positiveButtonTitle: "OK");
          }

          return data;
        }
        if (responseJson["Status"] == 3) {
          await showCommonDialogWithSingleOption(Globals.context, message,
              positiveButtonTitle: "OK");

          return data;
        }
        if (data is Map<String, dynamic>) {
          throw ErrorResponseException(data, message);
        }
        throw ErrorResponseException(null, message);
      case 400:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw BadRequestException(message.toString());
      case 401:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw UnauthorisedException(message.toString());
      case 403:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw UnauthorisedException(message.toString());
      case 404:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw NotFoundException(message.toString());
      case 500:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw ServerErrorException(message.toString());
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<dynamic> _responseLogin(http.Response response,
      {bool showSuccessDialog = false}) async {
    debugPrint("Api response\n${response.body}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);

        return responseJson;

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

  Future<dynamic> _responseImage(http.Response response,
      {bool showSuccessDialog = false}) async {
    debugPrint("Api response\n${response.body}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        //final data = responseJson["details"];
        // final message = responseJson["Message"];

        /* if (responseJson["Status"] == 1) {
          if (showSuccessDialog) {
            await showCommonDialogWithSingleOption(Globals.context, message,
                positiveButtonTitle: "OK");
          }

          return data;
        }
        if (responseJson["Status"] == 2) {
          if (showSuccessDialog) {
            await showCommonDialogWithSingleOption(Globals.context, message,
                positiveButtonTitle: "OK");
          }

          return data;
        }*/
        return responseJson;
      /* if (data is Map<String, dynamic>) {
          throw ErrorResponseException(data, message);
        }
        throw ErrorResponseException(null, message);*/
      case 400:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw BadRequestException(message.toString());
      case 401:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw UnauthorisedException(message.toString());
      case 403:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw UnauthorisedException(message.toString());
      case 404:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw NotFoundException(message.toString());
      case 500:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        throw ServerErrorException(message.toString());
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<dynamic> apiCallGoogleGetDistance(String url,
      {String origins = "", String destinations = "", String key = ""}) async {
    var responseJson;
    var getUrl;

    if (origins.isNotEmpty) {
      getUrl = '$url?origins=$origins&destinations=$destinations&key=$key';
    } else {
      getUrl = '$url';
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
      responseJson = await _responseGoogle(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> apiCallGoogleGetLocationAddress(String url,
      {String latlng = "", String key = ""}) async {
    var responseJson;
    var getUrl;

    if (latlng.isNotEmpty) {
      getUrl = '$url?key=$key&latlng=$latlng';
    } else {
      getUrl = '$url';
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
      responseJson = await _responseGoogle(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> apiCallGoogleGet(String url,
      {String query = "", String key = ""}) async {
    var responseJson;
    var getUrl;

    if (query.isNotEmpty) {
      getUrl = '$url?query=$query&key=$key';
    } else {
      getUrl = '$url';
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
      responseJson = await _responseGoogle(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> api_call_fcm_notification(
    String url,
    Map<String, dynamic> requestJsonMap, {
    String baseUrl = "https://fcm.googleapis.com",
    bool showSuccessDialog = false,
    //dynamic jsontemparray,
  }) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization":
          "key =AAAA6_2q1Os:APA91bEmKXQUpXDgMIvRlTJSnWe6eesYX3qmmHFL5d9D74NN_t5UetJD0TH8Ft58p6vqqLJB-VMMPlbt4ZI7FiAR_QMMhAGjLhowt913GfB027K4vOsgntD9RztvGK0yv138bdoNTZaL",
    };
    print("Headers - $headers");
    //String asd = json.encode(jsontemparray);
    print(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap" /*+ "JSON Array $asd"*/);
    try {
      final response = await httpClient
          .post(Uri.parse("$baseUrl$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));

      responseJson = await _responseGoogle(response);
      //await _response(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  Future<dynamic> _responseGoogle(http.Response response,
      {bool showSuccessDialog = false}) async {
    debugPrint("Api response\n${response.body}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        final data = responseJson; //["results"];
        //final message = responseJson["Message"];

        return data;

        if (data is Map<String, dynamic>) {
          throw ErrorResponseException(data, "RetriveDataSucess");
        }
        throw ErrorResponseException(null, "RetriveDataFail");
      case 400:
        var responseJson = json.decode(response.body);
        final message =
            "RetriveDataFail With Status Code 400"; //responseJson["Message"];
        throw BadRequestException(message.toString());
      case 401:
        var responseJson = json.decode(response.body);
        final message =
            "RetriveDataFail With Status Code 401"; //responseJson["Message"];
        throw UnauthorisedException(message.toString());
      case 403:
        var responseJson = json.decode(response.body);
        final message =
            "RetriveDataFail With Status Code 403"; //responseJson["Message"];
        throw UnauthorisedException(message.toString());
      case 404:
        var responseJson = json.decode(response.body);
        final message =
            "RetriveDataFail With Status Code 404"; //responseJson["Message"];
        throw NotFoundException(message.toString());
      case 500:
        var responseJson = json.decode(response.body);
        final message =
            "RetriveDataFail With Status Code 500"; //responseJson["Message"];
        throw ServerErrorException(message.toString());
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<String> apiwebMethodCallGet(String url) async {
    // var responseJson;
    var responseJson;
    var getUrl;

    if (url.isNotEmpty) {
      getUrl = '$url';
    } else {
      getUrl = '$url';
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
      final response = await httpClient.get(Uri.parse(url));
      var document = parse(response.body);
      print("HTMResponse" + document.body.localName);
      return "Web method Sucess"; //document.body.localName;

      /*if (response.statusCode == 200) {
        var document = parse(response.body);
        print("HTMResponse" + document.body.localName);
        return "Web method Sucess"; //document.body.localName;
      } else {
        return "Something Went Wrong";
      }*/
      // responseJson = await _response(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (error, stacktrace) {
      print(stacktrace);
      //print("tetssdg" + error);
    }
    // return responseJson;
  }

  Future<dynamic> getUrlLocation(String url) async {
    final client = HttpClient();
    var uri = Uri.parse(url);
    var request = await client.getUrl(uri);
    request.followRedirects = false;
    var response = await request.close();

    while (response.isRedirect) {
      response.drain();
      final location = response.headers.value(HttpHeaders.locationHeader);
      if (location != null) {
        uri = uri.resolve(location);
        request = await client.getUrl(uri);
        // Set the body or headers as desired.
        request.followRedirects = false;
        response = await request.close();
        return response.statusCode;
      }
    }

    /*if (response.statusCode == 200) {
      var document = parse(response.toString());
      print("HTMResponse" + document.body.localName);
      return response.toString(); //document.body.localName;
    } else {
      return "Something Went Wrong";
    }*/

    // return response.headers.value(HttpHeaders.locationHeader);
  }
}

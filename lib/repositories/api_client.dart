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


  static var BASE_URL_FOR_COLORADO = "https://admin.appcoloworkcomp.com/api/";






  ///add end point of your apis as below


  static const END_POINT_ABOUT_US = 'aboutUs';
  static const END_POINT_CONTACT_US = 'contactUs';
  static const END_POINT_VIEW_RECENT_CASES = 'view_recent_cases';
  static const END_POINT_VIEW_NOTIFICATION_LIST = 'notificationLIst';
  static const END_POINT_VIEW_NOTIFICATION_ACTIVATE = 'notifications';

  static const END_POINT_MAX_BENIFIT = 'max_rates';

  //view_recent_cases
  //DailyAttendanceMode/0/Save
  final http.Client httpClient;

  ApiClient({this.httpClient});


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

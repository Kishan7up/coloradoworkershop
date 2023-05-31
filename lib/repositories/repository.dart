import 'package:app/models/api_request/about_us/about_us_request.dart';
import 'package:app/models/api_request/contact_us/contact_us_request.dart';
import 'package:app/models/api_request/max_benifit/max_benifit_request.dart';
import 'package:app/models/api_request/notification/notification_activate_request.dart';
import 'package:app/models/api_request/notification/notification_list_request.dart';

import 'package:app/models/api_request/view_recent_cases/view_recent_cases_request.dart';
import 'package:app/models/api_response/about_Us/about_us_response.dart';
import 'package:app/models/api_response/contact_Us/contact_us_response.dart';

import 'package:app/models/api_response/max_benifit/max_benifit_response.dart';
import 'package:app/models/api_response/notification/notification_activate_response.dart';
import 'package:app/models/api_response/notification/notification_list_response.dart';

import 'package:app/models/api_response/view_recent_cases/view_recent_cases_response.dart';
import 'package:app/repositories/error_response_exception.dart';
import 'package:app/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_client.dart';

// will be user for user related api calling and data processing
class Repository {
  SharedPrefHelper prefs = SharedPrefHelper.instance;
  final ApiClient apiClient;

  Repository({@required this.apiClient});

  static Repository getInstance() {
    return Repository(apiClient: ApiClient(httpClient: http.Client()));
  }

  ///add your functions of api calls as below



  Future<AboutUsResponse> aboutUsAPI(AboutUsRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ABOUT_US, request.toJson());
      AboutUsResponse response = AboutUsResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ContactUsResponse> contactUsAPI(ContactUsRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CONTACT_US, request.toJson());

      print("APIRESPONSE" + json.toString());
      ContactUsResponse response = ContactUsResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<NotificationListResponse> notificationAPI(
      NotificationListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_VIEW_NOTIFICATION_LIST, request.toJson());

      print("APIRESPONSE" + json.toString());
      NotificationListResponse response =
          NotificationListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<NotificationActivateResponse> notificationActivateAPI(
      NotificationActivateRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_VIEW_NOTIFICATION_ACTIVATE, request.toJson());

      print("APIRESPONSE" + json.toString());
      NotificationActivateResponse response =
          NotificationActivateResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaxBenifitResponse> max_benifit_api(MaxBenifitRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MAX_BENIFIT, request.toJson());

      print("APIRESPONSE" + json.toString());
      MaxBenifitResponse response = MaxBenifitResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ViewRecentCasesResponse> viewRecentCasesAPI(
      ViewRecentCasesRequest request) async {
    try {
      ///ApiClient.END_POINT_CONTACT_US ma End_Point Decalre karvanu baki che e kari dejo
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_VIEW_RECENT_CASES, request.toJson());

      print("sdffAPIResponse" + json.toString());

      ViewRecentCasesResponse response = ViewRecentCasesResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }
}

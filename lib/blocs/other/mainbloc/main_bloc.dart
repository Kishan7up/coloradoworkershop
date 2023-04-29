import 'package:app/blocs/base/base_bloc.dart';
import 'package:app/models/DB_Models/recent_view_list_db_tabel.dart';
import 'package:app/models/api_request/about_us/about_us_request.dart';
import 'package:app/models/api_request/contact_us/contact_us_request.dart';
import 'package:app/models/api_request/customer/customer_paggination_request.dart';
import 'package:app/models/api_request/notification/notification_list_request.dart';
import 'package:app/models/api_request/view_recent_cases/view_recent_cases_request.dart';
import 'package:app/models/api_response/about_Us/about_us_response.dart';
import 'package:app/models/api_response/contact_Us/contact_us_response.dart';
import 'package:app/models/api_response/customer/customer_details_api_response.dart';
import 'package:app/models/api_response/notification/notification_list_response.dart';
import 'package:app/models/api_response/view_recent_cases/view_recent_cases_response.dart';
import 'package:app/repositories/repository.dart';
import 'package:app/utils/offline_db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  MainBloc(this.baseBloc) : super(MainInitialState());

  @override
  Stream<MainStates> mapEventToState(MainEvent event) async* {
    /// sets state based on events
    /*if (event is CustomerPaginationRequestEvent) {
      yield* _mapRecent_view_listEventToState(event);
    }*/

    /*if (event is RecentViewEvent) {
      yield* mapRecentViewEventStateDB(event);
    }*/

    if (event is RecentViewRetriveEvent) {
      yield* _mapRecentViewRetriveEventToState(event);
    }

    if (event is SearchRecentViewRetriveEvent) {
      yield* _mapSearchRecentViewRetriveEventToState(event);
    }

    if (event is AboutUsRequestEvent) {
      yield* _mapAboutUsRequestEventToState(event);
    }
    if (event is ContactUsRequestEvent) {
      yield* _mapContactUsRequestEventToState(event);
    }

    if (event is ViewRecentCasesRequestEvent) {
      yield* _mapViewRecentCasesRequestEventToState(event);
    }

    if (event is NotificationListRequestEvent) {
      yield* _mapNotificationListRequestEventToState(event);
    }
    //
  }

  ///event functions to states implementation
  /* Stream<MainStates> _mapRecent_view_listEventToState(
      CustomerPaginationRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerDetailsResponse arrrecent = await userRepository
          .getrecentviewapi(event.customerPaginationRequest);



      yield CustomerDetailsResponseState(arrrecent);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }*/

/*  Stream<MainStates> mapRecentViewEventStateDB(RecentViewEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().insertRecentViewDBTable(
          RecentViewDBTable(event.recentViewDBTable.CustomerID,
              event.recentViewDBTable.CustomerName));

      yield RecentViewState("Added SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }*/

  Stream<MainStates> _mapRecentViewRetriveEventToState(
      RecentViewRetriveEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      List<RecentViewDBTable> quotationOtherChargesListResponse =
          await OfflineDbHelper.getInstance().getRecentViewDBTable();

      yield RecentViewRetriveState(quotationOtherChargesListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSearchRecentViewRetriveEventToState(
      SearchRecentViewRetriveEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      List<RecentViewDBTable> quotationOtherChargesListResponse =
          await OfflineDbHelper.getInstance().getSearchRecentViewDBTable(
              event.searchkeyword, event.dropdownItem);

      yield SearchRecentViewRetriveState(quotationOtherChargesListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapAboutUsRequestEventToState(
      AboutUsRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      AboutUsResponse arrrecent =
          await userRepository.aboutUsAPI(event.aboutUsRequest);

      yield AboutUsResponseState(arrrecent);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapContactUsRequestEventToState(
      ContactUsRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ContactUsResponse response =
          await userRepository.contactUsAPI(event.contactUsRequest);

      yield ContactUsResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapViewRecentCasesRequestEventToState(
      ViewRecentCasesRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ViewRecentCasesResponse response =
          await userRepository.viewRecentCasesAPI(event.viewRecentCasesRequest);

      await OfflineDbHelper.getInstance().deleteALLRecentViewDBTable();
      for (int i = 0; i < response.data.details.length; i++) {
        await OfflineDbHelper.getInstance()
            .insertRecentViewDBTable(RecentViewDBTable(
          response.data.details[i].title,
          response.data.details[i].caseNo.toString(),
          response.data.details[i].caseDetailShort,
          response.data.details[i].caseDetailLong,
          response.data.details[i].filter,
          response.data.details[i].link,
        ));
      }

      yield ViewRecentCasesResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapNotificationListRequestEventToState(
      NotificationListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      NotificationListResponse response =
          await userRepository.notificationAPI(event.notificationListRequest);

      yield NotificationListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}

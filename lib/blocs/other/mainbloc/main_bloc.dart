import 'package:app/blocs/base/base_bloc.dart';
import 'package:app/models/DB_Models/recent_view_list_db_tabel.dart';
import 'package:app/models/api_request/customer/customer_paggination_request.dart';
import 'package:app/models/api_response/customer/customer_details_api_response.dart';
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
    if (event is CustomerPaginationRequestEvent) {
      yield* _mapRecent_view_listEventToState(event);
    }

    if (event is RecentViewEvent) {
      yield* mapRecentViewEventStateDB(event);
    }

    if (event is RecentViewRetriveEvent) {
      yield* _mapRecentViewRetriveEventToState(event);
    }

    if (event is SearchRecentViewRetriveEvent) {
      yield* _mapSearchRecentViewRetriveEventToState(event);
    }

    //
  }

  ///event functions to states implementation
  Stream<MainStates> _mapRecent_view_listEventToState(
      CustomerPaginationRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerDetailsResponse arrrecent = await userRepository
          .getrecentviewapi(event.customerPaginationRequest);

      /* for(int i=0;i<arrrecent.details.length;i++){
        await OfflineDbHelper.getInstance()
            .insertRecentViewDBTable(RecentViewDBTable(
            arrrecent.details[i].customerID.toString(),
            arrrecent.details[i].customerName
        ));
      }*/

      yield CustomerDetailsResponseState(arrrecent);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> mapRecentViewEventStateDB(RecentViewEvent event) async* {
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
  }

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
}

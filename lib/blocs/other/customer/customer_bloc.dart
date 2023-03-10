import 'dart:io';

import 'package:app/blocs/base/base_bloc.dart';
import 'package:app/models/api_request/customer/customer_add_edit_api_request.dart';
import 'package:app/models/api_request/customer/customer_category_request.dart';
import 'package:app/models/api_request/customer/customer_delete_document_request.dart';
import 'package:app/models/api_request/customer/customer_delete_request.dart';
import 'package:app/models/api_request/customer/customer_fetch_document_api_request.dart';
import 'package:app/models/api_request/customer/customer_id_to_contact_list_request.dart';
import 'package:app/models/api_request/customer/customer_id_to_delete_all_contacts_request.dart';
import 'package:app/models/api_request/customer/customer_label_value_request.dart';
import 'package:app/models/api_request/customer/customer_paggination_request.dart';
import 'package:app/models/api_request/customer/customer_search_by_id_request.dart';
import 'package:app/models/api_request/customer/customer_source_list_request.dart';
import 'package:app/models/api_request/customer/customer_upload_document_api_request.dart';
import 'package:app/models/api_request/other/city_list_request.dart';
import 'package:app/models/api_request/other/country_list_request.dart';
import 'package:app/models/api_request/other/designation_list_request.dart';
import 'package:app/models/api_request/other/district_list_request.dart';
import 'package:app/models/api_request/other/state_list_request.dart';
import 'package:app/models/api_request/other/taluka_api_request.dart';
import 'package:app/models/api_response/customer/customer_add_edit_response.dart';
import 'package:app/models/api_response/customer/customer_category_list.dart';
import 'package:app/models/api_response/customer/customer_contact_save_response.dart';
import 'package:app/models/api_response/customer/customer_delete_document_response.dart';
import 'package:app/models/api_response/customer/customer_delete_response.dart';
import 'package:app/models/api_response/customer/customer_details_api_response.dart';
import 'package:app/models/api_response/customer/customer_fetch_document_response.dart';
import 'package:app/models/api_response/customer/customer_id_to_contact_list_response.dart';
import 'package:app/models/api_response/customer/customer_id_to_delete_all_contact_response.dart';
import 'package:app/models/api_response/customer/customer_label_value_response.dart';
import 'package:app/models/api_response/customer/customer_source_response.dart';
import 'package:app/models/api_response/customer/customer_upload_document_response.dart';
import 'package:app/models/api_response/other/city_api_response.dart';
import 'package:app/models/api_response/other/country_list_response.dart';
import 'package:app/models/api_response/other/designation_list_response.dart';
import 'package:app/models/api_response/other/district_api_response.dart';
import 'package:app/models/api_response/other/state_list_response.dart';
import 'package:app/models/api_response/other/taluka_api_response.dart';
import 'package:app/models/common/contact_model.dart';
import 'package:app/repositories/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'customer_events.dart';
part 'customer_states.dart';

class CustomerBloc extends Bloc<CustomerEvents, CustomerStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  CustomerBloc(this.baseBloc) : super(CustomerInitialState());

  @override
  Stream<CustomerStates> mapEventToState(CustomerEvents event) async* {
    /// sets state based on events
    if (event is CustomerListCallEvent) {
      yield* _mapCustomerListCallEventToState(event);
    }
    if (event is SearchCustomerListByNameCallEvent) {
      yield* _mapCustomerListByNameCallEventToState(event);
    }
    if (event is SearchCustomerListByNumberCallEvent) {
      yield* _mapSearchCustomerListByNumberCallEventToState(event);
    }

    if (event is CountryCallEvent) {
      yield* _mapCountryListCallEventToState(event);
    }
    if (event is StateCallEvent) {
      yield* _mapStateListCallEventToState(event);
    }

    if (event is CityCallEvent) {
      yield* _mapCityListCallEventToState(event);
    }

    if (event is CustomerAddEditCallEvent) {
      yield* _mapCustomerAddEditCallEventToState(event);
    }
    if (event is CustomerDeleteByNameCallEvent) {
      yield* _mapDeleteCustomerCallEventToState(event);
    }

    if (event is CustomerCategoryCallEvent) {
      yield* _mapCustomerCategoryCallEventToState(event);
    }

    if (event is CustomerSourceCallEvent) {
      yield* _mapCustomerSourceCallEventToState(event);
    }

    //
  }

  ///event functions to states implementation
  Stream<CustomerStates> _mapCustomerListCallEventToState(
      CustomerListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerDetailsResponse response = await userRepository.getCustomerList(
          event.pageNo, event.customerPaginationRequest);
      yield CustomerListCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapSearchCustomerListByNumberCallEventToState(
      SearchCustomerListByNumberCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerDetailsResponse response =
          await userRepository.getCustomerListSearchByNumber(event.request);
      yield SearchCustomerListByNumberCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCustomerListByNameCallEventToState(
      SearchCustomerListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerLabelvalueRsponse response =
          await userRepository.getCustomerListSearchByName(event.request);
      yield CustomerListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCustomerCategoryCallEventToState(
      CustomerCategoryCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerCategoryResponse respo =
          await userRepository.customer_Category_List_call(event.request1);
      yield CustomerCategoryCallEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCountryListCallEventToState(
      CountryCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CountryListResponse respo =
          await userRepository.country_list_call(event.countryListRequest);
      yield CountryListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapStateListCallEventToState(
      StateCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      StateListResponse respo =
          await userRepository.state_list_call(event.stateListRequest);
      yield StateListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCityListCallEventToState(
      CityCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CityApiRespose respo =
          await userRepository.city_list_details(event.cityApiRequest);
      yield CityListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCustomerAddEditCallEventToState(
      CustomerAddEditCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerAddEditApiResponse respo = await userRepository
          .customer_add_edit_details(event.customerAddEditApiRequest);
      yield CustomerAddEditEventResponseState(event.context, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapDeleteCustomerCallEventToState(
      CustomerDeleteByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerDeleteResponse customerDeleteResponse = await userRepository
          .deleteCustomer(event.pkID, event.customerDeleteRequest);
      yield CustomerDeleteCallResponseState(customerDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCustomerSourceCallEventToState(
      CustomerSourceCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerSourceResponse respo =
          await userRepository.customer_Source_List_call(event.request1);
      yield CustomerSourceCallEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}

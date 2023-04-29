part of 'main_bloc.dart';

abstract class MainStates extends BaseStates {
  const MainStates();
}

///all states of AuthenticationStates
class MainInitialState extends MainStates {}

class CustomerDetailsResponseState extends MainStates {
  CustomerDetailsResponse response;
  CustomerDetailsResponseState(this.response);
}

class RecentViewState extends MainStates {
  String response;
  RecentViewState(this.response);
}

class RecentViewRetriveState extends MainStates {
  final List<RecentViewDBTable> recentViewDBTable;

  RecentViewRetriveState(this.recentViewDBTable);
}

class SearchRecentViewRetriveState extends MainStates {
  final List<RecentViewDBTable> recentViewDBTable;

  SearchRecentViewRetriveState(this.recentViewDBTable);
}

class ContactUsResponseState extends MainStates {
  final ContactUsResponse contactUsResponse;

  ContactUsResponseState(this.contactUsResponse);
}

class AboutUsResponseState extends MainStates {
  final AboutUsResponse aboutUsResponse;

  AboutUsResponseState(this.aboutUsResponse);
}

//ViewRecentCasesResponse
class ViewRecentCasesResponseState extends MainStates {
  final ViewRecentCasesResponse viewRecentCasesResponse;

  ViewRecentCasesResponseState(this.viewRecentCasesResponse);
}
//NotificationListResponse

class NotificationListResponseState extends MainStates {
  final NotificationListResponse notificationListResponse;

  NotificationListResponseState(this.notificationListResponse);
}

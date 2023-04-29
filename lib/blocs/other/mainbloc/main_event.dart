part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

///all events of AuthenticationEvents
class CustomerPaginationRequestEvent extends MainEvent {
  CustomerPaginationRequest customerPaginationRequest;
  CustomerPaginationRequestEvent(this.customerPaginationRequest);
}

class RecentViewEvent extends MainEvent {
  final RecentViewDBTable recentViewDBTable;

  RecentViewEvent(this.recentViewDBTable);
}

class RecentViewRetriveEvent extends MainEvent {
  RecentViewRetriveEvent();
}

class SearchRecentViewRetriveEvent extends MainEvent {
  String searchkeyword;
  String dropdownItem;

  SearchRecentViewRetriveEvent(this.searchkeyword, this.dropdownItem);
}

//getSearchRecentViewDBTable
class AboutUsRequestEvent extends MainEvent {
  AboutUsRequest aboutUsRequest;

  AboutUsRequestEvent(this.aboutUsRequest);
}

class ContactUsRequestEvent extends MainEvent {
  ContactUsRequest contactUsRequest;

  ContactUsRequestEvent(this.contactUsRequest);
}

class ViewRecentCasesRequestEvent extends MainEvent {
  ViewRecentCasesRequest viewRecentCasesRequest;

  ViewRecentCasesRequestEvent(this.viewRecentCasesRequest);
}

class NotificationListRequestEvent extends MainEvent {
  NotificationListRequest notificationListRequest;

  NotificationListRequestEvent(this.notificationListRequest);
}

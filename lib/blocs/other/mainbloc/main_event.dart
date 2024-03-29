part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

///all events of AuthenticationEvents


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

class NotificationActivateRequestEvent extends MainEvent {
  NotificationActivateRequest notificationActivateRequest;

  NotificationActivateRequestEvent(this.notificationActivateRequest);
}
class NotificationFirstActivateRequestEvent extends MainEvent {
  NotificationActivateRequest notificationActivateRequest;

  NotificationFirstActivateRequestEvent(this.notificationActivateRequest);
}

//

class MaxBenifitRequestEvent extends MainEvent {
  MaxBenifitRequest maxBenifitRequest;

  MaxBenifitRequestEvent(this.maxBenifitRequest);
}


class MaxBenifitDateofInjoryRequestEvent extends MainEvent {
  MaxBenifitRequest maxBenifitRequest;

  MaxBenifitDateofInjoryRequestEvent(this.maxBenifitRequest);
}
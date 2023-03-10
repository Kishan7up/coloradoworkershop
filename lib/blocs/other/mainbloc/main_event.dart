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

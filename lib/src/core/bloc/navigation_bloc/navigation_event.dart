part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class DashboardEvent extends NavigationEvent {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class PofelDetailPageEvent extends NavigationEvent {
  final String pofelId;
  const PofelDetailPageEvent({required this.pofelId});

  @override
  List<Object> get props => [];
}

class LogInPageEvent extends NavigationEvent {
  const LogInPageEvent();

  @override
  List<Object> get props => [];
}

class LoadMyPofelsEvent extends NavigationEvent {
  const LoadMyPofelsEvent();

  @override
  List<Object> get props => [];
}

class LoadCurrentUserPage extends NavigationEvent {
  const LoadCurrentUserPage();

  @override
  List<Object> get props => [];
}

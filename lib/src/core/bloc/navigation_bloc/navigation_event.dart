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

class LogInPageEvent extends NavigationEvent {
  const LogInPageEvent();

  @override
  List<Object> get props => [];
}
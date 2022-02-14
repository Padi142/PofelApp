part of 'navigation_bloc.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationInitial extends NavigationState {}

class ShowDashboardState extends NavigationState {
  const ShowDashboardState();
  @override
  List<Object> get props => [];
}

class ShowPofelDetailState extends NavigationState {
  final String pofelId;
  const ShowPofelDetailState(this.pofelId);
  @override
  List<Object> get props => [];
}

class ShowLogInPageState extends NavigationState {
  const ShowLogInPageState();
  @override
  List<Object> get props => [];
}

class ShowMyPofelsState extends NavigationState {
  const ShowMyPofelsState();
  @override
  List<Object> get props => [];
}

class ShowUserDetailState extends NavigationState {
  const ShowUserDetailState();
  @override
  List<Object> get props => [];
}

part of 'pofeldetailnavigation_bloc.dart';

abstract class PofelNavigationState extends Equatable {
  const PofelNavigationState();

  @override
  List<Object> get props => [];
}

class PofeldetailnavigationInitial extends PofelNavigationState {}

class ShowPofelInfoState extends PofelNavigationState {
  const ShowPofelInfoState();
  @override
  List<Object> get props => [];
}

class PofelSignedUsersState extends PofelNavigationState {
  const PofelSignedUsersState();
  @override
  List<Object> get props => [];
}

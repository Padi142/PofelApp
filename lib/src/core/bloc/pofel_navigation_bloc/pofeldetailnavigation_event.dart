part of 'pofeldetailnavigation_bloc.dart';

abstract class PofelNavigationEvent extends Equatable {
  const PofelNavigationEvent();

  @override
  List<Object> get props => [];
}

class PofelInfoEvent extends PofelNavigationEvent {
  const PofelInfoEvent();

  @override
  List<Object> get props => [];
}

class PofelSignedUsersEvent extends PofelNavigationEvent {
  const PofelSignedUsersEvent();

  @override
  List<Object> get props => [];
}

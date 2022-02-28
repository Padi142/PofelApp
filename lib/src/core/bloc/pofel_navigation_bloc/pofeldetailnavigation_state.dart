part of 'pofeldetailnavigation_bloc.dart';

abstract class PofelNavigationState extends Equatable {
  const PofelNavigationState();

  @override
  List<Object> get props => [];
}

class PofeldetailnavigationInitial extends PofelNavigationState {}

class ShowPofelInfoState extends PofelNavigationState {
  final String uid;
  const ShowPofelInfoState({required this.uid});
  @override
  List<Object> get props => [];
}

class PofelSignedUsersState extends PofelNavigationState {
  const PofelSignedUsersState();
  @override
  List<Object> get props => [];
}

class PofelSettingsPageState extends PofelNavigationState {
  final bool canAcces;
  const PofelSettingsPageState({required this.canAcces});
  @override
  List<Object> get props => [canAcces];
}

class PofelItemsPageState extends PofelNavigationState {
  const PofelItemsPageState();
  @override
  List<Object> get props => [];
}

class LoadChatPageState extends PofelNavigationState {
  final String uid;
  const LoadChatPageState({required this.uid});
  @override
  List<Object> get props => [];
}

class LoadTodosPageState extends PofelNavigationState {
  const LoadTodosPageState();
  @override
  List<Object> get props => [];
}

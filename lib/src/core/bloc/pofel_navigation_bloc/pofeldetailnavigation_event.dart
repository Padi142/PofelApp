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

class PofelSettingsEvent extends PofelNavigationEvent {
  final String adminUid;
  const PofelSettingsEvent({required this.adminUid});

  @override
  List<Object> get props => [adminUid];
}

class PofelItemsEvent extends PofelNavigationEvent {
  const PofelItemsEvent();

  @override
  List<Object> get props => [];
}

class LoadChatPage extends PofelNavigationEvent {
  const LoadChatPage();

  @override
  List<Object> get props => [];
}

class LoadTodosPage extends PofelNavigationEvent {
  const LoadTodosPage();

  @override
  List<Object> get props => [];
}

class LoadImageGaleryPage extends PofelNavigationEvent {
  const LoadImageGaleryPage();

  @override
  List<Object> get props => [];
}

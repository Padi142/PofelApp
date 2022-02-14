part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoadedState extends UserState {
  UserModel currentUser;
  UserStateEnum userStateEnum;
  UserLoadedState({required this.currentUser, required this.userStateEnum});

  @override
  List<Object> get props => [currentUser, userStateEnum];
}

enum UserStateEnum { NONE, NAME_UPDATED, PHOTO_UPDATED }

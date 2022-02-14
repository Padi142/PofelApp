part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUser extends UserEvent {
  const LoadUser();

  @override
  List<Object> get props => [];
}

class UpdateUserName extends UserEvent {
  final String newName;
  const UpdateUserName({required this.newName});

  @override
  List<Object> get props => [newName];
}

class UpdateUserProfilePic extends UserEvent {
  final XFile newPic;
  const UpdateUserProfilePic({required this.newPic});

  @override
  List<Object> get props => [newPic];
}

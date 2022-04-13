import 'package:equatable/equatable.dart';

abstract class SocialEvent extends Equatable {
  const SocialEvent();

  @override
  List<Object> get props => [];
}

class Follow extends SocialEvent {
  final String userId;
  const Follow({required this.userId});

  @override
  List<Object> get props => [userId];
}

class SearchUsers extends SocialEvent {
  final String query;
  const SearchUsers({required this.query});

  @override
  List<Object> get props => [query];
}

class LoadMyFollowing extends SocialEvent {
  final String uid;
  const LoadMyFollowing({required this.uid});

  @override
  List<Object> get props => [uid];
}

class InviteUser extends SocialEvent {
  final String uid;
  final String pofelId;
  final String pofelName;
  const InviteUser(
      {required this.uid, required this.pofelId, required this.pofelName});

  @override
  List<Object> get props => [uid];
}

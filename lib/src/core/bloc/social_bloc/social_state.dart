import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/models/profile_model.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part "social_state.g.dart";

abstract class SocialState extends Equatable {
  const SocialState();

  @override
  List<Object> get props => [];
}

class SearchProfiles extends SocialState {
  final List<ProfileModel> profiles;

  const SearchProfiles({
    required this.profiles,
  });

  @override
  List<Object> get props => [profiles];
}

@CopyWith()
class MyFollowingState extends SocialState {
  final List<ProfileModel> profiles;
  final InviteEnum inviteEnum;

  const MyFollowingState({
    required this.profiles,
    required this.inviteEnum,
  });

  @override
  List<Object> get props => [profiles, inviteEnum];
}

enum InviteEnum { INVITED, FAILED, NONE }

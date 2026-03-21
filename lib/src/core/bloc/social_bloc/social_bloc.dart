import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_event.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_state.dart';
import 'package:pofel_app/src/core/models/profile_model.dart';
import 'package:pofel_app/src/core/providers/social_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  SocialBloc() : super(const SearchProfiles(profiles: [])) {
    on<Follow>(_onFollow);
    on<SearchUsers>(_onSearchUsers);
    on<LoadMyFollowing>(_onLoadMyFollowing);
    on<InviteUser>(_onInviteUser);
  }
  SocialProvider socialProvider = SocialProvider();
  _onFollow(Follow event, Emitter<SocialState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");

    await socialProvider.follow(uid!, event.userId);
  }

  _onSearchUsers(SearchUsers event, Emitter<SocialState> emit) async {
    List<ProfileModel> profiles = [];
    if (event.query != "" && event.query != " ") {
      profiles = await socialProvider.search(event.query);
    }
    emit(SearchProfiles(profiles: profiles));
  }

  _onLoadMyFollowing(LoadMyFollowing event, Emitter<SocialState> emit) async {
    List<ProfileModel> profiles = await socialProvider.myFollowing(event.uid);

    emit(MyFollowingState(profiles: profiles, inviteEnum: InviteEnum.NONE));
  }

  _onInviteUser(InviteUser event, Emitter<SocialState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    bool canInvite = await socialProvider.isFollowing(uid!, event.uid);
    if (canInvite) {
      await socialProvider.inviteUserToPofel(
        currentUserId: uid!,
        userId: event.uid,
        pofelName: event.pofelName,
        pofelJoinCode: event.pofelId,
      );

      emit(
          (state as MyFollowingState).copyWith(inviteEnum: InviteEnum.INVITED));
    } else {
      emit((state as MyFollowingState).copyWith(inviteEnum: InviteEnum.FAILED));
    }
  }
}

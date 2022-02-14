import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pofel_app/src/core/models/login_models/user.dart';
import 'package:pofel_app/src/core/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUserName>(_onUpdateUser);
    on<UpdateUserProfilePic>(_onUpdateuserProfilePic);
  }
  UserProvider userProvider = UserProvider();
  _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    UserModel user = await userProvider.fetchUserData(uid!);

    emit(UserLoadedState(currentUser: user, userStateEnum: UserStateEnum.NONE));
  }

  _onUpdateUser(UpdateUserName event, Emitter<UserState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    await userProvider.updateUserName(uid!, event.newName);

    UserModel user = await userProvider.fetchUserData(uid);

    emit(UserLoadedState(
        userStateEnum: UserStateEnum.NAME_UPDATED, currentUser: user));
  }

  _onUpdateuserProfilePic(
      UpdateUserProfilePic event, Emitter<UserState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    await userProvider.updateProfilePic(uid!, event.newPic);

    UserModel user = await userProvider.fetchUserData(uid);

    emit(UserLoadedState(
        userStateEnum: UserStateEnum.PHOTO_UPDATED, currentUser: user));
  }
}

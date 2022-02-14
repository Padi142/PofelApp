import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'pofeldetailnavigation_event.dart';
part 'pofeldetailnavigation_state.dart';

class PofelDetailNavigationBloc
    extends Bloc<PofelNavigationEvent, PofelNavigationState> {
  PofelDetailNavigationBloc() : super(PofeldetailnavigationInitial()) {
    on<PofelInfoEvent>(_onLoadDashboard);
    on<PofelSignedUsersEvent>(_onPofelShowSignedUsers);
    on<PofelSettingsEvent>(_onPofelSettingsEvent);
  }
  _onLoadDashboard(
      PofelInfoEvent event, Emitter<PofelNavigationState> emit) async {
    emit(const ShowPofelInfoState());
  }

  _onPofelShowSignedUsers(
      PofelSignedUsersEvent event, Emitter<PofelNavigationState> emit) async {
    emit(const PofelSignedUsersState());
  }

  _onPofelSettingsEvent(
      PofelSettingsEvent event, Emitter<PofelNavigationState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    if (event.adminUid == uid) {
      emit(const PofelSettingsPageState(canAcces: true));
    } else {
      emit(const PofelSettingsPageState(canAcces: false));
    }
  }
}

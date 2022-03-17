import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on<DashboardEvent>(_onLoadDashboard);
    on<PofelDetailPageEvent>(_onLoadPofelDetail);
    on<LoadMyPofelsEvent>(_onLoadMyPofels);
    on<LoadCurrentUserPage>(_onLoadUser);
    on<LoadSearchProfiles>(_onSearchUsers);
    on<LoadNotificationsPage>(_onLoadNotification);
  }
  _onLoadDashboard(DashboardEvent event, Emitter<NavigationState> emit) async {
    emit(const ShowDashboardState());
  }

  _onLoadPofelDetail(
      PofelDetailPageEvent event, Emitter<NavigationState> emit) async {
    emit(ShowPofelDetailState(event.pofelId));
  }

  _onLoadMyPofels(
      LoadMyPofelsEvent event, Emitter<NavigationState> emit) async {
    emit(const ShowMyPofelsState());
  }

  _onLoadUser(LoadCurrentUserPage event, Emitter<NavigationState> emit) async {
    emit(const ShowUserDetailState());
  }

  _onLoadNotification(
      LoadNotificationsPage event, Emitter<NavigationState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");

    emit(ShowNotificationPageState(uid!));
  }

  _onSearchUsers(
      LoadSearchProfiles event, Emitter<NavigationState> emit) async {
    emit(const ShowSearchProfilesState());
  }
}

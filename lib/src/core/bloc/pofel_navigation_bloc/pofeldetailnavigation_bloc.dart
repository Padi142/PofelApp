import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pofeldetailnavigation_event.dart';
part 'pofeldetailnavigation_state.dart';

class PofelDetailNavigationBloc
    extends Bloc<PofelNavigationEvent, PofelNavigationState> {
  PofelDetailNavigationBloc() : super(PofeldetailnavigationInitial()) {
    on<PofelInfoEvent>(_onLoadDashboard);
    on<PofelSignedUsersEvent>(_onPofelShowSignedUsers);
  }
  _onLoadDashboard(
      PofelInfoEvent event, Emitter<PofelNavigationState> emit) async {
    emit(const ShowPofelInfoState());
  }

  _onPofelShowSignedUsers(
      PofelSignedUsersEvent event, Emitter<PofelNavigationState> emit) async {
    emit(const PofelSignedUsersState());
  }
}

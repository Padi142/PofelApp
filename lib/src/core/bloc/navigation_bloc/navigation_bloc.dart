import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on<DashboardEvent>(_onLoadDashboard);
  }
  _onLoadDashboard(DashboardEvent event, Emitter<NavigationState> emit) async {
    emit(const ShowDashboardState());
  }
}

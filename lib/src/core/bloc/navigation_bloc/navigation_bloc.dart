import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on<NavigationEvent>(_onLoadDashboard);
  }
  _onLoadDashboard(NavigationEvent event, Emitter<NavigationState> emit) async {
    emit(const ShowDashboardState());
  }
}

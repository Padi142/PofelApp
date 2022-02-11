import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on<NavigationEvent>(_onLoadDashboard);
    on<LogInPageEvent>(_onLoadLogIn);
  }
  _onLoadDashboard(NavigationEvent event, Emitter<NavigationState> emit) async {
    emit(const ShowDashboardState());
  }

  _onLoadLogIn(NavigationEvent event, Emitter<NavigationState> emit) async {
    emit(const ShowLogInPageState());
  }
}

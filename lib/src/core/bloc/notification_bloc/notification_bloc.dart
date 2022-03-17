import 'package:bloc/bloc.dart';
import 'package:pofel_app/src/core/bloc/notification_bloc/notification_event.dart';
import 'package:pofel_app/src/core/bloc/notification_bloc/notification_state.dart';
import 'package:pofel_app/src/core/providers/notification_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationData()) {
    on<MakeRead>(_onMakeNotificationRead);
  }
  NotificationProvider notificationProvider = NotificationProvider();
  _onMakeNotificationRead(
      MakeRead event, Emitter<NotificationState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");

    notificationProvider.notificationMakeRead(uid!, event.notId);
  }
}

import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class MakeRead extends NotificationEvent {
  final String notId;
  const MakeRead({required this.notId});

  @override
  List<Object> get props => [notId];
}

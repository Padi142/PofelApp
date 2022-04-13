import 'package:equatable/equatable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

@CopyWith()
class NotificationData extends NotificationState {
  const NotificationData();

  @override
  List<Object> get props => [];
}

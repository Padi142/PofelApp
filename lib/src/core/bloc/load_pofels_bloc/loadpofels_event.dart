import 'package:equatable/equatable.dart';

abstract class LoadpofelsEvent extends Equatable {
  const LoadpofelsEvent();

  @override
  List<Object> get props => [];
}

class LoadMyPofels extends LoadpofelsEvent {
  const LoadMyPofels();

  @override
  List<Object> get props => [];
}

class LoadMyPastPofels extends LoadpofelsEvent {
  const LoadMyPastPofels();

  @override
  List<Object> get props => [];
}

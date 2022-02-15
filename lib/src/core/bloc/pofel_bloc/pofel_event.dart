import 'package:equatable/equatable.dart';

abstract class PofelEvent extends Equatable {
  const PofelEvent();

  @override
  List<Object> get props => [];
}

class LoadPofel extends PofelEvent {
  final String pofelId;
  const LoadPofel({required this.pofelId});

  @override
  List<Object> get props => [pofelId];
}

class JoinPofel extends PofelEvent {
  final String joinId;
  const JoinPofel({required this.joinId});

  @override
  List<Object> get props => [joinId];
}

class CreatePofel extends PofelEvent {
  final String pofelName;
  final String pofelDesc;
  final DateTime date;
  const CreatePofel(
      {required this.date, required this.pofelName, required this.pofelDesc});

  @override
  List<Object> get props => [pofelName, date, pofelDesc];
}

class UpdatePofel extends PofelEvent {
  final UpdatePofelEnum updatePofelEnum;
  final String pofelId;
  final String? newName;
  final String? newDesc;
  final DateTime? newDate;
  const UpdatePofel(
      {required this.updatePofelEnum,
      required this.pofelId,
      this.newName,
      this.newDesc,
      this.newDate});

  @override
  List<Object> get props => [updatePofelEnum, pofelId];
}

enum UpdatePofelEnum { UPDATE_NAME, UPDATE_DESC, UPDATE_DATE }

class UpdateWillArrive extends PofelEvent {
  final String pofelId;
  final DateTime newDate;
  const UpdateWillArrive({required this.pofelId, required this.newDate});

  @override
  List<Object> get props => [pofelId, newDate];
}

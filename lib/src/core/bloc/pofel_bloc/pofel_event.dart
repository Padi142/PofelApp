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
  const CreatePofel({required this.pofelName, required this.pofelDesc});

  @override
  List<Object> get props => [pofelName, pofelDesc];
}

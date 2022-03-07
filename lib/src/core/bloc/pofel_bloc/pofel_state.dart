import 'package:equatable/equatable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';

part "pofel_state.g.dart";

abstract class PofelState extends Equatable {
  const PofelState();

  @override
  List<Object> get props => [];
}

@CopyWith()
class PofelStateWithData extends PofelState {
  final PofelModel choosenPofel;
  final PofelStateEnum pofelStateEnum;
  final String? errorMessage;

  PofelStateWithData(
      {required this.choosenPofel,
      required this.pofelStateEnum,
      this.errorMessage});

  @override
  List<Object> get props => [choosenPofel, pofelStateEnum];
}

enum PofelStateEnum {
  INITIAL,
  POFEL_LOADED,
  ERROR_LOADING,
  POFEL_JOINED,
  ERROR_JOINING,
  POFEL_CREATED,
  POFEL_UPDATED,
  WILL_ARIVE_UPDATED,
  NOT_TURNED_ON,
  NOT_TURNED_OFF,
  PERSON_LEFT,
}

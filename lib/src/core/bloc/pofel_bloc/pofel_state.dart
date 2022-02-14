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

  const PofelStateWithData(
      {required this.choosenPofel, required this.pofelStateEnum});

  @override
  List<Object> get props => [choosenPofel, pofelStateEnum];
}

enum PofelStateEnum {
  INITIAL,
  POFEL_LOADED,
  POFEL_JOINED,
  POFEL_CREATED,
  POFEL_UPDATED
}

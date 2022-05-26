import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part "kybl_creation_state.g.dart";

abstract class KyblCreationState extends Equatable {
  const KyblCreationState();

  @override
  List<Object> get props => [];
}

@CopyWith()
class KyblspotCreationData extends KyblCreationState {
  String name;
  String description;
  GeoPoint position;
  creationState mode;
  KyblspotCreationData(
      {required this.name,
      required this.description,
      required this.position,
      required this.mode});
  @override
  List<Object> get props => [name, description, position, mode];
}

enum creationState {
  INITIAL,
  NAME_DESC,
  PHOTO,
  SUCCESFULY_ADDED,
  POSITION_SPECIFIED
}

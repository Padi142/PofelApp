import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class KyblCreationEvent extends Equatable {
  const KyblCreationEvent();

  @override
  List<Object> get props => [];
}

class AddKyblspotName extends KyblCreationEvent {
  String kyblName;
  AddKyblspotName({required this.kyblName});
  @override
  List<Object> get props => [kyblName];
}

class AddKyblspotDesc extends KyblCreationEvent {
  String kyblDesc;
  AddKyblspotDesc({required this.kyblDesc});
  @override
  List<Object> get props => [kyblDesc];
}

class AddKyblspotCoordnates extends KyblCreationEvent {
  final GeoPoint location;
  AddKyblspotCoordnates({required this.location});
  @override
  List<Object> get props => [];
}

class CreateKyblspot extends KyblCreationEvent {
  String name;
  String description;
  GeoPoint position;
  CreateKyblspot(this.name, this.description, this.position);
  @override
  List<Object> get props => [position, description, name];
}

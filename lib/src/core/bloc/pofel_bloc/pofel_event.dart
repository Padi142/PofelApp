import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';

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

class LoadPofelByJoinId extends PofelEvent {
  final String joinId;
  const LoadPofelByJoinId({required this.joinId});

  @override
  List<Object> get props => [joinId];
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

class RemovePerson extends PofelEvent {
  final String pofelId;
  final String uid;
  const RemovePerson({required this.pofelId, required this.uid});

  @override
  List<Object> get props => [uid, pofelId];
}

class ChangeAdmin extends PofelEvent {
  final String pofelId;
  final String uid;
  const ChangeAdmin({required this.pofelId, required this.uid});

  @override
  List<Object> get props => [uid, pofelId];
}

class UpdatePofel extends PofelEvent {
  final UpdatePofelEnum updatePofelEnum;
  final String pofelId;
  final String? newName;
  final String? newDesc;
  final String? newSpotifyLink;
  final GeoPoint? newLocation;
  final DateTime? newDate;
  final bool? showDrugs;
  final bool? isPublic;
  const UpdatePofel(
      {required this.updatePofelEnum,
      required this.pofelId,
      this.newName,
      this.newSpotifyLink,
      this.newLocation,
      this.newDesc,
      this.showDrugs,
      this.isPublic,
      this.newDate});

  @override
  List<Object> get props => [updatePofelEnum, pofelId];
}

enum UpdatePofelEnum {
  UPDATE_NAME,
  UPDATE_DESC,
  UPDATE_DATE,
  UPDATE_SPOTIFY,
  UPDATE_LOCATION,
  UPDATE_SHOW_DRUGS,
  UPDATE_IS_PUBLIC,
  UPGRADE_POFEL
}

class UpdateWillArrive extends PofelEvent {
  final String pofelId;
  final DateTime newDate;
  const UpdateWillArrive({required this.pofelId, required this.newDate});

  @override
  List<Object> get props => [pofelId, newDate];
}

class ChatNotification extends PofelEvent {
  final String pofelId;
  final PofelUserModel user;
  const ChatNotification({required this.pofelId, required this.user});

  @override
  List<Object> get props => [pofelId, user];
}

class DeletePofel extends PofelEvent {
  final String pofelId;
  const DeletePofel({required this.pofelId});

  @override
  List<Object> get props => [pofelId];
}

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:pofel_app/src/core/bloc/kybl_creation_bloc/kybl_creation_event.dart';
import 'package:pofel_app/src/core/bloc/kybl_creation_bloc/kybl_creation_state.dart';
import 'package:pofel_app/src/core/models/kyblspot_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/kyblspots_provider.dart';

class KyblCreationBloc extends Bloc<KyblCreationEvent, KyblCreationState> {
  KyblCreationBloc()
      : super(KyblspotCreationData(
            position: const GeoPoint(0, 0),
            name: "",
            description: "",
            mode: creationState.INITIAL)) {
    on<AddKyblspotName>(_onAddKyblspotName);
    on<AddKyblspotDesc>(_onAddKyblspotDesc);
    on<AddKyblspotCoordnates>(_onAddKyblspotCoordinates);
    on<CreateKyblspot>(_onCreateKyblspot);
  }

  _onAddKyblspotName(
      AddKyblspotName event, Emitter<KyblCreationState> emit) async {
    emit((state as KyblspotCreationData)
        .copyWith(name: event.kyblName, mode: creationState.NAME_DESC));
  }

  _onAddKyblspotDesc(
      AddKyblspotDesc event, Emitter<KyblCreationState> emit) async {
    emit((state as KyblspotCreationData)
        .copyWith(description: event.kyblDesc, mode: creationState.NAME_DESC));
  }

  _onAddKyblspotCoordinates(
      AddKyblspotCoordnates event, Emitter<KyblCreationState> emit) async {
    emit((state as KyblspotCreationData).copyWith(
        position: event.location, mode: creationState.POSITION_SPECIFIED));
  }

  _onCreateKyblspot(
      CreateKyblspot event, Emitter<KyblCreationState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");

    KyblspotsProvider kyblspotsProvider = KyblspotsProvider();
    KyblspotModel model = KyblspotModel(
        name: event.name,
        description: event.description,
        location: event.position,
        createdBy: uid!,
        spotId: "",
        weight: 0,
        rating: 0);

    await kyblspotsProvider.addKyblspot(model);
    emit((state as KyblspotCreationData)
        .copyWith(mode: creationState.SUCCESFULY_ADDED));
    emit((state as KyblspotCreationData).copyWith(
        mode: creationState.INITIAL,
        description: "",
        name: "",
        position: const GeoPoint(0, 0)));
  }
}

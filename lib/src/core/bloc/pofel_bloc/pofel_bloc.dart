import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_event.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_state.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/providers/pofel_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PofelBloc extends Bloc<PofelEvent, PofelState> {
  PofelBloc()
      : super(PofelStateWithData(
            choosenPofel: PofelModel(
                adminUid: '',
                spotifyLink: "",
                createdAt: null,
                description: '',
                joinCode: '',
                name: '',
                pofelId: '',
                signedUsers: const [],
                pofelLocation: const GeoPoint(0, 0)),
            pofelStateEnum: PofelStateEnum.INITIAL)) {
    on<CreatePofel>(_onCreatePofel);
    on<JoinPofel>(_onJoinPofel);
    on<LoadPofel>(_onLoadPofel);
    on<UpdatePofel>(_onUpdatePofel);
    on<UpdateWillArrive>(_onUpdateWillArive);
  }
  PofelProvider pofelApiProvider = PofelProvider();

  _onCreatePofel(CreatePofel event, Emitter<PofelState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    if (uid != null) {
      pofelApiProvider.createPofel(
          event.pofelName, event.pofelDesc, uid, event.date, DateTime.now());
      emit((state as PofelStateWithData)
          .copyWith(pofelStateEnum: PofelStateEnum.POFEL_CREATED));
    }
  }

  _onJoinPofel(JoinPofel event, Emitter<PofelState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    if (uid != null) {
      pofelApiProvider.joinPofel(uid, event.joinId);
      emit((state as PofelStateWithData)
          .copyWith(pofelStateEnum: PofelStateEnum.POFEL_JOINED));
    }
  }

  _onLoadPofel(LoadPofel event, Emitter<PofelState> emit) async {
    PofelModel pofel = await pofelApiProvider.getPofel(event.pofelId);
    emit((state as PofelStateWithData).copyWith(
        pofelStateEnum: PofelStateEnum.POFEL_LOADED, choosenPofel: pofel));
  }

  _onUpdatePofel(UpdatePofel event, Emitter<PofelState> emit) async {
    switch (event.updatePofelEnum) {
      case UpdatePofelEnum.UPDATE_NAME:
        await pofelApiProvider.updateName(event.newName!, event.pofelId);
        break;
      case UpdatePofelEnum.UPDATE_DESC:
        await pofelApiProvider.updateDesc(event.newDesc!, event.pofelId);
        break;
      case UpdatePofelEnum.UPDATE_DATE:
        await pofelApiProvider.updateDatefrom(event.pofelId, event.newDate!);
        break;
      case UpdatePofelEnum.UPDATE_SPOTIFY:
        await pofelApiProvider.updateSpotifyLink(
            event.pofelId, event.newSpotifyLink!);
        break;
      case UpdatePofelEnum.UPDATE_LOCATION:
        await pofelApiProvider.updatePofelLocation(
            event.pofelId, event.newLocation!);
        break;
    }

    emit((state as PofelStateWithData)
        .copyWith(pofelStateEnum: PofelStateEnum.POFEL_UPDATED));
  }

  _onUpdateWillArive(UpdateWillArrive event, Emitter<PofelState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");

    await pofelApiProvider.updateUserArrivalDate(
        event.pofelId, uid, event.newDate);
    emit((state as PofelStateWithData)
        .copyWith(pofelStateEnum: PofelStateEnum.WILL_ARIVE_UPDATED));
  }
}

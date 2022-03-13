import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
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
                showDrugItems: false,
                pofelLocation: const GeoPoint(0, 0),
                isPremium: false,
                photos: const []),
            pofelStateEnum: PofelStateEnum.INITIAL)) {
    on<CreatePofel>(_onCreatePofel);
    on<JoinPofel>(_onJoinPofel);
    on<LoadPofel>(_onLoadPofel);
    on<UpdatePofel>(_onUpdatePofel);
    on<UpdateWillArrive>(_onUpdateWillArive);
    on<LoadPofelByJoinId>(_onLoadPofelByJoinId);
    on<ChatNotification>(_onChangeChatNotPref);
    on<RemovePerson>(_onRemovePerson);
    on<ChangeAdmin>(_onChangeAdmin);
    on<UpgradePofel>(_onUpgradePofel);
  }
  PofelProvider pofelApiProvider = PofelProvider();

  _onCreatePofel(CreatePofel event, Emitter<PofelState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    await FirebaseAnalytics.instance.logEvent(
      name: 'pofel_created',
    );
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
    if (event.joinId.length != 5) {
      emit((state as PofelStateWithData).copyWith(
          pofelStateEnum: PofelStateEnum.ERROR_JOINING,
          errorMessage: "Kratka pozvanka"));
    } else {
      if (uid != null) {
        try {
          String error = await pofelApiProvider.joinPofel(uid, event.joinId);
          if (error == "") {
            emit((state as PofelStateWithData)
                .copyWith(pofelStateEnum: PofelStateEnum.POFEL_JOINED));
            await FirebaseAnalytics.instance.logEvent(
              name: 'pofel_joined',
            );
          } else {
            emit((state as PofelStateWithData).copyWith(
                pofelStateEnum: PofelStateEnum.ERROR_JOINING,
                errorMessage: error));
            await FirebaseAnalytics.instance.logEvent(
              name: 'pofel_join_error',
            );
          }
        } catch (e) {
          emit((state as PofelStateWithData).copyWith(
              pofelStateEnum: PofelStateEnum.ERROR_JOINING,
              errorMessage: "Nepodařilo se připojit"));
          await FirebaseAnalytics.instance.logEvent(
            name: 'pofel_join_error',
          );
          print(e);
        }
      }
    }
    emit((state as PofelStateWithData)
        .copyWith(pofelStateEnum: PofelStateEnum.INITIAL));
  }

  _onLoadPofel(LoadPofel event, Emitter<PofelState> emit) async {
    try {
      PofelModel pofel = await pofelApiProvider.getPofel(event.pofelId);
      emit((state as PofelStateWithData).copyWith(
          pofelStateEnum: PofelStateEnum.POFEL_LOADED, choosenPofel: pofel));
    } catch (e) {
      print(e);
      emit((state as PofelStateWithData).copyWith(
          pofelStateEnum: PofelStateEnum.ERROR_LOADING,
          errorMessage: "Nepodařilo se najit pofel"));
      await FirebaseAnalytics.instance.logEvent(
        name: 'pofel_load_error',
      );
    }
  }

  _onLoadPofelByJoinId(
      LoadPofelByJoinId event, Emitter<PofelState> emit) async {
    try {
      PofelModel pofel = await pofelApiProvider.getPofelByJoinId(event.joinId);
      emit((state as PofelStateWithData).copyWith(
          pofelStateEnum: PofelStateEnum.POFEL_LOADED, choosenPofel: pofel));
    } catch (e) {
      print(e);
      emit((state as PofelStateWithData).copyWith(
          pofelStateEnum: PofelStateEnum.ERROR_LOADING,
          errorMessage: "Nepodařilo se najit pofel"));
      await FirebaseAnalytics.instance.logEvent(
        name: 'pofel_load_error',
      );
    }
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
      case UpdatePofelEnum.UPDATE_SHOW_DRUGS:
        await pofelApiProvider.toggleShowDrug(event.pofelId, event.showDrugs!);
        break;
    }

    emit((state as PofelStateWithData)
        .copyWith(pofelStateEnum: PofelStateEnum.POFEL_UPDATED));
    await FirebaseAnalytics.instance.logEvent(
      name: 'pofel_updated',
    );
  }

  _onUpdateWillArive(UpdateWillArrive event, Emitter<PofelState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");

    await pofelApiProvider.updateUserArrivalDate(
        event.pofelId, uid, event.newDate);
    emit((state as PofelStateWithData)
        .copyWith(pofelStateEnum: PofelStateEnum.WILL_ARIVE_UPDATED));
  }

  _onRemovePerson(RemovePerson event, Emitter<PofelState> emit) async {
    await pofelApiProvider.leavePofel(event.pofelId, event.uid);
    emit((state as PofelStateWithData)
        .copyWith(pofelStateEnum: PofelStateEnum.PERSON_LEFT));
  }

  _onChangeAdmin(ChangeAdmin event, Emitter<PofelState> emit) async {
    await pofelApiProvider.changeAdmin(event.pofelId, event.uid);
    emit((state as PofelStateWithData)
        .copyWith(pofelStateEnum: PofelStateEnum.POFEL_UPDATED));
  }

  _onChangeChatNotPref(ChatNotification event, Emitter<PofelState> emit) async {
    if (event.user.chatNotification) {
      await FirebaseMessaging.instance
          .unsubscribeFromTopic(event.pofelId + "chat");
      emit((state as PofelStateWithData)
          .copyWith(pofelStateEnum: PofelStateEnum.NOT_TURNED_OFF));
    } else {
      await FirebaseMessaging.instance.subscribeToTopic(event.pofelId + "chat");
      emit((state as PofelStateWithData)
          .copyWith(pofelStateEnum: PofelStateEnum.NOT_TURNED_ON));
    }
    emit((state as PofelStateWithData)
        .copyWith(pofelStateEnum: PofelStateEnum.POFEL_LOADED));
  }

  _onUpgradePofel(UpgradePofel event, Emitter<PofelState> emit) async {
    if (event.user.isPremium) {
      await pofelApiProvider.upgradePofel(event.pofelId);

      emit((state as PofelStateWithData)
          .copyWith(pofelStateEnum: PofelStateEnum.POFEL_UPGRADED));
    }
  }
}

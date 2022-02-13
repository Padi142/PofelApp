import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_event.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_state.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/providers/pofel_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PofelBloc extends Bloc<PofelEvent, PofelState> {
  PofelBloc()
      : super(const PofelStateWithData(
            choosenPofel: PofelModel.empty,
            pofelStateEnum: PofelStateEnum.INITIAL)) {
    on<CreatePofel>(_onCreatePofel);
    on<JoinPofel>(_onJoinPofel);
    on<LoadPofel>(_onLoadPofel);
  }
  PofelProvider pofelApiProvider = PofelProvider();

  _onCreatePofel(CreatePofel event, Emitter<PofelState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    if (uid != null) {
      pofelApiProvider.createPofel(event.pofelName, event.pofelDesc, uid,
          DateTime.now(), DateTime.now());
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
}

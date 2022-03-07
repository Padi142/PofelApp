import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_event.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_state.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/pofel_provider.dart';

class LoadpofelsBloc extends Bloc<LoadpofelsEvent, LoadpofelsState> {
  LoadpofelsBloc()
      : super(const LoadPofelsWithData(
            loadPofelStateEnum: LoadPofelsStateEnum.INITIAL, myPofels: [])) {
    on<LoadMyPofels>(_onLoadPofels);
    on<LoadMyPastPofels>(_onLoadPastPofels);
  }
  PofelProvider pofelApiProvider = PofelProvider();

  _onLoadPofels(LoadMyPofels event, Emitter<LoadpofelsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    if (uid != null) {
      List<PofelModel> pofels = await pofelApiProvider.fetchPofels(uid);
      emit((state as LoadPofelsWithData).copyWith(
          myPofels: pofels,
          loadPofelStateEnum: LoadPofelsStateEnum.POFELS_LOADED));
    } else {
      emit((state as LoadPofelsWithData)
          .copyWith(loadPofelStateEnum: LoadPofelsStateEnum.POFELS_EMPTY));
    }
  }

  _onLoadPastPofels(
      LoadMyPastPofels event, Emitter<LoadpofelsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    if (uid != null) {
      List<PofelModel> pofels = await pofelApiProvider.fetchPastPofels(uid);
      emit((state as LoadPofelsWithData).copyWith(
          myPofels: pofels,
          loadPofelStateEnum: LoadPofelsStateEnum.POFELS_LOADED));
    } else {
      emit((state as LoadPofelsWithData)
          .copyWith(loadPofelStateEnum: LoadPofelsStateEnum.POFELS_EMPTY));
    }
  }
}

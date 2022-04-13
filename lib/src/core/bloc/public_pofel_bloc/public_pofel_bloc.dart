import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pofel_app/src/core/bloc/public_pofel_bloc/public_pofel_event.dart';
import 'package:pofel_app/src/core/bloc/public_pofel_bloc/public_pofel_state.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/providers/pofel_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PublicPofelBloc extends Bloc<PublicPofelEvent, PublicPofelState> {
  PublicPofelBloc()
      : super(const PublicPofelsLoaded(
            markers: [], pofels: [], publicPofelEnum: PublicPofelEnum.NONE)) {
    on<LoadPublicPofels>(_onLoadPublicPofels);
  }
  PofelProvider pofelApiProvider = PofelProvider();

  _onLoadPublicPofels(
      LoadPublicPofels event, Emitter<PublicPofelState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");

    List<PofelModel> pofels = await pofelApiProvider.fetchPublicPofels(uid!);
    List<Marker> markers = [];

    for (PofelModel pofel in pofels) {
      Marker marker = Marker(
        width: 70.0,
        height: 70.0,
        point:
            LatLng(pofel.pofelLocation.latitude, pofel.pofelLocation.longitude),
        builder: (ctx) => GestureDetector(
          onTap: () {
            alert(ctx, pofel).show();
          },
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
                children: [
                  AutoSizeText(
                    pofel.name,
                    maxLines: 5,
                    minFontSize: 8,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      );
      markers.add(marker);
    }

    emit((state as PublicPofelsLoaded).copyWith(
        pofels: pofels,
        publicPofelEnum: PublicPofelEnum.LOADED,
        markers: markers));
  }
}

Alert alert(BuildContext context, PofelModel pofel) {
  return Alert(
    context: context,
    type: AlertType.none,
    title: "Pofel",
    content: Column(
      children: [
        Text(pofel.name,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        Text(DateFormat('dd.MM. – kk:mm').format(pofel.dateFrom!),
            style: const TextStyle(
                color: Colors.black,
                fontSize: 21,
                fontWeight: FontWeight.bold)),
        Text("Join code: " + pofel.joinCode,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
      ],
    ),
    buttons: [
      DialogButton(
        child: const Text(
          "Zavřít",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        width: 120,
      )
    ],
  );
}

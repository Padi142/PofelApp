import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_event.dart';
import 'package:pofel_app/src/core/bloc/public_pofel_bloc/public_pofel_event.dart';
import 'package:pofel_app/src/core/bloc/public_pofel_bloc/public_pofel_state.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/public_pofel_model.dart';
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

    List<PublicPofelModel> pofels =
        await pofelApiProvider.fetchPublicPofels(uid!);
    List<Marker> markers = [];

    for (PublicPofelModel pofel in pofels) {
      Marker marker = Marker(
        width: 60.0,
        height: 50.0,
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
                  Text(
                    pofel.name,
                    maxLines: 3,
                    style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        overflow: TextOverflow.fade),
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

Alert alert(BuildContext context, PublicPofelModel pofel) {
  return Alert(
    context: context,
    type: AlertType.none,
    content: Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0066C3),
              Color(0xFF7D00A9),
            ],
          )),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 35, bottom: 35),
        child: Column(
          children: [
            Text(pofel.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    const Text("Join code: ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Container(),
                    ),
                    Text(pofel.joinCode,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    const Text("Datum: ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Container(),
                    ),
                    Text(DateFormat('dd.MM. – kk:mm').format(pofel.dateFrom!),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    const Text("Účastníků: ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Container(),
                    ),
                    Text(pofel.signedUsers.toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    buttons: [
      DialogButton(
        color: Colors.redAccent,
        child: const Text(
          "Zavřít",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        width: 120,
      ),
      DialogButton(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0066C3),
            Color(0xFF7D00A9),
          ],
        ),
        child: const Text(
          "Připojit",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          BlocProvider.of<PofelBloc>(context)
              .add(JoinPofel(joinId: pofel.joinCode));
          Navigator.pop(context);
        },
        width: 120,
      )
    ],
  );
}

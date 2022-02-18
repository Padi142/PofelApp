import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../core/bloc/pofel_bloc/pofel_event.dart';

Widget PofelSettignsPage(BuildContext context, PofelModel pofel) {
  final myController = TextEditingController();

  return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Alert(
                context: context,
                type: AlertType.none,
                title: "Přejmenovat pofel",
                desc: "Zadejte nové jméno",
                content: Column(
                  children: [
                    TextField(
                      controller: myController,
                      decoration: const InputDecoration(),
                    ),
                  ],
                ),
                buttons: [
                  DialogButton(
                    child: const Text(
                      "Přejmenovat",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      BlocProvider.of<PofelBloc>(context).add(UpdatePofel(
                          updatePofelEnum: UpdatePofelEnum.UPDATE_NAME,
                          pofelId: pofel.pofelId,
                          newName: myController.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBarAlert(context, 'Úspěšně přejmenováno'));
                      Navigator.pop(context);
                    },
                    width: 120,
                  )
                ],
              ).show();
            },
            child: const Text("Upravit jméno"),
          ),
          ElevatedButton(
            onPressed: () {
              Alert(
                context: context,
                type: AlertType.none,
                desc: "Zadejte novy popis ",
                content: Column(
                  children: [
                    TextField(
                      maxLines: 6,
                      minLines: 6,
                      controller: myController,
                      decoration: const InputDecoration(),
                    ),
                  ],
                ),
                buttons: [
                  DialogButton(
                    child: const Text(
                      "Upravit",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      BlocProvider.of<PofelBloc>(context).add(UpdatePofel(
                          updatePofelEnum: UpdatePofelEnum.UPDATE_DESC,
                          pofelId: pofel.pofelId,
                          newDesc: myController.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBarAlert(context, 'Úspěšně upraveno'));
                      Navigator.pop(context);
                    },
                    width: 120,
                  )
                ],
              ).show();
            },
            child: const Text("Upravit popis"),
          ),
          ElevatedButton(
            onPressed: () {
              //BlocProvider.of<PofelBloc>(context).add(UpdatePofel());
            },
            child: const Text("Upravit datum"),
          ),
          ElevatedButton(
            onPressed: () {
              Alert(
                context: context,
                type: AlertType.none,
                title: "Spotify",
                desc:
                    "Ukaž ostatním oficiální spotify playlist pofelu! Můžeš vytvořit i kolaborační playlist a nech ostatní vybrat společně hudbu na pofel",
                content: Column(
                  children: [
                    TextField(
                      controller: myController,
                      decoration: const InputDecoration(),
                    ),
                  ],
                ),
                buttons: [
                  DialogButton(
                    child: const Text(
                      "Upravit",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      if (myController.text.contains("spotify")) {
                        BlocProvider.of<PofelBloc>(context).add(UpdatePofel(
                            updatePofelEnum: UpdatePofelEnum.UPDATE_SPOTIFY,
                            pofelId: pofel.pofelId,
                            newSpotifyLink: myController.text));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBarAlert(
                                context, 'Neplatný spotify odkaz...'));
                      }
                      Navigator.pop(context);
                    },
                    width: 120,
                  )
                ],
              ).show();
            },
            child: const Text("Upravit spotify playlist"),
          ),
          ElevatedButton(
            onPressed: () {
              Alert(
                context: context,
                type: AlertType.none,
                title: "Koordináty",
                desc:
                    "Jdi do google map, klikni na kokaci, kde se bude pofel odehrávat. Otevři okno s informacemi o míste. Zkopíruj koordináty ve tvaru: \"49.XXXXXXXX, 15.XXXXXXXX\" a vlož je sem. (sry, jinak to zatím nejde :/ )",
                content: Column(
                  children: [
                    TextField(
                      controller: myController,
                      decoration: const InputDecoration(),
                    ),
                  ],
                ),
                buttons: [
                  DialogButton(
                    child: const Text(
                      "Upravit",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      try {
                        String locationString =
                            myController.text.replaceAll(" ", "");
                        int idx = locationString.indexOf(",");
                        List parts = [
                          locationString.substring(0, idx).trim(),
                          locationString.substring(idx + 1).trim()
                        ];
                        double lat = double.parse(parts[0]);
                        double lng = double.parse(parts[1]);

                        BlocProvider.of<PofelBloc>(context).add(UpdatePofel(
                            updatePofelEnum: UpdatePofelEnum.UPDATE_LOCATION,
                            pofelId: pofel.pofelId,
                            newLocation: GeoPoint(lat, lng)));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBarAlert(context,
                                'nepodařilo se zpracovat koordináty :/'));
                      }
                      Navigator.pop(context);
                    },
                    width: 120,
                  )
                ],
              ).show();
            },
            child: const Text("Upravit lokaci pofelu"),
          ),
        ],
      ));
}

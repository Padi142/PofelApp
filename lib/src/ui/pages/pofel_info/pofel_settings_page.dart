import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../../core/bloc/pofel_bloc/pofel_event.dart';

Widget PofelSettignsPage(BuildContext context, PofelModel pofel) {
  final myController = TextEditingController();
  DateTime pickedDate = DateTime.utc(1989, 11, 9);
  return Padding(
      padding: const EdgeInsets.all(15),
      child: Center(
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
                Alert(
                  context: context,
                  type: AlertType.none,
                  title: "Zadejte nové datum",
                  content: Column(
                    children: [
                      DateTimePicker(
                          type: DateTimePickerType.dateTime,
                          initialValue: '',
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          dateLabelText: 'Datum a čas',
                          onChanged: (val) {
                            pickedDate = DateTime.parse(val);
                          })
                    ],
                  ),
                  buttons: [
                    DialogButton(
                      child: const Text(
                        "Update",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        if (pickedDate != DateTime.utc(1989, 11, 9)) {
                          BlocProvider.of<PofelBloc>(context).add(UpdatePofel(
                              pofelId: pofel.pofelId,
                              updatePofelEnum: UpdatePofelEnum.UPDATE_DATE,
                              newDate: pickedDate));
                          Navigator.pop(context);
                        }
                      },
                      width: 120,
                    )
                  ],
                ).show();
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
                        if (myController.text.contains("spotify") ||
                            myController.text.contains("apple")) {
                          BlocProvider.of<PofelBloc>(context).add(UpdatePofel(
                              updatePofelEnum: UpdatePofelEnum.UPDATE_SPOTIFY,
                              pofelId: pofel.pofelId,
                              newSpotifyLink: myController.text));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBarError(
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
                      "Jdi do google map, klikni na lokaci, kde se bude pofel odehrávat. Otevři okno s informacemi o míste. Zkopíruj koordináty ve tvaru: \"49.XXXXXXXX, 15.XXXXXXXX\" a vlož je sem. (sry, jinak to zatím nejde :/ )",
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
                              SnackBarError(context,
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
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<PofelBloc>(context).add(UpdatePofel(
                    updatePofelEnum: UpdatePofelEnum.UPDATE_SHOW_DRUGS,
                    pofelId: pofel.pofelId,
                    showDrugs: pofel.showDrugItems));
              },
              child: const Text("Zapnout/vypnout substance itemy"),
            ),
            ElevatedButton(
              onPressed: () {
                Alert(
                  context: context,
                  type: AlertType.none,
                  title: "Zpráva",
                  desc: "Pošli ostatním zprávu",
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
                        "Poslat",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBarAlert(context, 'Notifikace poslána'));

                        Navigator.pop(context);
                        var func = FirebaseFunctions.instance
                            .httpsCallable("notifyPofelUsers");
                        await func.call(<String, dynamic>{
                          "messageTitle": "Notifikace z polefu " + pofel.name,
                          "messageBody": myController.text,
                          "pofelId": pofel.pofelId
                        });
                      },
                      width: 120,
                    )
                  ],
                ).show();
              },
              child: const Text("Pošli oznámění účastníkům pofelu"),
            ),
          ],
        ),
      ));
}

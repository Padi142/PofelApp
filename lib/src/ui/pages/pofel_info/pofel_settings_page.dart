import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:pofel_app/src/ui/components/toast_premium_alert.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_set_location_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../core/bloc/pofel_bloc/pofel_event.dart';
import '../../../core/bloc/pofel_navigation_bloc/pofeldetailnavigation_bloc.dart';

Widget PofelSettignsPage(BuildContext context, PofelModel pofel) {
  final myController = TextEditingController();
  DateTime pickedDate = DateTime.utc(1989, 11, 9);
  return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                child: const Text("Zpět"),
                onPressed: () {
                  BlocProvider.of<PofelDetailNavigationBloc>(context)
                      .add(const PofelInfoEvent());
                }),
          ),
          SingleChildScrollView(
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              BlocProvider.of<PofelBloc>(context).add(
                                  UpdatePofel(
                                      updatePofelEnum:
                                          UpdatePofelEnum.UPDATE_NAME,
                                      pofelId: pofel.pofelId,
                                      newName: myController.text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBarAlert(
                                      context, 'Úspěšně přejmenováno'));
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
                    style: ElevatedButton.styleFrom(primary: Colors.cyanAccent),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              BlocProvider.of<PofelBloc>(context).add(
                                  UpdatePofel(
                                      updatePofelEnum:
                                          UpdatePofelEnum.UPDATE_DESC,
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
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrangeAccent),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              if (pickedDate != DateTime.utc(1989, 11, 9)) {
                                BlocProvider.of<PofelBloc>(context).add(
                                    UpdatePofel(
                                        pofelId: pofel.pofelId,
                                        updatePofelEnum:
                                            UpdatePofelEnum.UPDATE_DATE,
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
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lightGreenAccent),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              if (myController.text.contains("spotify") ||
                                  myController.text.contains("apple")) {
                                BlocProvider.of<PofelBloc>(context).add(
                                    UpdatePofel(
                                        updatePofelEnum:
                                            UpdatePofelEnum.UPDATE_SPOTIFY,
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
                    child: const Text("Upravit spotify playlist",
                        style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.indigoAccent),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SetLocationPage(pofel: pofel)),
                      );
                    },
                    child: const Text("📍 Upravit lokaci pofelu"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                    onPressed: () {
                      BlocProvider.of<PofelBloc>(context).add(UpdatePofel(
                          updatePofelEnum: UpdatePofelEnum.UPDATE_SHOW_DRUGS,
                          pofelId: pofel.pofelId,
                          showDrugs: pofel.showDrugItems));
                    },
                    child: const Text("Zapnout/vypnout substance itemy"),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.amberAccent),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      String? uid = prefs.getString("uid");

                      PofelUserModel user = pofel.signedUsers
                          .firstWhere((user) => user.uid == uid);
                      BlocProvider.of<PofelBloc>(context).add(
                          ChatNotification(pofelId: pofel.pofelId, user: user));
                    },
                    child: const Text("Zapnout/vypnout chat notifikace",
                        style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.indigoAccent),
                    onPressed: () {
                      Alert(
                        context: context,
                        type: AlertType.none,
                        title: "Předat admina",
                        content: Column(
                          children: [
                            ReactiveForm(
                              formGroup: form,
                              child: Column(
                                children: <Widget>[
                                  ReactiveDropdownField(
                                      formControlName: 'clovek',
                                      decoration: const InputDecoration(
                                        labelText: 'Vyber ',
                                      ),
                                      items:
                                          getDropdownItems(pofel.signedUsers)),
                                ],
                              ),
                            )
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            child: const Text(
                              "Předat",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              String? uid = prefs.getString("uid");
                              if (form.control("clovek").value != "") {
                                PofelUserModel assignedUser = pofel.signedUsers
                                    .firstWhere((user) =>
                                        user.uid ==
                                        form.control("clovek").value);
                                BlocProvider.of<PofelBloc>(context).add(
                                    ChangeAdmin(
                                        pofelId: pofel.pofelId,
                                        uid: form.control("clovek").value));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBarAlert(context, 'Admin předán'));
                                Navigator.pop(context);
                              }
                            },
                            width: 120,
                          )
                        ],
                      ).show();
                    },
                    child: const Text("Předat admina"),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.indigoAccent),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      String? uid = prefs.getString("uid");

                      PofelUserModel user = pofel.signedUsers
                          .firstWhere((user) => user.uid == uid);
                      if (user.isPremium) {
                        BlocProvider.of<PofelBloc>(context).add(UpdatePofel(
                            pofelId: pofel.pofelId,
                            updatePofelEnum: UpdatePofelEnum.UPGRADE_POFEL));
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBarPremiumAlert(context, 'Pofel upgradován!'));
                      } else {
                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "Premiová feature :/",
                          desc:
                              "Tato funkce je dostupná pouze pro prémiové uživatele.",
                          buttons: [
                            DialogButton(
                              child: const Text(
                                "Zavřít",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              width: 120,
                            )
                          ],
                        ).show();
                      }
                    },
                    child: const Text("✨ Upgradovat pofel ✨",
                        style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.tealAccent),
                    onPressed: () async {
                      if (pofel.isPremium) {
                        //Check jestli je nastavená lokace
                        if (pofel.pofelLocation.latitude != 0) {
                          BlocProvider.of<PofelBloc>(context).add(UpdatePofel(
                              pofelId: pofel.pofelId,
                              updatePofelEnum: UpdatePofelEnum.UPDATE_IS_PUBLIC,
                              isPublic: pofel.isPublic));
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBarAlert(
                                  context, 'Pofel nastaven jako veřejný!'));
                        } else {
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Není nastavená lokace",
                            desc:
                                "Nejprve nastav lokaci pofelu. Až poté ho můžeš dát jako veřejný!",
                            buttons: [
                              DialogButton(
                                child: const Text(
                                  "Zavřít",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                width: 120,
                              )
                            ],
                          ).show();
                        }
                      } else {
                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "Premiová feature :/",
                          desc:
                              "Tato funkce je dostupná pouze pro prémiové pofely. Upgraduj pofel nebo mi napiš na ig a nějak se domluvíme!",
                          buttons: [
                            DialogButton(
                              child: const Text(
                                "Zavřít",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              width: 120,
                            )
                          ],
                        ).show();
                      }
                    },
                    child: pofel.isPublic
                        ? const Text("🚫Nastavit pofel jako private",
                            style: TextStyle(color: Colors.black))
                        : const Text("🌄Nastavit pofel jako veřejný",
                            style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurpleAccent),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBarAlert(context, 'Notifikace poslána'));

                              Navigator.pop(context);
                              var func = FirebaseFunctions.instance
                                  .httpsCallable("notifyPofelUsers");
                              await func.call(<String, dynamic>{
                                "messageTitle":
                                    "Notifikace z polefu " + pofel.name,
                                "messageBody": myController.text,
                                "pofelId": pofel.pofelId
                              });
                            },
                            width: 120,
                          )
                        ],
                      ).show();
                    },
                    child: const Text("📢 Pošli oznámění účastníkům pofelu"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      Alert(
                        context: context,
                        type: AlertType.none,
                        title: "Faktr??",
                        desc: "Opravdu chceš smazat pofel?",
                        content: Column(
                          children: const [],
                        ),
                        buttons: [
                          DialogButton(
                            child: const Text(
                              "🗑️🗑️",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBarAlert(context, 'Pofel smazar💀'));

                              Navigator.pop(context);
                              BlocProvider.of<PofelBloc>(context)
                                  .add(DeletePofel(pofelId: pofel.pofelId));
                            },
                            width: 120,
                          )
                        ],
                      ).show();
                    },
                    child: const Text("Smazat pofel 💀✋"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ));
}

final form = fb.group({
  'name': ['', Validators.required],
  'clovek': ["", Validators.required],
});
List<DropdownMenuItem<String>> getDropdownItems(List<PofelUserModel> users) {
  List<DropdownMenuItem<String>> items = [];
  for (PofelUserModel user in users) {
    items.add(
      DropdownMenuItem(
        child: Text(user.name),
        value: user.uid,
      ),
    );
  }
  return items;
}

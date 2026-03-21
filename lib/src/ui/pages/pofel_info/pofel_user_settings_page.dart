import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';
import 'package:pofel_app/src/ui/components/simple_date_time_picker.dart';
import 'package:pofel_app/src/ui/components/toast_premium_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/bloc/pofel_bloc/pofel_event.dart';

Widget UserSettingPage(BuildContext context, PofelModel pofel) {
  final myController = TextEditingController();
  DateTime pickedDate = DateTime.utc(1989, 11, 9);
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Alert(
                context: context,
                type: AlertType.none,
                desc: "Zadejt čas příjezdu",
                content: Column(
                  children: [
                    SimpleDateTimePicker(
                      labelText: 'Datum a cas',
                      onChanged: (value) {
                        pickedDate = value;
                      },
                    )
                  ],
                ),
                buttons: [
                  DialogButton(
                    child: const Text(
                      "Upravit",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      BlocProvider.of<PofelBloc>(context).add(UpdateWillArrive(
                          newDate: pickedDate, pofelId: pofel.pofelId));
                      Navigator.pop(context);
                    },
                    width: 120,
                  )
                ],
              ).show();
            },
            child: const Text("Upravit čas příjezdu"),
          ),
          ElevatedButton(
            onPressed: () {
              Alert(
                context: context,
                type: AlertType.none,
                desc: "Zadejt čas příjezdu",
                content: Column(
                  children: [
                    SimpleDateTimePicker(
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      labelText: 'Datum a cas',
                      onChanged: (value) {
                        pickedDate = value;
                      },
                    )
                  ],
                ),
                buttons: [
                  DialogButton(
                    child: const Text(
                      "Upravit",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      BlocProvider.of<PofelBloc>(context).add(UpdateWillArrive(
                          newDate: pickedDate, pofelId: pofel.pofelId));
                      Navigator.pop(context);
                    },
                    width: 120,
                  )
                ],
              ).show();
            },
            child: const Text("Nastavit info pro ostatní"),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              String? uid = prefs.getString("uid");

              PofelUserModel user =
                  pofel.signedUsers.firstWhere((user) => user.uid == uid);
              BlocProvider.of<PofelBloc>(context)
                  .add(ChatNotification(pofelId: pofel.pofelId, user: user));
            },
            child: const Text("Zapnout/vypnout chat notifikace"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              String? uid = prefs.getString("uid");

              PofelUserModel user =
                  pofel.signedUsers.firstWhere((user) => user.uid == uid);
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
                  desc: "Tato funkce je dostupná pouze pro prémiové uživatele.",
                  buttons: [
                    DialogButton(
                      child: const Text(
                        "Zavřít",
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              String? uid = prefs.getString("uid");

              BlocProvider.of<PofelBloc>(context)
                  .add(RemovePerson(pofelId: pofel.pofelId, uid: uid!));
            },
            child: const Text("Opustit pofel"),
          ),
        ],
      ),
    ),
  );
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';
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
                    DateTimePicker(
                        type: DateTimePickerType.dateTime,
                        initialValue: '',
                        dateLabelText: 'Datum a čas',
                        onChanged: (val) {
                          pickedDate = DateTime.parse(val);
                        })
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
            style: ElevatedButton.styleFrom(primary: Colors.indigoAccent),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              String? uid = prefs.getString("uid");

              PofelUserModel user =
                  pofel.signedUsers.firstWhere((user) => user.uid == uid);

              BlocProvider.of<PofelBloc>(context)
                  .add(UpgradePofel(pofelId: pofel.pofelId, user: user));
            },
            child: const Text("✨ Upgradovat pofel ✨",
                style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.redAccent),
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

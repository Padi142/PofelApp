import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_event.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:intl/intl.dart';
import 'package:pofel_app/src/ui/components/pofe_user_container.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Widget PofelSignedUsers(BuildContext context, PofelModel pofel) {
  final chatsQuery = FirebaseFirestore.instance
      .collection("active_pofels")
      .doc(pofel.pofelId)
      .collection("chat")
      .orderBy("sentOn", descending: true);

  return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        Row(
          children: [
            const Expanded(
                flex: 3, child: Text("Jméno", textAlign: TextAlign.center)),
            const Expanded(
                flex: 2,
                child: Text(
                  "Dovalí v",
                  textAlign: TextAlign.center,
                )),
            Expanded(flex: 1, child: Container())
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: pofel.signedUsers.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return PofelUserContainer(
                  context, pofel.signedUsers[index], pofel);
            },
          ),
        ),
        Row(
          children: [
            Expanded(flex: 2, child: Container()),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAnalytics.instance
                      .logEvent(name: 'pofel_link_shared');

                  String link = "https://pofel.me/?invite=" + pofel.joinCode;
                  await FlutterShare.share(
                    title: pofel.name,
                    chooserTitle: pofel.name,
                    text: 'Právě jsi byl pozván na epesní pofel: ' + pofel.name,
                    linkUrl: link,
                  );
                },
                child: const Text("Pozvat lidi"),
              ),
            )
          ],
        ),
      ]));
}

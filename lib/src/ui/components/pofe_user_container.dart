import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/todo_bloc/todo_bloc_bloc.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/bloc/pofel_bloc/pofel_event.dart';

Widget PofelUserContainer(
    BuildContext context, PofelUserModel user, PofelModel pofel) {
  return Padding(
    padding: const EdgeInsets.all(2),
    child: GestureDetector(
      onTap: () {
        alert(context, pofel, user).show();
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            color: user.isPremium == true
                ? const Color.fromARGB(255, 247, 190, 67)
                : const Color(0xFF73BCFC),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  if (user.uid == pofel.adminUid)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset("assets/images/crown.png")),
                    ),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Text(user.name,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                  user.willArrive.year == DateTime.utc(1989, 11, 9).year
                      ? "idk"
                      : DateFormat('kk:mm').format(user.willArrive),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: CircleAvatar(
                  radius: 30,
                  foregroundImage: NetworkImage(user.photo),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Alert alert(
  BuildContext context,
  PofelModel pofel,
  PofelUserModel user,
) {
  return Alert(
    context: context,
    type: AlertType.none,
    title: user.name,
    content: Container(
      color: user.isPremium == true
          ? const Color.fromARGB(255, 247, 190, 67)
          : Colors.white,
      child: Column(
        children: [
          Image.network(user.photo),
          Row(
            children: const [],
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              String? uid = prefs.getString("uid");

              if (pofel.adminUid == uid! && user.uid != pofel.adminUid) {
                BlocProvider.of<PofelBloc>(context)
                    .add(RemovePerson(pofelId: pofel.pofelId, uid: user.uid));
              }
              Navigator.pop(context);
            },
            child: const Text("Vyhodit"),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
          )
        ],
      ),
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

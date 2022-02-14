import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
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
                          updatePofelEnum: UpdatePofelEnum.UPDATE_DESC,
                          pofelId: pofel.pofelId,
                          newDesc: myController.text));
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
        ],
      ));
}

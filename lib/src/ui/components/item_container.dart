import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pofel_app/src/core/bloc/pofel_items_bloc/pofel_items_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_items_bloc/pofel_items_event.dart';
import 'package:pofel_app/src/core/models/item_model.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

Widget itemContainer(BuildContext context, PofelModel pofel, ItemModel item,
    PofelItemsBloc itemBloc) {
  return GestureDetector(
    onTap: () {
      alert(context, pofel, item, itemBloc).show();
    },
    child: SizedBox(
      height: 120,
      width: 120,
      child: Stack(children: [
        Container(
          margin: const EdgeInsets.all(3),
          height: 120,
          width: 120,
          decoration: const BoxDecoration(
            color: Color(0xff7c94b6),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Text(
              item.name,
              maxLines: 3,
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 2, left: 4),
              child: Text(item.count.toString() + "x",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal)),
            )),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: Image.network(item.addedByProfilePic)),
        ),
      ]),
    ),
  );
}

Alert alert(BuildContext context, PofelModel pofel, ItemModel item,
    PofelItemsBloc itemBloc) {
  return Alert(
    context: context,
    type: AlertType.none,
    title: "Item",
    content: Column(
      children: [
        Row(
          children: [
            const Text("Jméno: ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            SizedBox(
              child: Text(item.name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
        Row(
          children: [
            const Text("Přidal: ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            Text(item.addedBy,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))
          ],
        ),
        Row(
          children: [
            const Text("Type: ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            Text(getStringFromType(item.itemType),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))
          ],
        ),
        Row(
          children: [
            const Text("Počet: ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            Text(item.count.toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))
          ],
        ),
        Row(
          children: [
            const Text("Cena: ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            Text(item.price.toString() + " Kč",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))
          ],
        ),
        Row(
          children: [
            const Text("Datum přidání: ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            Text((DateFormat('dd.MM. – kk:mm').format(item.addedOn)),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))
          ],
        ),
        ElevatedButton(
          onPressed: () {
            itemBloc.add(DeleteItem(
                uid: item.addedByUid,
                addedOn: item.addedOn,
                pofelId: pofel.pofelId));
            Navigator.pop(context);
          },
          child: const Text("Smazat"),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        )
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

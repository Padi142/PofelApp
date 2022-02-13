import 'package:flutter/material.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:intl/intl.dart';

Widget PofelInfo(BuildContext context, PofelModel pofel) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.grey,
            child: Row(
              children: [
                const Text("Join code: ",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Text(pofel.joinCode,
                    style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Datum pofelu: ",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              Text(DateFormat('dd.MM. – kk:mm').format(pofel.dateTo!),
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Expanded(flex: 5, child: Container()),
      ],
    ),
  );
}

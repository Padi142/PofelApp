import 'package:flutter/material.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:intl/intl.dart';

Widget PofelSignedUsers(BuildContext context, PofelModel pofel) {
  return Padding(
    padding: const EdgeInsets.all(15),
    child: Column(
      children: [
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
        ListView.builder(
          itemCount: pofel.signedUsers.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                height: 60,
                color: Colors.grey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 3,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Text(pofel.signedUsers[index].name,
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(DateFormat('kk:mm').format(pofel.dateTo!),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(pofel.signedUsers[index].photo,
                              height: 50, width: 50),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}

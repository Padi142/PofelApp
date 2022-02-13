import 'package:flutter/material.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';

Widget PofelSignedUsers(BuildContext context, PofelModel pofel) {
  return Padding(
    padding: const EdgeInsets.all(15),
    child: ListView.builder(
      itemCount: pofel.signedUsers.length,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(pofel.signedUsers[index].name,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(pofel.signedUsers[index].photo,
                    height: 50, width: 50),
              )
            ],
          ),
        );
      },
    ),
  );
}

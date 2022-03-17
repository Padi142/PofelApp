import 'package:flutter/material.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';
import 'package:pofel_app/src/core/models/profile_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Widget FollowerContainer(BuildContext context, ProfileModel user) {
  return Padding(
    padding: const EdgeInsets.all(2),
    child: GestureDetector(
      onTap: () {
        alert(context, user).show();
      },
      child: Container(
        height: 60,
        decoration: const BoxDecoration(
            color: Color(0xFF73BCFC),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
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
  ProfileModel user,
) {
  return Alert(
    context: context,
    type: AlertType.none,
    title: user.name,
    content: Container(
      color: Colors.white,
      child: Column(
        children: [
          Image.network(user.photo),
          Row(
            children: const [],
          ),
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

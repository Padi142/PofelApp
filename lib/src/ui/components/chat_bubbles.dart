import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pofel_app/src/core/models/message_model.dart';

Widget myChat(BuildContext context, MessageModel message) {
  return Container(
      margin: const EdgeInsets.only(left: 60, top: 3, bottom: 3, right: 3),
      decoration: const BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: AutoSizeText(message.message,
                    minFontSize: 14,
                    maxLines: 15,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(fontSize: 17)),
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(message.sentByProfilePic,
                    height: 50, width: 50),
              ),
            ),
          ),
        ],
      ));
}

Widget otherChat(BuildContext context, MessageModel message) {
  return Column(
    children: [
      Align(alignment: Alignment.bottomLeft, child: Text(message.sentByName)),
      Container(
          margin: const EdgeInsets.only(left: 3, top: 3, bottom: 3, right: 60),
          decoration: const BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(message.sentByProfilePic,
                        height: 50, width: 50),
                  ),
                ),
              ),
              Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(message.message,
                        maxLines: 12, style: const TextStyle(fontSize: 17)),
                  )),
            ],
          )),
    ],
  );
}

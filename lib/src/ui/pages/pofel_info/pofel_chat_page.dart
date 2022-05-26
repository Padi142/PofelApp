import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:pofel_app/src/core/bloc/chat_bloc/chat_bloc.dart';
import 'package:pofel_app/src/core/bloc/chat_bloc/chat_event.dart';
import 'package:pofel_app/src/core/bloc/chat_bloc/chat_state.dart';
import 'package:pofel_app/src/core/models/message_model.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:flutterfire_ui/database.dart';

import '../../../core/bloc/pofel_navigation_bloc/pofeldetailnavigation_bloc.dart';
import '../../components/chat_bubbles.dart';

Widget PofelChatPage(
    BuildContext context, PofelModel pofel, String currentUserUid) {
  BlocProvider.of<ChatBloc>(context)
      .add(LoadFirstChats(pofelId: pofel.pofelId));
  final myController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  final chatsQuery = FirebaseFirestore.instance
      .collection("active_pofels")
      .doc(pofel.pofelId)
      .collection("chat")
      .orderBy("sentOn", descending: true);

  return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        Align(
          alignment: Alignment.topLeft,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.redAccent),
              child: const Text("Zpět"),
              onPressed: () {
                BlocProvider.of<PofelDetailNavigationBloc>(context)
                    .add(const PofelInfoEvent());
              }),
        ),
        Expanded(
            flex: 4,
            child: FirestoreListView(
                pageSize: 50,
                query: chatsQuery,
                controller: _scrollController,
                reverse: true,
                itemBuilder: (context, snapshot) {
                  MessageModel message = MessageModel.fromMap(snapshot);
                  if (message.sentByUid == currentUserUid) {
                    return myChat(context, message);
                  } else {
                    return otherChat(context, message);
                  }
                },
                loadingBuilder: (context) => Column(
                      children: const [
                        Text("Discord 2.0 Loading..."),
                        CircularProgressIndicator()
                      ],
                    ))),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: TextField(
                  maxLines: 4,
                  controller: myController,
                  decoration: const InputDecoration(),
                ),
              ),
              Expanded(
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 238, 140, 255),
                          Color.fromARGB(255, 62, 182, 226)
                        ],
                      )),
                  child: InkWell(
                    onTap: () {
                      if (myController.text != "") {
                        BlocProvider.of<ChatBloc>(context).add(SendMessage(
                            message: myController.text,
                            pofelId: pofel.pofelId));
                        myController.clear();
                      }
                    },
                    child: const Center(
                      child: AutoSizeText(
                        "Poslat",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]));
}

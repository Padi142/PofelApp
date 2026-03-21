import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/chat_bloc/chat_bloc.dart';
import 'package:pofel_app/src/core/bloc/chat_bloc/chat_event.dart';
import 'package:pofel_app/src/core/bloc/chat_bloc/chat_state.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';

import '../../components/chat_bubbles.dart';

Widget PofelChatPage(
    BuildContext context, PofelModel pofel, String currentUserUid) {
  BlocProvider.of<ChatBloc>(context)
      .add(LoadFirstChats(pofelId: pofel.pofelId));
  final myController = TextEditingController();

  return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        Expanded(
          flex: 4,
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is! ChatsLoaded) {
                return Column(
                  children: const [
                    Text("Discord 2.0 Loading..."),
                    CircularProgressIndicator()
                  ],
                );
              }

              return ListView.builder(
                reverse: true,
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  final message =
                      state.messages[state.messages.length - 1 - index];
                  if (message.sentByUid == currentUserUid) {
                    return myChat(context, message);
                  }
                  return otherChat(context, message);
                },
              );
            },
          ),
        ),
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

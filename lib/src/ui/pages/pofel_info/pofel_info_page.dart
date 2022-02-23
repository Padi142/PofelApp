import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:pofel_app/src/core/models/item_model.dart';
import 'package:pofel_app/src/core/models/message_model.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:intl/intl.dart';
import 'package:pofel_app/src/ui/components/chat_bubbles.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/bloc/pofel_bloc/pofel_bloc.dart';
import '../../../core/bloc/pofel_navigation_bloc/pofeldetailnavigation_bloc.dart';

Widget PofelInfo(
    BuildContext context, PofelModel pofel, String currentUserUid) {
  final itemsQuery = FirebaseFirestore.instance
      .collection("active_pofels")
      .doc(pofel.pofelId)
      .collection("items")
      .orderBy("addedOn")
      .limit(5);
  final chatsQuery = FirebaseFirestore.instance
      .collection("active_pofels")
      .doc(pofel.pofelId)
      .collection("chat")
      .orderBy("sentOn", descending: false)
      .limit(7);
  ScrollController _scrollControler = ScrollController();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SingleChildScrollView(
      controller: _scrollControler,
      child: Scrollbar(
        controller: _scrollControler,
        thumbVisibility: true,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        const Text("Join code:"),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.10,
                          margin: const EdgeInsets.all(3),
                          child: ElevatedButton(
                            onPressed: () async {
                              String link =
                                  "https://pofel.me/?invite=" + pofel.joinCode;
                              Clipboard.setData(ClipboardData(
                                text: link,
                              ));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Zkopírováno do clipboardu")));
                              await FirebaseAnalytics.instance
                                  .logEvent(name: 'pofel_link_coppied');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Center(
                                child: Text(pofel.joinCode,
                                    style: const TextStyle(
                                        color: Colors.purple,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFF73BCFC),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Datum:"),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.10,
                          margin: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                              color: Color(0xFF73BCFC),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Center(
                              child: Text(
                                  DateFormat('dd.MM. – kk:mm')
                                      .format(pofel.dateFrom!),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Účastníků:"),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.10,
                          margin: const EdgeInsets.all(3),
                          child: ElevatedButton(
                            onPressed: () async {
                              BlocProvider.of<PofelDetailNavigationBloc>(
                                      context)
                                  .add(const PofelSignedUsersEvent());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Center(
                                child: Text(pofel.signedUsers.length.toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFF73BCFC),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
            const SizedBox(height: 5),
            Column(
              children: [
                const Text("Popis:"),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF73BCFC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: ExpansionTile(
                          title: Text(
                            pofel.description,
                            softWrap: true,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                          children: [
                            Text(
                              pofel.description,
                              maxLines: 15,
                              softWrap: true,
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                const Text("Uživatelé:"),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF73BCFC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: ListView.builder(
                        itemCount: pofel.signedUsers.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (index < 5) {
                            return Padding(
                              padding: const EdgeInsets.all(2),
                              child: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<PofelDetailNavigationBloc>(
                                          context)
                                      .add(const PofelSignedUsersEvent());
                                },
                                child: Container(
                                  height: 60,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF9BCFFD),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: AutoSizeText(
                                              pofel.signedUsers[index].name,
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.network(
                                                pofel.signedUsers[index].photo,
                                                height: 50,
                                                width: 50),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseAnalytics.instance
                          .logEvent(name: 'pofel_link_shared');

                      String link =
                          "https://pofel.me/?invite=" + pofel.joinCode;
                      await FlutterShare.share(
                        title: pofel.name,
                        chooserTitle: pofel.name,
                        text: 'Právě jsi byl pozván na epesní pofel: ' +
                            pofel.name,
                        linkUrl: link,
                      );
                    },
                    child: const Text("Pozvat lidi"),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                const Text("Poslední itemy:"),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF73BCFC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FirestoreListView(
                        pageSize: 5,
                        shrinkWrap: true,
                        query: itemsQuery,
                        itemBuilder: (context, snapshot) {
                          ItemModel item = ItemModel.fromObject(snapshot);
                          return GestureDetector(
                            onTap: () {
                              BlocProvider.of<PofelDetailNavigationBloc>(
                                      context)
                                  .add(const PofelItemsEvent());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        AutoSizeText(
                                            item.count.toString() + "x ",
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold)),
                                        AutoSizeText(item.name,
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                          item.addedByProfilePic,
                                          height: 50,
                                          width: 50),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      BlocProvider.of<PofelDetailNavigationBloc>(context)
                          .add(const PofelItemsEvent());
                    },
                    child: const Text("Přidat item"),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                const Text("Chat:"),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF73BCFC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          BlocProvider.of<PofelDetailNavigationBloc>(context)
                              .add(const LoadChatPage());
                        },
                        child: FirestoreListView(
                            query: chatsQuery,
                            shrinkWrap: true,
                            reverse: true,
                            itemBuilder: (context, snapshot) {
                              MessageModel message =
                                  MessageModel.fromMap(snapshot);
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
                                )),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}

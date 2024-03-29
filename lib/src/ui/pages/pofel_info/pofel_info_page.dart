import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:pofel_app/src/core/models/item_model.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:intl/intl.dart';
import 'package:pofel_app/src/core/models/to_do_model.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/invite_people_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final todoQuery = FirebaseFirestore.instance
      .collection("active_pofels")
      .doc(pofel.pofelId)
      .collection("todo")
      .where("isDone", isEqualTo: false)
      .limit(5);
  ScrollController _scrollControler = ScrollController();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SingleChildScrollView(
      controller: _scrollControler,
      child: Scrollbar(
        controller: _scrollControler,
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
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    margin: const EdgeInsets.all(3),
                    child: ElevatedButton(
                      onPressed: () async {
                        BlocProvider.of<PofelDetailNavigationBloc>(context)
                            .add(const LoadChatPage());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.chat_outlined,
                                color: Colors.black,
                              ),
                              AutoSizeText("Přejít do čedu",
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF73BCFC),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 5),
            Column(
              children: [
                const Text("Popis:"),
                Padding(
                  padding: const EdgeInsets.all(22),
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
                  padding: const EdgeInsets.all(22),
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
                                  decoration: BoxDecoration(
                                      color: pofel.signedUsers[index]
                                                  .isPremium ==
                                              true
                                          ? const Color.fromARGB(
                                              255, 247, 190, 67)
                                          : const Color(0xFF9BCFFD),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            children: [
                                              if (pofel
                                                      .signedUsers[index].uid ==
                                                  pofel.adminUid)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: Image.asset(
                                                          "assets/images/crown.png")),
                                                ),
                                              Expanded(
                                                child: AutoSizeText(
                                                    pofel.signedUsers[index]
                                                        .name,
                                                    style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ],
                                          ),
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
                      final prefs = await SharedPreferences.getInstance();
                      String? uid = prefs.getString("uid");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InvitePeoplePage(
                                  uid: uid!,
                                  pofel: pofel,
                                )),
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
                  padding: const EdgeInsets.all(22),
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<PofelDetailNavigationBloc>(context)
                          .add(const PofelItemsEvent());
                    },
                    child: FirestoreListView(
                        pageSize: 5,
                        shrinkWrap: true,
                        query: itemsQuery,
                        itemBuilder: (context, snapshot) {
                          ItemModel item = ItemModel.fromObject(snapshot);
                          return Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF73BCFC),
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                const Text("Poslední questy:"),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: FirestoreListView(
                      pageSize: 5,
                      shrinkWrap: true,
                      query: todoQuery,
                      itemBuilder: (context, snapshot) {
                        TodoModel todo = TodoModel.fromObject(snapshot);
                        return GestureDetector(
                          onTap: () {
                            BlocProvider.of<PofelDetailNavigationBloc>(context)
                                .add(const LoadTodosPage());
                          },
                          child: Container(
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF73BCFC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: AutoSizeText(todo.todoTitle,
                                              maxLines: 3,
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: AutoSizeText(
                                              todo.assignedToName,
                                              maxLines: 3,
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                        ),
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
                                          todo.assignedToProfilePic,
                                          height: 50,
                                          width: 50),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      BlocProvider.of<PofelDetailNavigationBloc>(context)
                          .add(const LoadTodosPage());
                    },
                    child: const Text("Přidat quest"),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Column(children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      children: [
                        const Text("Galerie:"),
                        Container(
                          margin: const EdgeInsets.all(3),
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: ElevatedButton(
                            onPressed: () async {
                              await FirebaseAnalytics.instance
                                  .logEvent(name: 'galery_opened');

                              BlocProvider.of<PofelDetailNavigationBloc>(
                                      context)
                                  .add(const LoadImageGaleryPage());
                            },
                            child: Row(
                              children: const [
                                Text("Galerie pog"),
                              ],
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 247, 190, 67),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Spotify:"),
                        Container(
                          margin: const EdgeInsets.all(3),
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: ElevatedButton(
                            onPressed: () async {
                              await FirebaseAnalytics.instance
                                  .logEvent(name: 'spotify_opened');

                              if (pofel.spotifyLink != "") {
                                launch(pofel.spotifyLink);
                              } else {
                                Alert(
                                  context: context,
                                  type: AlertType.info,
                                  title: "Spotify link",
                                  desc:
                                      "Spotify link ještě není nastaven! Řekni adminovi, aby přidal oficiální playlist pofelu, nebo aby vytvořil sdílený playlist na Spotify a každý může přidat své oblíbené tunes 🎶🎶 ",
                                  image: Image.network(
                                      "https://samsungmagazine.eu/wp-content/uploads/2017/01/spotify-logo.png"),
                                  content: Column(),
                                  buttons: [
                                    DialogButton(
                                      child: const Text(
                                        "Zavřít",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      width: 120,
                                    )
                                  ],
                                ).show();
                              }
                              // }
                            },
                            child: Row(
                              children: [
                                Image.network(
                                  "https://samsungmagazine.eu/wp-content/uploads/2017/01/spotify-logo.png",
                                  height: 45,
                                  width: 45,
                                ),
                                const Text("Spotify playlist"),
                              ],
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFF23CF5F),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Lokace:"),
                        Container(
                            margin: const EdgeInsets.all(3),
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: ElevatedButton(
                              onPressed: () async {
                                await FirebaseAnalytics.instance
                                    .logEvent(name: 'map_oppened');

                                if (pofel.pofelLocation.latitude != 0) {
                                  MapsLauncher.launchCoordinates(
                                      pofel.pofelLocation.latitude,
                                      pofel.pofelLocation.longitude);
                                } else {
                                  Alert(
                                    context: context,
                                    type: AlertType.info,
                                    title: "Lokace",
                                    desc:
                                        "Lokace ještě není nastavena. Řekni adminovi, aby ji přidal! ",
                                    image: Image.network(
                                        "https://cdn.vox-cdn.com/thumbor/Og-YmzOdoKKta2Nhy1eSK-Kma_s=/0x0:1280x800/920x613/filters:focal(538x298:742x502):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/67300861/googlemaps.0.png"),
                                    content: Column(),
                                    buttons: [
                                      DialogButton(
                                        child: const Text(
                                          "Zavřít",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        width: 120,
                                      )
                                    ],
                                  ).show();
                                }
                              },
                              child: Row(
                                children: [
                                  Image.network(
                                    "https://cdn.vox-cdn.com/thumbor/Og-YmzOdoKKta2Nhy1eSK-Kma_s=/0x0:1280x800/920x613/filters:focal(538x298:742x502):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/67300861/googlemaps.0.png",
                                    height: 45,
                                    width: 45,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  const Text("Lokace pofelu"),
                                ],
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFF23CF5F),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    ),
  );
}

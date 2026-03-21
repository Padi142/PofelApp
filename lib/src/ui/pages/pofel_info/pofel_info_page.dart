import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:pofel_app/src/core/appwrite/app_services.dart';
import 'package:pofel_app/src/core/models/item_model.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/to_do_model.dart';
import 'package:pofel_app/src/core/providers/pofel_items_provider.dart';
import 'package:pofel_app/src/core/providers/pofel_todo_provider.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/invite_people_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/bloc/pofel_navigation_bloc/pofeldetailnavigation_bloc.dart';

Widget PofelInfo(
    BuildContext context, PofelModel pofel, String currentUserUid) {
  final telemetry = AppTelemetry();
  final itemsProvider = ItemsProvider();
  final todoProvider = TodoProvider();
  final scrollControler = ScrollController();

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SingleChildScrollView(
      controller: scrollControler,
      child: Scrollbar(
        controller: scrollControler,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildJoinCodeCard(context, pofel, telemetry),
                  _buildDateCard(context, pofel),
                  _buildParticipantsCard(context, pofel),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<PofelDetailNavigationBloc>(context)
                        .add(const LoadChatPage());
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFF73BCFC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_outlined, color: Colors.black),
                      SizedBox(width: 6),
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
            ),
            _section(
              title: "Popis:",
              child: Padding(
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
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            pofel.description,
                            maxLines: 15,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _section(
              title: "Uživatelé:",
              child: Column(
                children: [
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
                          itemCount: pofel.signedUsers.length > 5
                              ? 5
                              : pofel.signedUsers.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final user = pofel.signedUsers[index];
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
                                    color: user.isPremium
                                        ? const Color.fromARGB(
                                            255, 247, 190, 67)
                                        : const Color(0xFF9BCFFD),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
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
                                              if (user.uid == pofel.adminUid)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: Image.asset(
                                                        "assets/images/crown.png"),
                                                  ),
                                                ),
                                              Expanded(
                                                child: AutoSizeText(user.name,
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
                                              user.photo,
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
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
                            ),
                          ),
                        );
                      },
                      child: const Text("Pozvat lidi"),
                    ),
                  )
                ],
              ),
            ),
            _section(
              title: "Poslední itemy:",
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<PofelDetailNavigationBloc>(context)
                            .add(const PofelItemsEvent());
                      },
                      child: FutureBuilder<List<ItemModel>>(
                        future: itemsProvider.fetchPofelItems(pofel.pofelId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final items = snapshot.data!.take(5).toList();
                          if (items.isEmpty) {
                            return const Text("Zatím tu nejsou žádné itemy");
                          }
                          return ListView.builder(
                            itemCount: items.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return Container(
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF73BCFC),
                                  borderRadius: BorderRadius.circular(10),
                                ),
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
                                            AutoSizeText("${item.count}x ",
                                                style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            AutoSizeText(item.name,
                                                style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                            item.addedByProfilePic,
                                            height: 50,
                                            width: 50,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<PofelDetailNavigationBloc>(context)
                            .add(const PofelItemsEvent());
                      },
                      child: const Text("Přidat item"),
                    ),
                  ),
                ],
              ),
            ),
            _section(
              title: "Poslední questy:",
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: FutureBuilder<List<TodoModel>>(
                      future: todoProvider.fetchTodos(pofel.pofelId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final todos = snapshot.data!
                            .where((todo) => !todo.isDone)
                            .take(5)
                            .toList();
                        if (todos.isEmpty) {
                          return const Text("Zatím tu nejsou žádné questy");
                        }
                        return ListView.builder(
                          itemCount: todos.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final todo = todos[index];
                            return GestureDetector(
                              onTap: () {
                                BlocProvider.of<PofelDetailNavigationBloc>(
                                        context)
                                    .add(const LoadTodosPage());
                              },
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF73BCFC),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: AutoSizeText(
                                                  todo.todoTitle,
                                                  maxLines: 3,
                                                  style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: AutoSizeText(
                                                  todo.assignedToName,
                                                  maxLines: 3,
                                                  style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 15,
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
                                            todo.assignedToProfilePic,
                                            height: 50,
                                            width: 50,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<PofelDetailNavigationBloc>(context)
                            .add(const LoadTodosPage());
                      },
                      child: const Text("Přidat quest"),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
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
                            await telemetry.logEvent('galery_opened');
                            BlocProvider.of<PofelDetailNavigationBloc>(context)
                                .add(const LoadImageGaleryPage());
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 247, 190, 67),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Galerie pog"),
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
                            await telemetry.logEvent('spotify_opened');
                            if (pofel.spotifyLink.isNotEmpty) {
                              await launchUrl(Uri.parse(pofel.spotifyLink));
                            } else {
                              _showInfoAlert(
                                context,
                                "Spotify link",
                                "Spotify link ještě není nastaven! Řekni adminovi, aby přidal oficiální playlist pofelu.",
                                "https://samsungmagazine.eu/wp-content/uploads/2017/01/spotify-logo.png",
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFF23CF5F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
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
                            await telemetry.logEvent('map_oppened');
                            if (pofel.pofelLocation.latitude != 0) {
                              MapsLauncher.launchCoordinates(
                                pofel.pofelLocation.latitude,
                                pofel.pofelLocation.longitude,
                              );
                            } else {
                              _showInfoAlert(
                                context,
                                "Lokace",
                                "Lokace ještě není nastavena. Řekni adminovi, aby ji přidal!",
                                "https://cdn.vox-cdn.com/thumbor/Og-YmzOdoKKta2Nhy1eSK-Kma_s=/0x0:1280x800/920x613/filters:focal(538x298:742x502):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/67300861/googlemaps.0.png",
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFF23CF5F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.network(
                                "https://cdn.vox-cdn.com/thumbor/Og-YmzOdoKKta2Nhy1eSK-Kma_s=/0x0:1280x800/920x613/filters:focal(538x298:742x502):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/67300861/googlemaps.0.png",
                                height: 45,
                                width: 45,
                              ),
                              const SizedBox(width: 3),
                              const Text("Lokace pofelu"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildJoinCodeCard(
    BuildContext context, PofelModel pofel, AppTelemetry telemetry) {
  return Column(
    children: [
      const Text("Join code:"),
      Container(
        height: MediaQuery.of(context).size.height * 0.10,
        margin: const EdgeInsets.all(3),
        child: ElevatedButton(
          onPressed: () async {
            final link = "https://pofel.me/?invite=${pofel.joinCode}";
            Clipboard.setData(ClipboardData(text: link));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Zkopírováno do clipboardu")),
            );
            await telemetry.logEvent('pofel_link_coppied');
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xFF73BCFC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            pofel.joinCode,
            style: const TextStyle(
                color: Colors.purple,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ],
  );
}

Widget _buildDateCard(BuildContext context, PofelModel pofel) {
  return Column(
    children: [
      const Text("Datum:"),
      Container(
        height: MediaQuery.of(context).size.height * 0.10,
        margin: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
            color: Color(0xFF73BCFC),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Center(
            child: Text(DateFormat('dd.MM. – kk:mm').format(pofel.dateFrom!),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    ],
  );
}

Widget _buildParticipantsCard(BuildContext context, PofelModel pofel) {
  return Column(
    children: [
      const Text("Účastníků:"),
      Container(
        height: MediaQuery.of(context).size.height * 0.10,
        margin: const EdgeInsets.all(3),
        child: ElevatedButton(
          onPressed: () {
            BlocProvider.of<PofelDetailNavigationBloc>(context)
                .add(const PofelSignedUsersEvent());
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xFF73BCFC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(pofel.signedUsers.length.toString(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    ],
  );
}

Widget _section({required String title, required Widget child}) {
  return Column(
    children: [
      const SizedBox(height: 20),
      Text(title),
      child,
    ],
  );
}

void _showInfoAlert(
  BuildContext context,
  String title,
  String description,
  String imageUrl,
) {
  Alert(
    context: context,
    type: AlertType.info,
    title: title,
    desc: description,
    image: Image.network(imageUrl),
    content: Column(),
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
  ).show();
}

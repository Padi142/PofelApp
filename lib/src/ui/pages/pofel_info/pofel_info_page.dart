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
import 'package:pofel_app/src/ui/components/gradient_icon_button.dart';
import 'package:pofel_app/src/ui/components/info_container.dart';
import 'package:pofel_app/src/ui/components/outlined_button.dart';
import 'package:pofel_app/src/ui/components/pofe_user_container.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/invite_people_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/bloc/pofel_navigation_bloc/pofeldetailnavigation_bloc.dart';

Widget PofelInfo(
    BuildContext context, PofelModel pofel, String currentUserUid) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Expanded(
          flex: 8,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF0066C3),
                            Color(0xFF7D00A9),
                          ],
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          pofel.name,
                          maxLines: 3,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 23),
                        ),
                        infoContainer(context, pofel.joinCode, "Join code:",
                            () async {
                          String link =
                              "https://pofel.me/?invite=" + pofel.joinCode;
                          Clipboard.setData(ClipboardData(
                            text: link,
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Zkopírováno do clipboardu")));
                          await FirebaseAnalytics.instance
                              .logEvent(name: 'pofel_link_coppied');
                        }),
                        infoContainer(
                            context,
                            DateFormat('dd.MM. – kk:mm')
                                .format(pofel.dateFrom!),
                            "Datum:",
                            () {}),
                        infoContainer(
                            context,
                            pofel.signedUsers.length.toString(),
                            "Účastníků:", () {
                          BlocProvider.of<PofelDetailNavigationBloc>(context)
                              .add(const PofelSignedUsersEvent());
                        }),
                        outlinedButton(context, "Přejít do chatu", Icons.chat,
                            () {
                          BlocProvider.of<PofelDetailNavigationBloc>(context)
                              .add(const LoadChatPage());
                        }),
                        outlinedButton(context, "Pozvat lidi", Icons.group_add,
                            () {
                          BlocProvider.of<PofelDetailNavigationBloc>(context)
                              .add(const PofelSignedUsersEvent());
                        }),
                        outlinedButton(context, "Itemy", Icons.shopping_bag,
                            () {
                          BlocProvider.of<PofelDetailNavigationBloc>(context)
                              .add(const PofelItemsEvent());
                        }),
                        outlinedButton(context, "Questy", Icons.question_mark,
                            () {
                          BlocProvider.of<PofelDetailNavigationBloc>(context)
                              .add(const LoadTodosPage());
                        }),
                        const SizedBox(height: 30),
                      ],
                    )),
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Uživatelé:",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: ListView.builder(
                    itemCount: pofel.signedUsers.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return PofelUserContainer(
                          context, pofel.signedUsers[index], pofel);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GradientIconButton(
                icon: Icons.perm_media,
                onpressed: () async {
                  await FirebaseAnalytics.instance
                      .logEvent(name: 'galery_opened');

                  BlocProvider.of<PofelDetailNavigationBloc>(context)
                      .add(const LoadImageGaleryPage());
                },
              ),
              GradientIconButton(
                  icon: Icons.music_note,
                  onpressed: () async {
                    await FirebaseAnalytics.instance
                        .logEvent(name: 'spotify_opened');

                    if (pofel.spotifyLink != "") {
                      launchUrl(Uri.parse(pofel.spotifyLink));
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            width: 120,
                          )
                        ],
                      ).show();
                    }
                  }),
              GradientIconButton(
                icon: Icons.map,
                onpressed: () async {
                  await FirebaseAnalytics.instance
                      .logEvent(name: 'map_oppened');

                  if (pofel.pofelLocation.latitude != 0) {
                    MapsLauncher.launchCoordinates(pofel.pofelLocation.latitude,
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
                },
              ),
              GradientIconButton(
                icon: Icons.settings,
                onpressed: () async {
                  BlocProvider.of<PofelDetailNavigationBloc>(context)
                      .add(PofelSettingsEvent(adminUid: pofel.adminUid));
                },
              ),
            ],
          ),
        )
      ],
    ),
  );
}

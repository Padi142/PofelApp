import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

Widget PofelInfo(BuildContext context, PofelModel pofel) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  height: double.maxFinite,
                  margin: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                      color: Color(0xFF73BCFC),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Join code: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                        Text(pofel.joinCode,
                            style: const TextStyle(
                                color: Colors.purple,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: double.maxFinite,
                  margin: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                      color: Color(0xFF73BCFC),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Datum pofelu: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                        Text(DateFormat('dd.MM. – kk:mm').format(pofel.dateTo!),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
            flex: 2,
            child: Container(
                width: double.maxFinite,
                margin: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                    color: Color(0xFF87C3FD),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Popis: ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: Text(
                          pofel.description,
                          maxLines: 10,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ))),
        Expanded(
          child: Container(),
        ),
        Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    height: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () async {
                        //if (await canLaunch(pofel.spotifyLink!)) {
                        // Launch the url which will open Spotify
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
                          const Text("Shared playlist"),
                        ],
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF23CF5F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    height: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () {
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
                                "https://cdn.freelogovectors.net/wp-content/uploads/2020/03/google-maps-logo.png"),
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
                      },
                      child: Row(
                        children: [
                          Image.network(
                            "https://cdn.freelogovectors.net/wp-content/uploads/2020/03/google-maps-logo.png",
                            height: 45,
                            width: 45,
                          ),
                          const Text("Lokace pofelu"),
                        ],
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF3AD670),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ],
    ),
  );
}

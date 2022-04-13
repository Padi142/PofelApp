import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/image_bloc/image_bloc.dart';
import 'package:pofel_app/src/core/bloc/image_bloc/image_event.dart';
import 'package:pofel_app/src/core/bloc/image_bloc/image_state.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';
import 'package:pofel_app/src/ui/components/image_detail.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/bloc/pofel_bloc/pofel_event.dart';

Widget PofelImageGalery(BuildContext context, PofelModel pofel) {
  ImageBloc imageBloc = ImageBloc();
  return Padding(
      padding: const EdgeInsets.all(15),
      child: BlocProvider(
        create: (context) => imageBloc,
        child: BlocConsumer<ImageBloc, ImageState>(
          listener: (context, state) {
            if (state is ImageStateWithData) {
              switch (state.imageStateEnum) {
                case ImageStateEnum.DONE_UPLOADIN:
                  BlocProvider.of<PofelBloc>(context)
                      .add(LoadPofel(pofelId: pofel.pofelId));
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBarAlert(context, 'Fotky nahrány'));
                  break;
                default:
                  break;
              }
            }
          },
          builder: (context, state) {
            imageBloc.add(LoadImages(pofelId: pofel.pofelId));
            if (state is ImageStateWithData) {
              if (state.imageStateEnum == ImageStateEnum.IMAGE_UPLOADED ||
                  state.imageStateEnum == ImageStateEnum.IMAGE_UPLOADING) {
                return Center(
                  child: Column(
                    children: [
                      Text(state.uploaded.toString() +
                          " nahráno z " +
                          state.totalToUpload.toString()),
                      LinearProgressIndicator(
                        value: state.uploaded / state.totalToUpload,
                      )
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    if (state.totalToUpload != 0)
                      Center(
                        child: Column(
                          children: [
                            Text(state.uploaded.toString() +
                                " nahráno z " +
                                state.totalToUpload.toString()),
                            LinearProgressIndicator(
                              value: state.uploaded / state.totalToUpload,
                            )
                          ],
                        ),
                      ),
                    state.photos.isNotEmpty
                        ? Expanded(
                            flex: 8,
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        childAspectRatio: 3 / 2,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20),
                                itemCount: state.photos.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ImageDetail(
                                                context,
                                                pofel,
                                                state.photos[index],
                                                imageBloc)),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(3),
                                      alignment: Alignment.center,
                                      child: CachedNetworkImage(
                                        imageUrl: state.photos[index].photo,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  );
                                }),
                          )
                        : Expanded(
                            flex: 8,
                            child: Column(
                                children: const [Text("Zatím žádne fotky")])),
                    Row(
                      children: [
                        Expanded(flex: 2, child: Container()),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.greenAccent),
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              String? uid = prefs.getString("uid");
                              if (pofel.photos.length <= 8) {
                                PofelUserModel user = pofel.signedUsers
                                    .firstWhere((user) => user.uid == uid);

                                await FirebaseAnalytics.instance
                                    .logEvent(name: 'pofel_photo_uploaded');
                                BlocProvider.of<ImageBloc>(context).add(
                                    UploadImages(
                                        pofelId: pofel.pofelId, user: user));
                              } else if (pofel.isPremium) {
                                PofelUserModel user = pofel.signedUsers
                                    .firstWhere((user) => user.uid == uid);

                                await FirebaseAnalytics.instance
                                    .logEvent(name: 'pofel_photo_uploaded');
                                BlocProvider.of<ImageBloc>(context).add(
                                    UploadImages(
                                        pofelId: pofel.pofelId, user: user));
                              } else {
                                Alert(
                                  context: context,
                                  type: AlertType.info,
                                  title: "galerie",
                                  desc:
                                      "Neupgradnuté pofely mají limit 8 fotek :/ Upgraduj svůj pofel!",
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
                            child: const AutoSizeText(
                              "Nahrát fotky",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                );
              }
            } else {
              return Center(
                child: Column(
                  children: const [
                    Text("Načítání fotek"),
                    CircularProgressIndicator()
                  ],
                ),
              );
            }
          },
        ),
      ));
}

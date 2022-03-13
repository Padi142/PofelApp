import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/image_bloc/image_bloc.dart';
import 'package:pofel_app/src/core/bloc/image_bloc/image_event.dart';
import 'package:pofel_app/src/core/models/pofel_image_model.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';

Widget ImageDetail(BuildContext context, PofelModel pofel, PofelImage image,
    ImageBloc imageBloc) {
  return Scaffold(
    body: SafeArea(
        child: Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Zpět")),
                ),
              ),
              Expanded(flex: 2, child: Container())
            ],
          ),
        ),
        Expanded(
            flex: 8,
            child: Hero(
              tag: "image",
              child: CachedNetworkImage(
                imageUrl: image.photo,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
              ),
            )),
        Expanded(
          child: Row(
            children: [
              Expanded(flex: 2, child: Container()),
              Expanded(
                  child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAnalytics.instance
                      .logEvent(name: 'pofel_photo_downloaded');
                  imageBloc
                      .add(DownloadImage(pofelId: pofel.pofelId, image: image));
                },
                child: const Text("Stáhnout"),
              ))
            ],
          ),
        )
      ],
    )),
  );
}

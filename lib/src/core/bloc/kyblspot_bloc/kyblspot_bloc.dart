import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:pofel_app/src/core/bloc/kyblspot_bloc/kyblspot_event.dart';
import 'package:pofel_app/src/core/bloc/kyblspot_bloc/kyblspot_state.dart';
import 'package:pofel_app/src/core/models/kyblspot_model.dart';
import 'package:pofel_app/src/core/models/kyblspot_review_model.dart';
import 'package:pofel_app/src/core/providers/kyblspots_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ui/pages/kyblspot_pages/kyblspot_details.dart';

class KyblspotBloc extends Bloc<KyblspotEvent, KyblspotState> {
  KyblspotBloc()
      : super(const KyblspotLoadedState(
            markers: [],
            spots: [],
            kyblspotEnum: KyblspotEnum.NONE,
            reviews: [])) {
    on<LoadKyblspots>(_onLoadKyblspots);
    on<LoadKyblspotReviews>(_onLoadReviews);
    on<AddReview>(_onAddReview);
    on<RemoveSpot>(_onRemoveSpot);
  }
  KyblspotsProvider kyblspotProvider = KyblspotsProvider();

  _onLoadKyblspots(LoadKyblspots event, Emitter<KyblspotState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");

    List<KyblspotModel> spots = await kyblspotProvider.fetchKyblspots(uid!);
    List<Marker> markers = [];

    for (KyblspotModel spot in spots) {
      Marker marker = Marker(
        width: 20.0,
        height: 20.0,
        point: LatLng(spot.location!.latitude, spot.location!.longitude),
        builder: (ctx) => GestureDetector(
            onTap: () {
              alert(ctx, spot).show();
            },
            child: Image.network("https://i.ibb.co/1dh7wqN/bvybv.png")),
      );
      markers.add(marker);
    }

    emit((state as KyblspotLoadedState).copyWith(
        spots: spots, kyblspotEnum: KyblspotEnum.LOADED, markers: markers));
  }

  _onLoadReviews(LoadKyblspotReviews event, Emitter<KyblspotState> emit) async {
    List<SpotReviewModel> reviews =
        await kyblspotProvider.fetchKyblspotReviews(event.spotId);

    emit((state as KyblspotLoadedState)
        .copyWith(reviews: reviews, kyblspotEnum: KyblspotEnum.REVIEWS_LOADED));
  }

  _onRemoveSpot(RemoveSpot event, Emitter<KyblspotState> emit) async {
    await kyblspotProvider.removeSpot(event.spot);
  }

  _onAddReview(AddReview event, Emitter<KyblspotState> emit) async {
    bool canReview = true;

    for (SpotReviewModel review in event.reviews) {
      if (review.reviewedByUid == event.review.reviewedByUid) {
        canReview = false;
        await kyblspotProvider.updateReview(event.review, event.spot, review);
        break;
      }
    }
    if (canReview) {
      await kyblspotProvider.addReview(event.review, event.spot);
    }
  }
}

Alert alert(BuildContext context, KyblspotModel spot) {
  return Alert(
    context: context,
    type: AlertType.none,
    content: Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0066C3),
              Color(0xFF7D00A9),
            ],
          )),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 35, bottom: 35),
        child: Column(
          children: [
            Text(spot.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            Text(spot.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  RatingStars(value: spot.rating, starCount: 5, starSize: 27),
            )
          ],
        ),
      ),
    ),
    buttons: [
      DialogButton(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0066C3),
            Color(0xFF7D00A9),
          ],
        ),
        child: const Text(
          "Otevřít v mapách",
          style: TextStyle(color: Colors.white, fontSize: 11),
        ),
        onPressed: () {
          MapsLauncher.launchCoordinates(
              spot.location!.latitude, spot.location!.longitude);
        },
      ),
      DialogButton(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0066C3),
            Color(0xFF7D00A9),
          ],
        ),
        child: const Text(
          "Recenze",
          style: TextStyle(color: Colors.white, fontSize: 11),
        ),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          String? uid = prefs.getString("uid");
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    KyblspotDetailsPage(model: spot, uid: uid!)),
          );
        },
      )
    ],
  );
}

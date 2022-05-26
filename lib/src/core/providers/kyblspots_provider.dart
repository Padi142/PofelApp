import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pofel_app/src/core/models/kyblspot_model.dart';
import 'package:pofel_app/src/core/models/kyblspot_review_model.dart';

class KyblspotsProvider {
  Future<List<KyblspotModel>> fetchKyblspots(String eventID) async {
    List<KyblspotModel> kyblspots = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("kyblspoty").get().then((querySnapshot) => {
          // ignore: avoid_function_literals_in_foreach_calls
          querySnapshot.docs.forEach((doc) {
            GeoPoint geoPoint = doc["location"];

            double lat = geoPoint.latitude;
            double lng = geoPoint.longitude;
            GeoPoint location = GeoPoint(lat, lng);

            KyblspotModel model = KyblspotModel(
                location: location,
                weight: doc["weight"].toInt(),
                rating: doc["rating"].toDouble(),
                name: doc["name"],
                spotId: doc.id,
                createdBy: doc["createdBy"],
                description: doc["description"]);

            kyblspots.add(model);
          })
        });

    return kyblspots;
  }

  Future<List<SpotReviewModel>> fetchKyblspotReviews(String spotId) async {
    List<SpotReviewModel> reviews = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("kyblspoty")
        .doc(spotId)
        .collection("reviews")
        .get()
        .then((querySnapshot) => {
              // ignore: avoid_function_literals_in_foreach_calls
              querySnapshot.docs.forEach((doc) {
                SpotReviewModel model = SpotReviewModel(
                  review: doc["review"],
                  reviewedByProfilePic: doc["reviewedByProfilePic"],
                  rating: doc["rating"],
                  reviewedByUid: doc["reviewedByUid"],
                  reviewedByName: doc["reviewedByName"],
                  isPremium: doc["isPremium"],
                  reviewId: doc.id,
                );

                reviews.add(model);
              })
            });

    return reviews;
  }

  Future<void> addKyblspot(KyblspotModel model) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection("kyblspoty").doc().set({
      "name": model.name,
      "location": GeoPoint(model.location!.latitude, model.location!.longitude),
      "description": model.description,
      "createdBy": model.createdBy,
      "createdAt": DateTime.now(),
      "weight": model.weight,
      "rating": model.rating,
    }).then((value) => print("kyblspot pridan"));
  }

  Future<void> addReview(SpotReviewModel review, KyblspotModel kyblspot) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection("kyblspoty")
        .doc(kyblspot.spotId)
        .collection("reviews")
        .doc()
        .set({
      "reviewedByUid": review.reviewedByUid,
      "reviewedByProfilePic": review.reviewedByProfilePic,
      "reviewedByName": review.reviewedByName,
      "isPremium": review.isPremium,
      "review": review.review,
      "rating": review.rating,
    }).then((value) => print("Recenze pridana"));

    double newRating = (kyblspot.weight * kyblspot.rating + review.rating) /
        (kyblspot.weight + 1);

    firestore.collection("kyblspoty").doc(kyblspot.spotId).update({
      "weight": (kyblspot.weight + 1),
      "rating": newRating,
    }).then((value) => print("Recenze pridana"));
  }

  Future<void> updateReview(SpotReviewModel review, KyblspotModel kyblspot,
      SpotReviewModel oldReview) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection("kyblspoty")
        .doc(kyblspot.spotId)
        .collection("reviews")
        .doc(oldReview.reviewId)
        .update({
      "isPremium": review.isPremium,
      "review": review.review,
      "rating": review.rating,
    }).then((value) => print("Recenze pridana"));

    double newRating =
        ((kyblspot.weight - 1) * kyblspot.rating + review.rating) /
            (kyblspot.weight);

    firestore.collection("kyblspoty").doc(kyblspot.spotId).update({
      "rating": newRating,
    }).then((value) => print("Recenze pridana"));
  }

  Future<void> removeSpot(KyblspotModel kyblspot) async {
    await FirebaseFirestore.instance
        .collection('kyblspoty')
        .doc(kyblspot.spotId)
        .collection("reviews")
        .get()
        .then((users) => {
              users.docs.forEach((user) {
                user.reference.delete();
              })
            });

    await FirebaseFirestore.instance
        .collection('kyblspoty')
        .doc(kyblspot.spotId)
        .delete()
        .then((value) => {print("Bye bye kyblspot :/ :-(")});
  }
}

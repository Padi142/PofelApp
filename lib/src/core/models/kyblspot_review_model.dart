import 'package:cloud_firestore/cloud_firestore.dart';

class SpotReviewModel {
  final String review;
  final String reviewedByProfilePic;
  final String reviewedByUid;
  final String reviewedByName;
  final String reviewId;
  final bool isPremium;
  final double rating;

  SpotReviewModel({
    required this.review,
    required this.reviewedByProfilePic,
    required this.reviewedByUid,
    required this.reviewedByName,
    required this.isPremium,
    required this.reviewId,
    required this.rating,
  });
}

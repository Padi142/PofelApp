import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/models/kyblspot_model.dart';
import 'package:pofel_app/src/core/models/kyblspot_review_model.dart';

abstract class KyblspotEvent extends Equatable {
  const KyblspotEvent();

  @override
  List<Object> get props => [];
}

class LoadKyblspots extends KyblspotEvent {
  const LoadKyblspots();

  @override
  List<Object> get props => [];
}

class LoadKyblspotReviews extends KyblspotEvent {
  final String spotId;
  const LoadKyblspotReviews({required this.spotId});

  @override
  List<Object> get props => [];
}

class RemoveSpot extends KyblspotEvent {
  final KyblspotModel spot;
  const RemoveSpot({required this.spot});

  @override
  List<Object> get props => [];
}

class AddReview extends KyblspotEvent {
  final KyblspotModel spot;
  final SpotReviewModel review;
  final List<SpotReviewModel> reviews;
  const AddReview(
      {required this.review, required this.spot, required this.reviews});

  @override
  List<Object> get props => [];
}

import 'package:equatable/equatable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:pofel_app/src/core/models/kyblspot_model.dart';
import 'package:pofel_app/src/core/models/public_pofel_model.dart';

import '../../models/kyblspot_review_model.dart';

part "kyblspot_state.g.dart";

abstract class KyblspotState extends Equatable {
  const KyblspotState();

  @override
  List<Object> get props => [];
}

@CopyWith()
class KyblspotLoadedState extends KyblspotState {
  final List<KyblspotModel> spots;
  final List<Marker> markers;
  final List<SpotReviewModel> reviews;
  final KyblspotEnum kyblspotEnum;

  const KyblspotLoadedState({
    required this.spots,
    required this.kyblspotEnum,
    required this.markers,
    required this.reviews,
  });

  @override
  List<Object> get props => [spots, markers, kyblspotEnum];
}

enum KyblspotEnum { LOADING, LOADED, NONE, REVIEWS_LOADED }
